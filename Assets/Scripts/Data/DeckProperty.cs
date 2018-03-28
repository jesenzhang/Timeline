using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class DeckProperty : ScriptableObject, ICloneable
{
    public int id = 0;
    public int[] Deck;
    public object Clone()
    {
        DeckProperty outdata = new DeckProperty()
        {
            id = id,
            Deck = (int[])Deck.Clone()
        };
        return outdata;
    }
}
