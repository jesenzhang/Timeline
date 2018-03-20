using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;

public class UINotice : UIPage
{
    public UINotice() : base(UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
    {
       
    }

    public override void Awake(GameObject go)
    {
        this.gameObject.transform.Find("content/btn_confim").GetComponent<Button>().onClick.AddListener(() =>
        {
            Hide();
        });
    }

    public override void Refresh()
    {

    }
}
