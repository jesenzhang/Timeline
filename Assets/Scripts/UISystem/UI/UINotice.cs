using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;

public class UINotice : UIPage
{
    Text tips;

    public UINotice() : base(UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
    {
       
    }

    public override void Awake(GameObject go)
    {
        this.gameObject.transform.Find("content/btn_confim").GetComponent<Button>().onClick.AddListener(() =>
        {
            Hide();
        });
        tips = this.gameObject.transform.Find("content/Text").GetComponent<Text>();
    }
    public override void Active()
    {
        base.Active();
        tips.text = (string)data;
    }
    public override void Refresh()
    {
        
    }
}
