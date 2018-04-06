using EnumProperty;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class RoundGoal :ICloneable
{
    public RoundGoalType GoalType = RoundGoalType.None;
    public TargetType Target = TargetType.None;
    public RoundGoalCondition GoalCondition = RoundGoalCondition.None;
    public int Value = 0;

    public object Clone()
    {
        RoundGoal outdata = new RoundGoal
        {
            GoalType = GoalType,
            Target = Target,
            GoalCondition = GoalCondition,
            Value = Value
        };
        return outdata;
    }
}

[Serializable]
public class RoundGoalProfitItem :ICloneable
{
    public RoundProfitType ProfitType = RoundProfitType.None;
    public RoundProfitSign Sign = RoundProfitSign.None;
    public RoundProfitRolePay RolePay = RoundProfitRolePay.None;
    public int Value = 0;

    public object Clone()
    {
        RoundGoalProfitItem outdata = new RoundGoalProfitItem
        {
            ProfitType = ProfitType,
            Sign = Sign,
            RolePay = RolePay,
            Value = Value
        };
        return outdata;
    }
}
[Serializable]
public class RoundGoalProfit
{
    public RoundGoalProfitItem[] GoalProfit = new RoundGoalProfitItem[0];
   
}
/// <summary>
/// 一个回合的规则数据
/// </summary>
public class RoundProperty : ScriptableObject ,ICloneable
{
    /// <summary>
    ///           NPC 0    NPC 1
    /// 玩家 0    (1,1)  (2,4)
    /// 玩家 1    (-4,2)  (-1,2)
    /// 
    /// Profit[0] = 玩家0 NPC0   Profit[1] = 玩家0 NPC1   Profit[2] = 玩家1 NPC0   Profit[3] = 玩家1 NPC1 
    /// </summary>
    public int id = 0;
    public int playerId = 0;
    public int npcId = 0;
    public int maxRound = 10;
    public Vector2[] Profit = new Vector2[4];
    public bool NeedPerse = true;
    public string[] Rules = new string[0];
    public string Des = "";
    public string TargetDes = "";
    public RoundGoal[] Goals = new RoundGoal[0];
    public string title = "Play/NPC";
    public string title0 = "卖";
    public string title1 = "买";

    public object Clone()
    {
        RoundProperty outdata = new RoundProperty
        {
            id = id,
            NeedPerse = NeedPerse,
            Des = Des,
            title = title,
            title0 = title0,
            title1 = title1,
            maxRound = maxRound,
            TargetDes = TargetDes,
            Rules = (string[])Rules.Clone(),
            Goals = (RoundGoal[])Goals.Clone(),
			Profit = (Vector2[])Profit.Clone()
        };
        return outdata;
    }
}
