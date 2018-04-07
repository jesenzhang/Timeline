
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
    Think =3,
    Result = 4
}
public enum GameCardType
{
    None = 0,
    Money = 1,
    MoneyAndFriend = 2,
    investigation =3
}
[Serializable]
public class Card : ICloneable
{
    public GameCardType cardType = GameCardType.None;
    public int id;
    public int[] Values;
    public object Clone()
    {
        Card outdata = new Card
        {
            cardType = cardType,
            id = id,
            Values = (int[])Values.Clone()
        };
        return outdata;
    }
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
    public RoundData[] rounds;
	public int goal = 10;

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
     

    public int CurrentRound = 0;
    public int  CurrentStep = 0;
    public int CurrentLevel = 0;

    public int MaxStep = 0;
    public int MaxRound = 0;
    public int MaxLevel = 0;

    public int DoNum = 0;
    public int UnDoNum = 0;
    public int card1;
    public int card2;
    public int card3;
    public int ChooseSide = 0;

    public float friendly = 0;
    public float Rate=0;

	public int Money=0;

	public float ForceNPCRate = -1;

    public int RemainRound
    {
        get
        {
            return levelData.rounds.Length - CurrentRound;
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
            }
        }
    }

    object[] UIRoundData;

    public int NextActions = 0;

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
            MaxRound = levelData.rounds.Length;
            InitData();
            DataReady = true;
			UIRoundData = new object[4] { roundData, RemainRound,StepType.None,level};
            UIManager.Instance.ShowUI<UIGameRound>(null, UIRoundData);
            StartCoroutine(StartBattle());
        }
    }

    //初始化数据
    public void InitData()
    {
		if(roundData.NeedPerse)
		{
        for (int i = 0; i < roundData.Rules.Length; i++)
        {
            PerseRule(ref allPerseItem, roundData.Rules[i]);
            FillProfit(ref roundData.Profit, ref allPerseItem);
			}
		}
        MaxLevel = GameData.Instance.SystemData.AllLevels.Length;
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
         

        yield return new WaitUntil(() => {
            return true;
        });
        CurrentRound = 0;
        CurrentStep = 0;
        InitStep();
    }

    public float Friendly {
        get {
			float f=0;
            if (DoNum + UnDoNum > 0)
            {
                float r = UnDoNum / (DoNum + UnDoNum);
                if (r >= 0.6f)
                {
                    f = 0.6f * (2 - r);
                }
                else
                {
                    f = 0.6f * (1 - r);
                }
            }
			f = f+friendly;
            return f;
           
        }
    }

    public int Hornor
    {
        get
        {
            return 50 - UnDoNum * 10 + DoNum * 5;
        }
    }

    public float NPCRate {
        get {
			if(ForceNPCRate>0)
				return ForceNPCRate;
			float a2 = roundData.Profit[0].y;
			float b2 = roundData.Profit[1].y;
			float c2 = roundData.Profit[2].y;
			float d2 = roundData.Profit[3].y;
			float p =0;
			if(a2>b2 && c2>d2)
			{
				p=1;
			}else if(a2<b2 && c2<d2)
			{
				p=0;
			}else
			{

            float a1 = roundData.Profit[0].x;
            float b1 = roundData.Profit[1].x;
            float c1 = roundData.Profit[2].x;
            float d1 = roundData.Profit[3].x;
            p = (d1 - b1) / (a1 - b1 - c1 + d1)+Rate;
			}
			if(p>1)
				p=1;
            return p;
        }
    }
    public float FinalNPCRate
    {
        get
        {
            float p = 0;
            if (DoNum + UnDoNum > 0)
            {
                float r = UnDoNum / (DoNum + UnDoNum);
                if (r >= 0.6f)
                {
                    p = NPCRate*Friendly;
                }
                else
                {
                    p = NPCRate * (1+Friendly);
                }
            }
			if(p>1)
				p=1;
            return p;
        }
    }
    public int EarnMoney(int type)
    {
		Money = Money+(int)roundData.Profit[type - 1].x;
		return Money;
    }

    public void UseCard(int card)
    {
        if (card == 1)
        {
            int money = GameData.Instance.SystemData.GameAllCards[card1].Values[0];
			Money+=money;
        }
        if (card == 2)
        {
            int money = GameData.Instance.SystemData.GameAllCards[card2].Values[0];
            int friend = GameData.Instance.SystemData.GameAllCards[card2].Values[1];
			friendly+=(float)friend/100f;
        }
        if (card == 3)
        {
			
        }

        DoStep();
    }
    
    public void Btn_PlayerClicked()
    {
        UseCard(1);
    }
    public void Btn_NPCClicked()
    {
        UseCard(2);
    }

    public int GetResult(bool playerchoose)
    {
        int resur = 1;
        bool NpcChoose = false;
        int p = MathUtil.GetRandom(1, 100);
        if (p < NPCRate * 100)
        {
            NpcChoose = true;
        }
        else
        {
            NpcChoose = false;
        }
        if (playerchoose && NpcChoose)
            resur = 1;
        if (playerchoose && !NpcChoose)
            resur = 2;
        if (!playerchoose && NpcChoose)
            resur = 3;
        if (!playerchoose && !NpcChoose)
            resur = 4;
        return resur;
    }

    public void Btn_DoClicked()
    {
        DoNum++;
       
        StartCoroutine(ShowResult(GetResult(true)));
       
    }
    public void Btn_UnDoClicked()
    {
        UnDoNum++;
        StartCoroutine(ShowResult(GetResult(false)));
    }
    public void Btn_UseCard1Clicked()
    {
         
    }
    public void Btn_UseCard2Clicked()
    {
		if(GameData.Instance.SystemData.GameAllCards[card3].Values.Length>0){
			ForceNPCRate = ((float)GameData.Instance.SystemData.GameAllCards[card3].Values[0])/100f;
		}
		UIManager.Instance.ShowUI<UINotice>(()=> {UseCard(3); }, "这个NPC有"+NPCRate*100+"%概率选择合作！");
    }
    public void Btn_NextClicked()
    {
        DoStep();
    }

    public IEnumerator ShowResult(int type)
    {
        UIRoundData[2] = StepType.Result;
        UIGameRound roundUI = (UIGameRound)UIManager.Instance.GetPageInstatnce<UIGameRound>();
        roundUI.UpdateDataShow();
        string show = type == 1 ? "结果公布：己方合作，对方合作" : type == 2 ? "结果公布：己方合作，对方不合作":type ==3 ? "结果公布：己方不合作，对方合作" : "结果公布：己方不合作，对方不合作";
        roundUI.SetResult(show, EarnMoney(type));
        yield return new WaitForSeconds(3);
        DoStep();
    }

    public void InitStep()
    {
        RoundStep step = levelData.rounds[CurrentRound].steps[CurrentStep];
        UIRoundData[2] = step.stepType;
        UIRoundData[1] = (object)RemainRound;
        MaxStep = levelData.rounds[CurrentRound].steps.Length;
        UIGameRound roundUI = (UIGameRound)UIManager.Instance.GetPageInstatnce<UIGameRound>();
        if (step.stepType == StepType.Think)
        {
            roundUI.SetFriend("判定你的名誉值为"+Hornor, (int)FinalNPCRate * 100);
        }
        roundUI.UpdateDataShow();
        if (step.stepType == StepType.UseCard)
        {
            NextActions = 2;
            card1 = step.CardList[0];
            card2 = step.CardList[1];
            card3 = step.CardList[2];
        }
        else
            NextActions = 1;

    }
    public void DoStep()
    {
        NextActions--;
        CheckStep();
    }

    public void CheckStep()
    {
        if (NextActions <= 0)
        {
            CurrentStep++;
            if (CurrentStep < MaxStep)
            {
                InitStep();
            }
        }
        if (CurrentStep >= MaxStep)
        {
            CurrentStep = 0;
            CurrentRound++;
            if(CurrentRound < MaxRound)
                InitStep();
        }

        if (CurrentRound >= MaxRound)
        {
            CurrentRound = 0;
            EndLevel();
        }

    }

	public  void ResetData()
	{
		CurrentRound = 0;
		CurrentStep = 0;
		CurrentLevel = 0;
		MaxStep = 0;
		MaxRound = 0;
		MaxLevel = 0;
		DoNum = 0;
		UnDoNum = 0;
		card1=0;
		card2=0;
		card3=0;
		ChooseSide = 0;
		friendly = 0;
		Rate=0;
		Money=0;
		ForceNPCRate=-1;
	}

    public void EndLevel()
    {
        CurrentLevel++;
       
			if(Money>= levelData.goal)
			{
				if (CurrentLevel < MaxLevel)
				{
					UIManager.Instance.ShowUI<UINotice>(()=>{
					friendly = 0;
					Rate=0;
					Money=0;
					ForceNPCRate=-1;
					LoadAsset(CurrentLevel);},"过关了！");
				}
				else
				{
					UIManager.Instance.ShowUI<UINotice>(()=>{
					ResetData();
					LoadAsset(CurrentLevel);},"通关了！");
				}
			}else
			{
				UIManager.Instance.ShowUI<UINotice>(()=>{
					ResetData();
					LoadAsset(CurrentLevel);},"失败了！");

			}
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
