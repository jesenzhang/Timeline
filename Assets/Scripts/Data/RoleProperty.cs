using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoleProperty : ScriptableObject, ICloneable
{
    public int id;//-1 玩家
    public int Money = 0;
    public int Honor = 0;
    public int Amity = 0;
    public int DeckId = 0;

    public object Clone()
    {
        RoleProperty outdata = new RoleProperty
        {
            id = id,
            Money = Money,
            Honor = Honor,
            Amity = Amity,
            DeckId = DeckId
        };
        return outdata;
    }
}

