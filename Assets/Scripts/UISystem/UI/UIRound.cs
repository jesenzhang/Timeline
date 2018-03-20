
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using TMPro;


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

    TextMeshProUGUI Label_history;

    bool history_show = false;

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
        Label_history = this.transform.Find("btn_history").GetComponent<TextMeshProUGUI>();


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
        RoundProperty p = (RoundProperty)data;
        Label_Level.SetText(p.id.ToString());
        Label_Goal.SetText(p.TargetDes);
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
    }
}
