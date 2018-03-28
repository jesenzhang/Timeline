
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using DG.Tweening;

public class UIEnd : UIPage
{
    public UIEnd() : base(UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
    {

    }

    public GameObject win;
    public GameObject lose;
    public Button btn;
    public override void Awake(GameObject go)
    {
        win = this.gameObject.transform.Find("Win").gameObject;
        lose = this.gameObject.transform.Find("Lose").gameObject;
        btn = this.gameObject.transform.Find("Button").GetComponent<Button>();

        btn.onClick.AddListener(() =>
        {
            Finish();
        });
        
    }
    public override void Active()
    {
        base.Active();
        bool show = (bool)data;
        ShowWin(show);
    }

    public void Finish()
    {
        win.SetActive(false);
        lose.SetActive(false);
        btn.gameObject.SetActive(false);
        ClosePage<UIEnd>();
        ClosePage<UICardPad>();
        UIPage.ShowPage<UIMainPage>(null);
    }

    public void ShowWin(bool w)
    {
        if (w)
        {
            win.transform.localScale =  Vector3.zero;
            win.SetActive(true);
            win.transform.DOScale(1, 0.2f);
            lose.SetActive(false);
            btn.gameObject.SetActive(true);
        }
        else
        {
            lose.transform.localScale = Vector3.zero;
            lose.SetActive(true);
            lose.transform.DOScale(1, 0.2f);
            win.SetActive(false);
            btn.gameObject.SetActive(true);
        }
    }

    public override void Refresh()
    {

    }
}
