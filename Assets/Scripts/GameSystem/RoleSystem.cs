using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VFrame.GameTools;

public class RoleSystem : MonoBehaviour {

    public RoleProperty property;
    public List<int> handCard = new List<int>();
    public static int MaxHandCard = 10;
    public static int MaxDeckCard = 30;
    public List<int> Deck = new List<int>();//套牌

    // Use this for initialization
    void Start() {

    }

    // Update is called once per frame
    void Update() {

    }


    //添加牌库
    public void AddCardToDeck(int card)
    {
        if (Deck.Count < MaxDeckCard)
        {
            Deck.Add(card);
        }
    }

    //添加牌库
    public void AddCardsToDeck(int[] cards)
    {
        int N = MaxDeckCard - Deck.Count;
        int M = Mathf.Min(N, cards.Length);
        for (int i = 0; i < M; i++)
        {
            Deck.Add(cards[i]);
        }
       
    }
    //发牌
    public int DealOneCard()
    {
        int index = MathUtil.GetRandom(0, Deck.Count - 1);
        int cardid = Deck[index];
        if (handCard.Count < MaxHandCard)
        {
            handCard.Add(cardid);
            Deck.RemoveAt(index);
            return cardid;
        }
        else
        {
            return -1;
        }
    }
}
