using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using VFrame.UI;
using UnityEngine.UI;

public class UIBattle : UIPage {

    public UIBattle() : base(UIType.Normal, UIMode.HideOther, UICollider.None)
    {
       
    }

    public override void Awake(GameObject go)
    {
        this.transform.Find("btn_skill").GetComponent<Button>().onClick.AddListener(OnClickSkillGo);
        this.transform.Find("btn_battle").GetComponent<Button>().onClick.AddListener(OnClickGoBattle);
    }

    private void OnClickSkillGo()
    {
        //goto skill upgrade page.
    }

    private void OnClickGoBattle()
    {
        Debug.Log("should load your battle scene!");
    }
}
