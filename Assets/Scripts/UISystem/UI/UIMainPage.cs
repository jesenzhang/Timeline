using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;

public class UIMainPage : UIPage {

    public UIMainPage() : base(UIType.Normal, UIMode.HideOther, UICollider.None)
    {
       
    }

    public override void Awake(GameObject go)
    { 

        this.transform.Find("Button").GetComponent<Button>().onClick.AddListener(() =>
        {
            
            RoundSystem.Instance.LoadAsset(1);

        });
    }


}
