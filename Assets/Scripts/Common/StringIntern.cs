using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace VFrame.Common
{
    /// <summary>
    /// 字符串暂存池相关方法
    /// </summary>
    public static class StringIntern
    {
        public static string SingletonString(string str)
        {
            return string.Intern(str);
        }
    }
}