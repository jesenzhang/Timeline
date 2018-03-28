using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using VFrame.GameTools;
using VFrame.ABSystem;
using VFrame.UI;

public class RoundSystem : MonoBehaviour {

    enum RoundState
    {
        None = 0,
        Begin = 1,
        PlayerRurn =2,
        NpcTurn = 3,
        End = 4
    }

    public static RoundSystem Instance;

    public RoundProperty roundData;
    public RoleSystem PlayerAtt;
    public RoleSystem NPCAtt;

    public float OneRoundTime = 10;
    private float localTime = 0;
    private bool fighting = false;
    private bool DataReady = false;

    RoundState state = RoundState.None;
    UICardPad cardpad = null;
    
    public int CurrentRound = 0;
    public int RemainRound {
        get {
          return roundData.maxRound - CurrentRound/2;
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
            InitData();
            DataReady = true;
            UIRoundData = new object[4] { RoundSystem.Instance.roundData, RoundSystem.Instance.PlayerAtt.property, RoundSystem.Instance.NPCAtt.property, RoundSystem.Instance.RemainRound };
            UIManager.Instance.ShowUI<UIRound>(null, UIRoundData);
            UIManager.Instance.ShowUI<UICardPad>();
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
        RoleProperty player = GameData.Instance.SystemData.AllRoles[roundData.playerId];
        DeckProperty playerDeck = GameData.Instance.SystemData.AllDecks[player.DeckId];
        PlayerAtt = new RoleSystem
        {
            property = (RoleProperty)player.Clone(),
            Deck = new List<int>(playerDeck.Deck),
        };
        RoleProperty npc = GameData.Instance.SystemData.AllRoles[roundData.npcId];
        DeckProperty npcdeck = GameData.Instance.SystemData.AllDecks[npc.DeckId];
        NPCAtt = new RoleSystem
        {
            property = (RoleProperty)npc.Clone(),
            Deck = new List<int>(npcdeck.Deck),
        };
    }

    //开始
    public void BeginRound()
    {
        StartCoroutine(StartBattle());
    }

    //开始
    public IEnumerator StartBattle()
    {
        yield return new WaitUntil(()=> { return DataReady; });
        fighting = true;
        state = RoundState.Begin;
 
        yield return new WaitUntil(() => {
            cardpad = (UICardPad)UIManager.Instance.GetPageInstatnce<UICardPad>();
            return cardpad!=null;
        });
        cardpad.ClearTable();
        DealCards();
        CurrentRound = 0;
        if (MathUtil.GetRandom(0,1) == 1)
            state = RoundState.PlayerRurn;
        else
            state = RoundState.NpcTurn;
        UIRound round = (UIRound)UIPage.GetPageInstatnce<UIRound>();
        round.SetTurnBtn(state == RoundState.PlayerRurn?true:false);
    }
    //发牌
    public void DealCards()
    {
        if (state == RoundState.Begin)
        {
            for (int i = 0; i < RoleSystem.MaxDeckCard; i++)
            {
                PlayerAtt.AddCardToDeck(0);
                NPCAtt.AddCardToDeck(0);
            }
            for (int i = 0; i < 5; i++)
            {
                int rn =  PlayerAtt.DealOneCard();
                GameObject card = EntityCenter.Instance.GetCard(rn);
                cardpad.AddCard(1,card);
                int rnn = NPCAtt.DealOneCard();
                GameObject card2 = EntityCenter.Instance.GetCard(rnn);
                cardpad.AddCard(2, card2);
            }
        }
        else if (state == RoundState.PlayerRurn)
        {
            int rn = PlayerAtt.DealOneCard();
            GameObject card = EntityCenter.Instance.GetCard(rn);
            cardpad.AddCard(1,card);
        }
        else if (state == RoundState.NpcTurn)
        {
            int rn = NPCAtt.DealOneCard();
            GameObject card = EntityCenter.Instance.GetCard(rn);
            cardpad.AddCard(2, card);
        }
        cardpad.SortCard();
    }
    //洁厕回合结束条件
    public int CheckRoundEnd()
    {
        int n = CheckMoneyAndAmity();
        if (n != 0)
        {
            return n;
        }
        else
        {
            bool finish = CheckNotLessGoal();
            if (finish)
                return 1;
            else {
                if (CurrentRound >= roundData.maxRound)
                {
                    bool finish2 = CheckMostGoal();
                    if (finish2)
                        return 1;
                    else
                        return -1;
                }
                return 0;
            }
        }
    }

    public bool CheckNotLessGoal()
    {
        RoundGoal[] goals = roundData.Goals;
        bool gola = true;
        for (int i = 0; i < goals.Length; i++)
        {
            if(goals[i].GoalCondition == EnumProperty.RoundGoalCondition.NotLess)
                gola = gola && CaculateSystem.Instance.CheckGoal(goals[i].Target,goals[i].GoalType, goals[i].GoalCondition, ref PlayerAtt.property, ref NPCAtt.property, goals[i].Value);
        }
        return gola;
    }

    public bool CheckMostGoal()
    {
        RoundGoal[] goals = roundData.Goals;
        bool gola = true;
        for (int i = 0; i < goals.Length; i++)
        {
            if (goals[i].GoalCondition == EnumProperty.RoundGoalCondition.Most)
                gola = gola && CaculateSystem.Instance.CheckGoal(goals[i].Target, goals[i].GoalType, goals[i].GoalCondition, ref PlayerAtt.property, ref NPCAtt.property, goals[i].Value);
        }
        return gola;
    }

    public int CheckMoneyAndAmity()
    {
        if (PlayerAtt.property.Money <= 0 || PlayerAtt.property.Amity <= 0 )
        {
            return -1;
        }
        if (NPCAtt.property.Money <= 0 || NPCAtt.property.Amity <= 0)
        {
            return 1;
        }
        return 0;
    }

    //玩家使用卡牌
    public bool UseCard(CardDataObj card,int role)
    {
        if (role == 1 && state != RoundState.PlayerRurn)
        {
            return false;
        }
        if (role == 2 && state != RoundState.NpcTurn)
        {
            return false;
        }
        RoleProperty self = null;
        RoleProperty enemy = null;
        if (state == RoundState.PlayerRurn)
        {
             self = PlayerAtt.property;
             enemy = NPCAtt.property;
        }
        else if (state == RoundState.NpcTurn)
        {
             self = NPCAtt.property;
             enemy = PlayerAtt.property;
        }
        Debug.Log(card.data.CardName);
        for (int i = 0; i < card.data.functions.Length; i++)
        {
            FunctionData data = card.data.functions[i];
            if (data.target == EnumProperty.TargetType.Self || data.target == EnumProperty.TargetType.All)
            {
                CaculateSystem.Instance.Caculate(data.type, data.func, ref self, data.Values);
            }
            if (data.target == EnumProperty.TargetType.Enemy || data.target == EnumProperty.TargetType.All)
            {
                CaculateSystem.Instance.Caculate(data.type, data.func, ref enemy, data.Values);
            }
        }
       
        EntityCenter.Instance.ReleaseCard(card.gameObject);
        UIRound round = (UIRound)UIPage.GetPageInstatnce<UIRound>();
        UIRoundData[3] = RemainRound;
        round.UpdateDataShow();
        return true;
    }

 

    public void Turn()
    {
        bool turn = false;
        if (state == RoundState.PlayerRurn)
        {
            state = RoundState.NpcTurn;
            turn = false;
        }
        else if (state == RoundState.NpcTurn)
        {
            state = RoundState.PlayerRurn;
            turn = true;
        }
        UIRound round = (UIRound)UIPage.GetPageInstatnce<UIRound>();
        round.SetTurnBtn(turn);
        if(CurrentRound< roundData.maxRound)
            CurrentRound ++;
        UIRoundData[3] = RemainRound;
        round.UpdateDataShow();
        DealCards();
    }

    public void ProcessCommand()
    {

    }

    public void Tick(float deltaTime,float totalTime)
    {
        if (!fighting)
            return;
        localTime += deltaTime;

        int end = CheckRoundEnd();
        if (end != 0)
        {
            Debug.Log("RoundEnd " + end);
            state = RoundState.End;
            CurrentRound = 0;
            fighting = false;
            UIPage.ShowPage<UIEnd>(null,end == 1 ? true : false);
        }

        if (localTime > OneRoundTime)
        {
            localTime = 0;
            Turn();
            return;
        }
        else
        {
            ProcessCommand();
        }
    }
    private void Awake()
    {
        Instance = this;
    }
  
}
