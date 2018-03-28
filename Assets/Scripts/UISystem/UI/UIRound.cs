
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using TMPro;
using DG.Tweening;
using StrOpe = VFrame.StringOperationUtil.OptimizedStringOperation;

public class UIRound : UIPage
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

    TextMeshProUGUI Player_Money;
    TextMeshProUGUI Player_Hornor;
    TextMeshProUGUI Player_Amity;

    TextMeshProUGUI NPC_Money;
    TextMeshProUGUI NPC_Hornor;
    TextMeshProUGUI NPC_Amity;

    GameObject RuleTable;

    Text Label_End;

    bool history_show = false;
    bool turn_show = false;
    bool rule_show = true;

    public UIRound() : base(UIType.Normal, UIMode.HideOther, UICollider.None)
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

        Player_Money = this.transform.Find("PlayerState/label_money").GetComponent<TextMeshProUGUI>();
        Player_Hornor = this.transform.Find("PlayerState/label_hornor").GetComponent<TextMeshProUGUI>();
        Player_Amity = this.transform.Find("PlayerState/label_amity").GetComponent<TextMeshProUGUI>();

        NPC_Money = this.transform.Find("NPCState/label_money").GetComponent<TextMeshProUGUI>();
        NPC_Hornor = this.transform.Find("NPCState/label_hornor").GetComponent<TextMeshProUGUI>();
        NPC_Amity = this.transform.Find("NPCState/label_amity").GetComponent<TextMeshProUGUI>();

        Label_End = this.transform.Find("btn_end/Text").GetComponent<Text>();

        RuleTable = this.transform.Find("RuleTab").gameObject;

        this.transform.Find("btn_history").GetComponent<Button>().onClick.AddListener(() =>
        {
            if (history_show == false)
            {
                history_show = true;
                ShowPage<UIHistory>(null);
            }
            else
            {
                history_show = false;
                ClosePage<UIHistory>();
            }
        });

        this.transform.Find("btn_end").GetComponent<Button>().onClick.AddListener(() =>
        {
            if (turn_show)
                return;
            SetTurnBtn(turn_show);
            RoundSystem.Instance.Turn();
        });

        this.transform.Find("btn_Rule").GetComponent<Button>().onClick.AddListener(() =>
        {
            if (rule_show == false)
            {
                rule_show = true;
                RuleTable.transform.localScale = Vector3.zero;
                RuleTable.transform.DOScale(1, 0.3f);
                RuleTable.SetActive(true);
            }
            else
            {
                rule_show = false;
                RuleTable.transform.localScale = Vector3.one;
                RuleTable.transform.DOScale(0, 0.3f);
                RuleTable.SetActive(false);
            }
        });
    }

    public void SetTurnBtn(bool playerturn)
    {
        if (playerturn == false)
        {
            turn_show = true;
            Label_End.text = "对手回合";
        }
        else
        {
            turn_show = false;
            Label_End.text = "结束回合";
        }
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
        Label_Level.SetText(StrOpe.i+"关卡："+ p.id.ToString());
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
        Player_Money.SetText(StrOpe.i + "金钱：" +player.Money.ToString());
        Player_Hornor.SetText(StrOpe.i + "荣誉：" + player.Honor.ToString());
        Player_Amity.SetText(StrOpe.i + "友好度：" + player.Amity.ToString());

        RoleProperty npc = (RoleProperty)list[2];
        NPC_Money.SetText(StrOpe.i + "金钱：" + npc.Money.ToString());
        NPC_Hornor.SetText(StrOpe.i + "荣誉：" + npc.Honor.ToString());
        NPC_Amity.SetText(StrOpe.i + "友好度：" + npc.Amity.ToString());
    }

     

}
