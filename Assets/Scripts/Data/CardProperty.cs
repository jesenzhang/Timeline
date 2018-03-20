﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using EnumProperty;

/// <summary>
/// 卡牌的属性
/// </summary>
/// 
public class CardProperty : ScriptableObject ,ICloneable{

    public int tid = 0;//模板id
    public int id = 0;
    public string CardName ="";
    public string Des = "";
    public CardType type = CardType.None;
    public CardFunc func = CardFunc.None;
    public TargetType target = TargetType.None;
    public int[] Values = new int[0];

    public object Clone()
    {
        CardProperty outdata = new CardProperty() {

            id = id,
            tid = tid,
            Des = Des,
            CardName = CardName,
            type = type,
            func = func,
            target = target,
            Values = (int[])Values.Clone()
        };
        return outdata;
    }
}
