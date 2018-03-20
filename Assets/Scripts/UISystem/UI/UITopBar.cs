using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;

public class UITopBar : UIPage {

    public UITopBar() : base(UIType.Fixed, UIMode.DoNothing, UICollider.None)
    {
       
    }

    public override void Awake(GameObject go)
    {
        this.gameObject.transform.Find("btn_back").GetComponent<Button>().onClick.AddListener(() =>
        {
            UIPage.ClosePage();
        });

        this.gameObject.transform.Find("btn_notice").GetComponent<Button>().onClick.AddListener(() =>
        {
            ShowPage<UINotice>();
        });
    }

    public override void Refresh()
    {
        base.Refresh();
        //data
    }


}
