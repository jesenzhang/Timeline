
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using VFrame.GameTools;
using VFrame.ABSystem;
using VFrame.UI;
using System;

public enum StepType
{
    None = 0,
    DoChoice = 1,
    UseCard = 2,
    Think =3
}

[Serializable]
public class RoundStep : ICloneable
{
    public StepType stepType= StepType.None;
    public int[] CardList;
    public object Clone()
    {
        RoundStep outdata = new RoundStep
        {
            stepType = stepType,
            CardList = (int[])CardList.Clone(),
        };
        return outdata;
    }
}

[Serializable]
public class RoundData : ICloneable
{
    public RoundStep[] steps;
    public object Clone()
    {
        RoundData outdata = new RoundData
        {
            steps = (RoundStep[])steps.Clone(),
        };
        return outdata;
    }
}
[Serializable]
public class LevelData : ICloneable
{
    public int totalRound = 0;
    public RoundData[] rounds;
   

    public object Clone()
    {
        LevelData outdata = new LevelData
        {
            rounds = (RoundData[])rounds.Clone(),
        };
        return outdata;
    }
}
public class GameRoundSystem : MonoBehaviour
{
    enum RoundState
    {
        None = 0,
        Begin = 1,
        PlayerRurn = 2,
        NpcTurn = 3,
        End = 4
    }
    public static GameRoundSystem Instance;

    public LevelData levelData;
    public RoundProperty roundData;
    private bool DataReady = false;

    RoundState state = RoundState.None;
    UICardPad cardpad = null;

    public int CurrentRound = 0;

    public int RemainRound
    {
        get
        {
            return levelData.totalRound - CurrentRound / 2;
        }
    }

    //解析规则配置的临时数组
    private List<RoundGoalProfitItem> allPerseItem = new List<RoundGoalProfitItem>();

    //解析支付规则字符串
    public void PerseRule(ref List<RoundGoalProfitItem> allitems, string input = "-50=B<0=D<A=9<C=100")
    {
        allitems.Clear();
        int N = input.Length;
        int start = 0;
        int length = 0;
        for (int i = 0; i < N;)
        {
            char current = input[i];
            if (current == '-' || current >= '0' && current <= '9')
            {
                i++; length++;
                if (i >= N)
                {
                    i = N - 1;
                    string num = input.Substring(start, N - start);
                    int Num = int.Parse(num);
                    RoundGoalProfitItem item = new RoundGoalProfitItem
                    {
                        ProfitType = EnumProperty.RoundProfitType.Number,
                        Value = Num
                    };
                    allitems.Add(item);
                    length = 0; start = i; i = N;
                }
                else
                {
                    char next = input[i];
                    if (next < '0' || next > '9')
                    {
                        string num = input.Substring(start, length);
                        int Num = int.Parse(num);
                        RoundGoalProfitItem item = new RoundGoalProfitItem
                        {
                            ProfitType = EnumProperty.RoundProfitType.Number,
                            Value = Num
                        };
                        allitems.Add(item); length = 0; start = i;
                    }
                }
            }
            else
            {
                if (current == '>' || current == '<' || current == '=')
                {
                    if (input[i + 1] == '=' && current != '=')
                    {
                        i = i + 2; length = 2;
                    }
                    else
                    {
                        i++; length = 1;
                    }
                    string sign = input.Substring(start, length);
                    RoundGoalProfitItem item = new RoundGoalProfitItem
                    {
                        ProfitType = EnumProperty.RoundProfitType.Sign
                    };
                    switch (sign)
                    {
                        case ">=": item.Sign = EnumProperty.RoundProfitSign.NotLess; break;
                        case ">": item.Sign = EnumProperty.RoundProfitSign.More; break;
                        case "<": item.Sign = EnumProperty.RoundProfitSign.Less; break;
                        case "<=": item.Sign = EnumProperty.RoundProfitSign.NotMore; break;
                        case "=": item.Sign = EnumProperty.RoundProfitSign.Equal; break;
                        default: item.Sign = EnumProperty.RoundProfitSign.None; break;
                    }
                    allitems.Add(item);
                    start = i; length = 0;
                }
                else
                {
                    if (current >= 'A' && current <= 'H')
                    {
                        i++; length = 1;
                        string pay = input.Substring(start, length);
                        RoundGoalProfitItem item = new RoundGoalProfitItem
                        {
                            ProfitType = EnumProperty.RoundProfitType.RolePay,
                            RolePay = (EnumProperty.RoundProfitRolePay)(current - 'A' + 1)
                        };
                        allitems.Add(item);
                        start = i; length = 0;
                    }
                }
            }
        }
    }
    //填充规则Profit
    public void FillProfit(ref Vector2[] Profit, ref List<RoundGoalProfitItem> allitems)
    {
        for (int i = 0; i < allitems.Count; i++)
        {
            RoundGoalProfitItem item = allitems[i];
            int Left = 0; int Right = 0; int numless = 0; int nummore = 0; bool LeftEqual = false; bool RightEqual = false;
            if (item.ProfitType == EnumProperty.RoundProfitType.RolePay)
            {
                for (int k = i - 1; k >= 0; k--)
                {
                    RoundGoalProfitItem item2 = allitems[k];
                    if (k == i - 1 && item2.ProfitType == EnumProperty.RoundProfitType.Sign && item2.Sign == EnumProperty.RoundProfitSign.Equal)
                    {
                        RoundGoalProfitItem item3 = allitems[i - 2];
                        if (item3.ProfitType == EnumProperty.RoundProfitType.Number)
                        {
                            LeftEqual = true; Left = item3.Value;
                            break;
                        }
                    }
                    if (item2.ProfitType == EnumProperty.RoundProfitType.Sign && item2.Sign == EnumProperty.RoundProfitSign.Less)
                    {
                        nummore++;
                    }
                    if (item2.ProfitType == EnumProperty.RoundProfitType.Number)
                    {
                        Left = item2.Value + nummore;
                        break;
                    }
                }

                for (int j = i + 1; j < allitems.Count; j++)
                {
                    RoundGoalProfitItem item2 = allitems[j];
                    if (j == i + 1 && item2.ProfitType == EnumProperty.RoundProfitType.Sign && item2.Sign == EnumProperty.RoundProfitSign.Equal)
                    {
                        RoundGoalProfitItem item3 = allitems[i + 2];
                        if (item3.ProfitType == EnumProperty.RoundProfitType.Number)
                        {
                            RightEqual = true;
                            Right = item3.Value;
                            break;
                        }
                        RightEqual = true;
                    }
                    if (item2.ProfitType == EnumProperty.RoundProfitType.Sign && item2.Sign == EnumProperty.RoundProfitSign.Less)
                    {
                        numless++;
                    }
                    if (item2.ProfitType == EnumProperty.RoundProfitType.Number)
                    {
                        Right = item2.Value - numless;
                        break;
                    }
                }
                if (Left > Right)
                {
                    Debug.LogError("Left > Right Check the Data");
                    return;
                }
                int index = (int)item.RolePay; int f = (index - 1) % 4; int xy = (index - 1) / 4; int rnum = 0;
                if (LeftEqual)
                    rnum = Left;
                else if (RightEqual)
                    rnum = Right;
                else
                {
                    rnum = MathUtil.GetRandom(Left, Right);
                }
                if (xy == 0) Profit[f].x = rnum;
                if (xy == 1) Profit[f].y = rnum;
                item.ProfitType = EnumProperty.RoundProfitType.Number;
                item.RolePay = EnumProperty.RoundProfitRolePay.None;
                item.Value = rnum;
                Debug.Log("rnum " + rnum);
            }
        }
    }

    object[] UIRoundData;


    //加载数据
    public void LoadAsset(int level)
    {
        DataReady = false;

        if (level < GameData.Instance.SystemData.AllRounds.Length)
        {
            roundData = (RoundProperty)(GameData.Instance.SystemData.AllRounds[level]).Clone();
        }

        if (level < GameData.Instance.SystemData.AllLevels.Length)
        {
            levelData = (LevelData)(GameData.Instance.SystemData.AllLevels[level]).Clone();
            InitData();
            DataReady = true;
            UIManager.Instance.ShowUI<UIGameRound>(null, UIRoundData);
            StartCoroutine(StartBattle());
        }
    }

    //初始化数据
    public void InitData()
    {
        for (int i = 0; i < roundData.Rules.Length; i++)
        {
            PerseRule(ref allPerseItem, roundData.Rules[i]);
            FillProfit(ref roundData.Profit, ref allPerseItem);
        }
    }

    //开始
    public void BeginRound()
    {
        StartCoroutine(StartBattle());
    }

    //开始
    public IEnumerator StartBattle()
    {
        yield return new WaitUntil(() => { return DataReady; });

        state = RoundState.Begin;

        yield return new WaitUntil(() => {
            return true;
        });
        CurrentRound = 0;
    }
   
    //洁厕回合结束条件
    public int CheckRoundEnd()
    {
        return 0;
    }
    


    public void ProcessCommand()
    {

    }

    public void Tick(float deltaTime, float totalTime)
    {
       
    }
    private void Awake()
    {
        Instance = this;
    }

}
