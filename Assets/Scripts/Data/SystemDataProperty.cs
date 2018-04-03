
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using EnumProperty;

/// <summary>
/// 系统的属性
/// </summary>
public class SystemDataProperty : ScriptableObject
{
    public CardProperty[] AllCards;
    public RoundProperty[] AllRounds;
    public RoleProperty[] AllRoles;
    public DeckProperty[] AllDecks;
    public LevelData[] AllLevels;
    public Card[] GameAllCards;
}
