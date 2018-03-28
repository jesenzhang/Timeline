
using UnityEngine;
using System.Collections;
using VFrame.UI;
using UnityEngine.UI;
using System.Collections.Generic;

public class UICardPad : UIPage
{
    public List<GameObject> PlayerCards = new List<GameObject>();
    public List<GameObject> NPCCards = new List<GameObject>();
    GameObject PlayerBG;
    GameObject NPCBG;
    RectTransform UseCardRect;
    float Width = 0;
    float Height = 0;

    float NWidth = 0;
    float NHeight = 0;

    public UICardPad() : base(UIType.Normal, UIMode.DoNothing, UICollider.Normal)
    {

    }

    public override void Awake(GameObject go)
    {
        PlayerBG = this.transform.Find("PlayerBG").gameObject;
        NPCBG = this.transform.Find("NPCBG").gameObject;
        UseCardRect = this.transform.Find("UseCardRect").gameObject.GetComponent<RectTransform>();
        Width = PlayerBG.GetComponent<RectTransform>().rect.width;
        Height = PlayerBG.GetComponent<RectTransform>().rect.height;
        NWidth = NPCBG.GetComponent<RectTransform>().rect.width;
        NHeight = NPCBG.GetComponent<RectTransform>().rect.height;
    }

    public void SortCard()
    {
        SortCard(1);
        SortCard(2);
    }

    public void AddCard(int role,GameObject card)
    {
        if (role == 1)
        {
            PlayerCards.Add(card);
        }else
        if (role == 2)
        {
            NPCCards.Add(card);
        }
    }

    public void SortCard(int role)
    {
        List<GameObject> Cards = null;
        GameObject BG = null;
        if (role == 1)
        {
            Cards = PlayerCards;
            BG = PlayerBG;
        }
        else if (role == 2)
        {
            Cards = NPCCards;
            BG = NPCBG;
        }
        if (Cards == null)
            return;
        if (BG == null)
            return;

        int N = Cards.Count;
        float w = 0; float h = 0;
        if (N > 0)
        {
            w = PlayerCards[0].GetComponent<RectTransform>().rect.width;
            h = PlayerCards[0].GetComponent<RectTransform>().rect.height;
            float pad = 0;
            if (N * w > Width)
            {
                pad = (N * w - Width) / (N - 1);
            }
            for (int i = 0; i < Cards.Count; i++)
            {
                Cards[i].transform.parent = BG.transform;
                Cards[i].transform.localPosition = new Vector3(w * i + w / 2 - pad - Width / 2, Height / 2, 0);
                Cards[i].transform.localScale = Vector3.one;
                Cards[i].transform.localRotation = Quaternion.identity;
            }
        }
    }

    public void PlayerUseCard(CardDataObj card)
    {
        Vector2 pos =  RectTransformUtility.WorldToScreenPoint(Camera.main, card.transform.position);
        if (RectTransformUtility.RectangleContainsScreenPoint(UseCardRect, pos, Camera.main))
        {
            if (RoundSystem.Instance.UseCard(card,1))
            {
                PlayerCards.Remove(card.gameObject);
            }
        }
        SortCard(1);
    }

    public void ClearTable()
    {
        for (int i = 0; i < PlayerCards.Count; i++)
        {
            EntityCenter.Instance.ReleaseCard(PlayerCards[i].gameObject);
        }
        PlayerCards.Clear();
        for (int i = 0; i < NPCCards.Count; i++)
        {
            EntityCenter.Instance.ReleaseCard(NPCCards[i].gameObject);
        }
        NPCCards.Clear();
    }

    public override void Refresh()
    {

    }
}
