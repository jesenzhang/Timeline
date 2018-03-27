
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using System.Collections.Generic;

public class UICardPad : UIPage
{
    int MaxCard = 10;
    public List<GameObject> Cards = new List<GameObject>();

    GameObject BG;
    RectTransform UseCardRect;
    float Width = 0;
    float Height = 0;


    public UICardPad() : base(UIType.Normal, UIMode.DoNothing, UICollider.Normal)
    {

    }

    public override void Awake(GameObject go)
    {
        BG = this.transform.Find("BG").gameObject;
        UseCardRect = this.transform.Find("UseCardRect").gameObject.GetComponent<RectTransform>();
        Width = BG.GetComponent<RectTransform>().rect.width;
        Height = BG.GetComponent<RectTransform>().rect.height;
    }

    public void SortCard()
    {
        int N = Cards.Count;
        float w = 0;float h = 0;
        if (N > 0)
        {
            w = Cards[0].GetComponent<RectTransform>().rect.width;
            h = Cards[0].GetComponent<RectTransform>().rect.height;
            float pad = 0;
            if (N * w > Width)
            {
                pad = (N * w - Width) / (N - 1);
            }
            for (int i = 0; i < Cards.Count; i++)
            {
                Cards[i].transform.parent = BG.transform;
                Cards[i].transform.localPosition =new Vector3(w * i + w/2-pad - Width/2, Height/2, 0);
                Cards[i].transform.localScale = Vector3.one;
                Cards[i].transform.localRotation = Quaternion.identity;
            }
        }
    }

    public void UseCard(CardDataObj card)
    {
        Vector2 pos =  RectTransformUtility.WorldToScreenPoint(Camera.main, card.transform.position);
        if (RectTransformUtility.RectangleContainsScreenPoint(UseCardRect, pos, Camera.main))
        {
            if (RoundSystem.Instance.UseCard(card))
            {
                Cards.Remove(card.gameObject);
            }
        }
        SortCard();
    }

    public void ClearTable()
    {
        for (int i = 0; i < Cards.Count; i++)
        {
            EntityCenter.Instance.ReleaseCard(Cards[i].gameObject);
        }
        Cards.Clear();
    }

    public override void Refresh()
    {

    }
}
