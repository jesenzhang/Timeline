using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace VFrame.Common
{
    /// <summary>
    /// 非mono类的单例基类
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class Singleton<T> where T : new()
    {
        private static T instance;

        public static T Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new T();
                }
                return instance;
            }
        }
    }
}
