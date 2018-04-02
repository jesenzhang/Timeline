
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

    TextMeshProUGUI label_friend;
    TextMeshProUGUI label_NPCRate;

    GameObject RuleTable;

    Button btn_Do;
    Button btn_UnDo;
    Button btn_Card1;
    Button btn_Card2;
    Button btn_Next;

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
        Label_Profit01 = this.transform.Find("RuleTab/Profit/label_profit10").GetComponent<TextMeshProUGUI>();
        Label_Profit10 = this.transform.Find("RuleTab/Profit/label_profit01").GetComponent<TextMeshProUGUI>();
        Label_Profit11 = this.transform.Find("RuleTab/Profit/label_profit11").GetComponent<TextMeshProUGUI>();

        label_Yourchoose = this.transform.Find("label_Yourchoose").GetComponent<TextMeshProUGUI>();
        label_Result = this.transform.Find("label_Result").GetComponent<TextMeshProUGUI>();
        label_Earn = this.transform.Find("label_Earn").GetComponent<TextMeshProUGUI>();

        label_friend = this.transform.Find("label_friend").GetComponent<TextMeshProUGUI>();
        label_NPCRate = this.transform.Find("label_NPCRate").GetComponent<TextMeshProUGUI>();

        RuleTable = this.transform.Find("RuleTab").gameObject;

        btn_Do = this.transform.Find("btn_Do").GetComponent<Button>();
        btn_Do.onClick.AddListener(() =>
        {
           
        });

        btn_UnDo = this.transform.Find("btn_UnDo").GetComponent<Button>();
        btn_UnDo.onClick.AddListener(() =>
        {
        });

        btn_Card1 = this.transform.Find("btn_Card1").GetComponent<Button>();
        btn_Card1.onClick.AddListener(() =>
        {
             
        });

        btn_Card2 = this.transform.Find("btn_Card2").GetComponent<Button>();
        btn_Card2.onClick.AddListener(() =>
        {

        });
        btn_Next = this.transform.Find("btn_Next").GetComponent<Button>();
        btn_Next.onClick.AddListener(() =>
        {

        });
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
        Label_Level.SetText(StrOpe.i + "关卡：" + p.id.ToString());
        Label_Goal.SetText(StrOpe.i + "目标：" + p.TargetDes);
        Label_RoundNum.SetText(StrOpe.i + "剩余回合数：" + (int)list[3]);
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

        RoleProperty player = (RoleProperty)list[1];

        RoleProperty npc = (RoleProperty)list[2];
    }



}
