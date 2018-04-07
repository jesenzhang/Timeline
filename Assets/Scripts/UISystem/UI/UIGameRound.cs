
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using TMPro;
using DG.Tweening;
using StrOpe = VFrame.StringOperationUtil.OptimizedStringOperation;

public class UIGameRound : UIPage
{
    TextMeshProUGUI Label_Level;
    TextMeshProUGUI Label_Goal;
    TextMeshProUGUI Label_RoundNum;
    TextMeshProUGUI Label_Des;
    TextMeshProUGUI Label_title0;
    TextMeshProUGUI Label_title1;
    TextMeshProUGUI Label_title2;
    TextMeshProUGUI Label_title3;
    TextMeshProUGUI Label_title4;
    TextMeshProUGUI Label_Profit00;
    TextMeshProUGUI Label_Profit01;
    TextMeshProUGUI Label_Profit10;
    TextMeshProUGUI Label_Profit11;

    TextMeshProUGUI label_Yourchoose;
    TextMeshProUGUI label_Result;
    TextMeshProUGUI label_Earn;

    TextMeshProUGUI label_useCard;

    TextMeshProUGUI label_friend;
    TextMeshProUGUI label_NPCRate;
    TextMeshProUGUI chooseSide;
    GameObject RuleTable;
    GameObject UIcollider;

    Button btn_Do;
    Button btn_UnDo;
    Button btn_Card1;
    Button btn_Card2;
    Button btn_Next;
    Button btn_Player;
    Button btn_NPC;

    bool history_show = false;
    bool turn_show = false;
    bool rule_show = true;

    public UIGameRound() : base(UIType.Normal, UIMode.HideOther, UICollider.None)
    {

    }

    public override void Awake(GameObject go)
    {
        Label_Level = this.transform.Find("LevelState/label_level").GetComponent<TextMeshProUGUI>();
        Label_Goal = this.transform.Find("LevelState/label_goal").GetComponent<TextMeshProUGUI>();
        Label_RoundNum = this.transform.Find("LevelState/label_roundnum").GetComponent<TextMeshProUGUI>();
        Label_Des = this.transform.Find("RuleTab/label_des").GetComponent<TextMeshProUGUI>();
        Label_title0 = this.transform.Find("RuleTab/Profit/label_title0").GetComponent<TextMeshProUGUI>();
        Label_title1 = this.transform.Find("RuleTab/Profit/label_title1").GetComponent<TextMeshProUGUI>();
        Label_title2 = this.transform.Find("RuleTab/Profit/label_title2").GetComponent<TextMeshProUGUI>();
        Label_title3 = this.transform.Find("RuleTab/Profit/label_title3").GetComponent<TextMeshProUGUI>();
        Label_title4 = this.transform.Find("RuleTab/Profit/label_title4").GetComponent<TextMeshProUGUI>();

        Label_Profit00 = this.transform.Find("RuleTab/Profit/label_profit00").GetComponent<TextMeshProUGUI>();
        Label_Profit01 = this.transform.Find("RuleTab/Profit/label_profit01").GetComponent<TextMeshProUGUI>();
        Label_Profit10 = this.transform.Find("RuleTab/Profit/label_profit10").GetComponent<TextMeshProUGUI>();
        Label_Profit11 = this.transform.Find("RuleTab/Profit/label_profit11").GetComponent<TextMeshProUGUI>();

        label_Yourchoose = this.transform.Find("label_Yourchoose").GetComponent<TextMeshProUGUI>();
        label_Result = this.transform.Find("label_Result").GetComponent<TextMeshProUGUI>();
        label_Earn = this.transform.Find("label_Earn").GetComponent<TextMeshProUGUI>();
        label_useCard = this.transform.Find("label_useCard").GetComponent<TextMeshProUGUI>();
        label_friend = this.transform.Find("label_friend").GetComponent<TextMeshProUGUI>();
        label_NPCRate = this.transform.Find("label_NPCRate").GetComponent<TextMeshProUGUI>();
        UIcollider = this.transform.Find("collider").gameObject;
        RuleTable = this.transform.Find("RuleTab").gameObject;
        chooseSide = this.transform.Find("chooseSide").GetComponent<TextMeshProUGUI>();

        btn_Player = this.transform.Find("ima_Player").GetComponent<Button>();
        btn_Player.onClick.AddListener(() =>
        {
            btn_Player.enabled = false;
            btn_NPC.enabled = false;
            chooseSide.gameObject.SetActive(false);
            UIcollider.SetActive(false);
            GameRoundSystem.Instance.Btn_PlayerClicked();
        });
        btn_NPC = this.transform.Find("ima_NPC").GetComponent<Button>();
        btn_NPC.onClick.AddListener(() =>
        {
            btn_Player.enabled = false;
            btn_NPC.enabled = false;
            chooseSide.gameObject.SetActive(false);
            UIcollider.SetActive(false);
            GameRoundSystem.Instance.Btn_NPCClicked();
        });


        btn_Do = this.transform.Find("btn_Do").GetComponent<Button>();
        btn_Do.onClick.AddListener(() =>
        {
            
            GameRoundSystem.Instance.Btn_DoClicked();
        });

        btn_UnDo = this.transform.Find("btn_UnDo").GetComponent<Button>();
        btn_UnDo.onClick.AddListener(() =>
        {
            GameRoundSystem.Instance.Btn_UnDoClicked(); 
        });

        btn_Card1 = this.transform.Find("btn_Card1").GetComponent<Button>();
        btn_Card1.onClick.AddListener(() =>
        {
            chooseSide.gameObject.SetActive(true);
            btn_Card1.gameObject.SetActive(false);
            UIcollider.SetActive(true);
            btn_Player.enabled = true;
            btn_NPC.enabled = true;
            GameRoundSystem.Instance.Btn_UseCard1Clicked();
        });

        btn_Card2 = this.transform.Find("btn_Card2").GetComponent<Button>();
        btn_Card2.onClick.AddListener(() =>
        {
            btn_Card2.gameObject.SetActive(false);
            GameRoundSystem.Instance.Btn_UseCard2Clicked();
        });
        btn_Next = this.transform.Find("btn_Next").GetComponent<Button>();
        btn_Next.onClick.AddListener(() =>
        {
            GameRoundSystem.Instance.Btn_NextClicked();
        });
    }

    public void SetResult(string text,int num)
    {
        label_Result.text = text;
        label_Earn.SetText("您的收益是：" + num);
    }
    public void SetFriend(string text, int num)
    {
        label_friend.text = text;
        label_NPCRate.SetText("NPC与你的合作倾向：" + num +"%");
    }

    public override void Active()
    {
        base.Active();
        UpdateDataShow();
    }

    public override void Refresh()
    {
        base.Refresh();
    }

    public void UpdateDataShow()
    {
        object[] list = (object[])data;
        RoundProperty p = (RoundProperty)list[0];
		Label_Level.SetText(StrOpe.i + "关卡：" + (int)((int)list[3]+1));
        Label_Goal.SetText(StrOpe.i + "目标：" + p.TargetDes);
        Label_RoundNum.SetText(StrOpe.i + "剩余回合数：" + (int)list[1]);
        Label_Des.SetText(p.Des);
        Label_title0.SetText(p.title);
        Label_title1.SetText(p.title0);
        Label_title2.SetText(p.title1);
        Label_title3.SetText(p.title0);
        Label_title4.SetText(p.title1);
        Label_Profit00.SetText(p.Profit[0].ToString());
        Label_Profit01.SetText(p.Profit[1].ToString());
        Label_Profit10.SetText(p.Profit[2].ToString());
        Label_Profit11.SetText(p.Profit[3].ToString());

        label_Yourchoose.gameObject.SetActive(false);
        btn_Do.gameObject.SetActive(false);
        btn_UnDo.gameObject.SetActive(false);

        label_Result.gameObject.SetActive(false);
        label_Earn.gameObject.SetActive(false);

        label_useCard.gameObject.SetActive(false);
        btn_Card1.gameObject.SetActive(false);
        btn_Card2.gameObject.SetActive(false);

        label_friend.gameObject.SetActive(false);
        label_NPCRate.gameObject.SetActive(false);
        btn_Next.gameObject.SetActive(false);
        UIcollider.SetActive(false);

        btn_Player.enabled = false;
        btn_NPC.enabled = false;
        chooseSide.gameObject.SetActive(false);

        StepType type = (StepType)list[2];
        switch (type)
        {
            case StepType.DoChoice:
                {
                    label_Yourchoose.gameObject.SetActive(true);
                    btn_Do.gameObject.SetActive(true);
                    btn_UnDo.gameObject.SetActive(true);
                    break;
                }
            case StepType.UseCard:
                {
                    label_useCard.gameObject.SetActive(true);
                    btn_Card1.gameObject.SetActive(true);
                    btn_Card2.gameObject.SetActive(true);
                    break;
                }
            case StepType.Think:
                {
                    label_friend.gameObject.SetActive(true);
                    label_NPCRate.gameObject.SetActive(true);
                    btn_Next.gameObject.SetActive(true);
                    break;
                }
            case StepType.Result:
                {
                    label_Result.gameObject.SetActive(true);
                    label_Earn.gameObject.SetActive(true);
                    break;
                }
            default: break;
        }

    }



}
