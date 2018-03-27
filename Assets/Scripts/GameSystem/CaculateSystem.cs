using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using EnumProperty;
public class CaculateSystem : MonoBehaviour {
    public static CaculateSystem Instance;

    public delegate void CaculateFunc(ref RoleProperty role , int[] Values);

    public delegate bool GoalCaculateFunc(ref RoleProperty role, ref RoleProperty Npc, int Values);

    CaculateFunc[,] FuncDict;

    GoalCaculateFunc[,] GoalCheckFuncDict;

    private void Awake()
    {
        Instance = this;
        Init();
    }

    public void Init()
    {
        string[] funcnames = Enum.GetNames(typeof(CardFunc));
        string[] typenames = Enum.GetNames(typeof(CardType));
        int n = typenames.Length;
        int m = funcnames.Length;
        FuncDict = new CaculateFunc[n,m];

        REG(CardType.Money, CardFunc.Gain, GainMoney);
        REG(CardType.Money, CardFunc.Reduce, ReduceMoney);
        REG(CardType.Hornor, CardFunc.Gain, GainHornor);
        REG(CardType.Hornor, CardFunc.Reduce, ReduceHornor);
        REG(CardType.Amity, CardFunc.Gain, GainAmity);
        REG(CardType.Amity, CardFunc.Reduce, ReduceAmity);

        string[] funcnames1 = Enum.GetNames(typeof(RoundGoalCondition));
        string[] typenames1 = Enum.GetNames(typeof(RoundGoalType));
        int n1 = typenames1.Length;
        int m1 = funcnames1.Length;
        GoalCheckFuncDict = new GoalCaculateFunc[n1, m1];

        REGGoalCheck(RoundGoalType.Money, RoundGoalCondition.NotLess, MoneyMoreThan);

    }

    public void REG(CardType type, CardFunc func, CaculateFunc cf)
    {
        int n = (int)type; int m = (int)func;
        FuncDict[n, m] = cf;
    }

    public void REGGoalCheck(RoundGoalType type, RoundGoalCondition func, GoalCaculateFunc cf)
    {
        int n = (int)type; int m = (int)func;
        GoalCheckFuncDict[n, m] = cf;
    }

    public void GainMoney(ref RoleProperty role, int[] Values)
    {
        role.Money += Values[0];
    }
    public void ReduceMoney(ref RoleProperty role, int[] Values)
    {
        role.Money -= Values[0];
    }

    public void GainHornor(ref RoleProperty role, int[] Values)
    {
        role.Honor += Values[0];
    }
    public void ReduceHornor(ref RoleProperty role, int[] Values)
    {
        role.Honor -= Values[0];
    }

    public void GainAmity(ref RoleProperty role, int[] Values)
    {
        role.Amity += Values[0];
    }
    public void ReduceAmity(ref RoleProperty role, int[] Values)
    {
        role.Amity -= Values[0];
    }

    public void Caculate(CardType type, CardFunc func, ref RoleProperty role, int[] Values)
    {
        int n = (int)type; int m = (int)func;
        if (FuncDict[n, m] == null)
        {
            Debug.LogError("方法没有注册");
            return;
        }
        FuncDict[n, m](ref role, Values);
    }


    public bool MoneyMoreThan(ref RoleProperty role, ref RoleProperty Np, int Values)
    {
        if (role.Money >= Values)
        {
            return true;
        }
        return false;
    }

    public bool MoneyMost(ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        if (role.Money >= Npc.Money)
        {
            return true;
        }
        return false;
    }

    public bool HornorMoreThan(ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        if (role.Honor >= Values)
        {
            return true;
        }
        return false;
    }

    public bool HornorMost(ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        if (role.Honor >= Npc.Honor)
        {
            return true;
        }
        return false;
    }

    public bool AmityMoreThan(ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        if (role.Amity >= Values)
        {
            return true;
        }
        return false;
    }

    public bool AmityMost(ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        if (role.Amity >= Npc.Amity)
        {
            return true;
        }
        return false;
    }

    public bool CheckGoal(TargetType target, RoundGoalType type, RoundGoalCondition func, ref RoleProperty role, ref RoleProperty Npc, int Values)
    {
        int n = (int)type; int m = (int)func;
        if (GoalCheckFuncDict[n, m] == null)
        {
            Debug.LogError("方法没有注册");
            return false;
        }

        if (target == TargetType.Self)
        {
            return GoalCheckFuncDict[n, m](ref role, ref Npc, Values);
        }

        if (target == TargetType.Enemy)
        {
            return GoalCheckFuncDict[n, m](ref Npc, ref role, Values);
        }
        if (target == TargetType.All)
        {
            bool va = GoalCheckFuncDict[n, m](ref role, ref Npc, Values);
            bool vb= GoalCheckFuncDict[n, m](ref Npc, ref role, Values);
            return va && vb;
        }
        return false;
    }
}
