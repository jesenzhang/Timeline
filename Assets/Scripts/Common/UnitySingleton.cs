using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace VFrame.Common
{
    /// <summary>
    /// 全局的单例基类
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <seealso cref="UnityEngine.MonoBehaviour" />
    public class UnitySingleton<T> : MonoBehaviour where T : MonoBehaviour
    {
        private static T instance;

        public static T Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = FindObjectOfType<T>();

                    if (FindObjectsOfType<T>().Length > 1)
                    {
                        return instance;
                    }

                    if (instance == null)
                    {
                        string instanceName = typeof(T).Name;
                        GameObject instanceGO = GameObject.Find(instanceName);
                        if (instanceGO == null)
                            instanceGO = new GameObject(instanceName);
                        instance = instanceGO.AddComponent<T>();
                    }
                }
                return instance;
            }
        }
    }
}

