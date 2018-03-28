using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using TMPro;
using StrOpe = VFrame.StringOperationUtil.OptimizedStringOperation;

public class UIMainPage : UIPage {

    Scrollbar scrollbar;
    int chooseLevel = 0;
    TextMeshProUGUI levelnum;
    public UIMainPage() : base(UIType.Normal, UIMode.HideOther, UICollider.None)
    {
       
    }

    public override void Awake(GameObject go)
    {
        levelnum = this.transform.Find("LevelNum").GetComponent<TextMeshProUGUI>();
        scrollbar = this.transform.Find("Scrollbar").GetComponent<Scrollbar>();
        int N = GameData.Instance.SystemData.AllRounds.Length;
       // scrollbar.size =1.0f/N;
        scrollbar.numberOfSteps = N;
        scrollbar.onValueChanged.AddListener((float t) => {
            chooseLevel =Mathf.FloorToInt(t * (N-1));
            levelnum.SetText(StrOpe.i + chooseLevel);
        });

        this.transform.Find("Button").GetComponent<Button>().onClick.AddListener(() =>
        {
            RoundSystem.Instance.LoadAsset(chooseLevel);

        });
    }


}
