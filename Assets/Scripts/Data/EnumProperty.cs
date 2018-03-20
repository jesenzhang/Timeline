using System.Collections;
using System.Collections.Generic;
using UnityEngine;

 namespace EnumProperty {

    /// <summary>
    /// 卡牌类型
    /// </summary>
    public enum CardType
    {
        None = 0,
        Money = 1,
        Hornor = 2,
        Amity = 3,//友好
        Pay = 4,//支付
        Buff = 5,
        Magic = 6 //锦囊牌
    }

    /// <summary>
    /// 作用对象
    /// </summary>
    public enum TargetType
    {
        None = 0,
        Self = 1,
        Enemy = 2,
        All = 3
    }

    /// <summary>
    /// 卡牌作用
    /// </summary>
    public enum CardFunc
    {
        None = 0,
        Gain = 1,
        Reduce = 2,
        Spy = 3,//侦查
        Disguise = 4,//伪装
        Substitute = 5,//置换
        AddBuff =6,
        RemoveBuff = 7,
        Recover = 8 //恢复
    }

    public enum RoundGoalType
    {
        None = 0,
        Money = 1,
        Hornor = 2,
        Amity = 3,//友好
    }
    
    public enum RoundGoalCondition
    {
        None = 0,
        Most = 1,
        NotLess = 2,
    }
    //公式数组里数据的类型
    public enum RoundProfitType
    {
        None = 0,
        Number = 1,
        Sign = 2,
        RolePay = 3
    }
    //公式数组里数据的类型
    public enum RoundProfitSign
    {
        None = 0,
        More = 1,// >
        Less = 2,// <
        Equal = 3,// =
        NotLess = 4,// >=
        NotMore = 5,// <=
    }
    //
    public enum RoundProfitRolePay
    {
        None = 0,
        A = 1,
        B = 2,
        C = 3,
        D = 4,
        E = 5,
        F = 6,
        G = 7,
        H = 8,
    }
}
