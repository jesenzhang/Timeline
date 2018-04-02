
using UnityEngine;
using System;
using System.Collections.Generic;

    [Serializable]
    public class TranslateDict
    {
        public List<string> keys;
        public List<string> values;

        public TranslateDict()
        {
            keys = new List<string>();
            values = new List<string>();
        }
    }
    public class CameraEffectTypes : ScriptableObject
    {
        private static List<Type> effectTypeList;

        private static List<string> typeNameList;

        public static bool InitData = false;
        public static List<string> typeChineseNameList =  new List<string>();
        public static Dictionary<string,string> typeChineseNameDict = new Dictionary<string, string>();
  
        public static List<Type> EffectTypeList
        {
            get
            {
                if (effectTypeList == null)
                    effectTypeList = new List<Type>();
                return effectTypeList;
            }

            set
            {
                effectTypeList = value;
            }
        }

        public static List<string> TypeNameList
        {
            get
            {
                if (typeNameList == null)
                    typeNameList = new List<string>();
                return typeNameList;
            }

            set
            {
                typeNameList = value;
            }
        }

        public static void Clean()
        {
            EffectTypeList.Clear();
            TypeNameList.Clear();
            typeChineseNameList.Clear();
            typeChineseNameDict.Clear();
        }

        public static string[] getEnums()
        {
            return typeChineseNameList.ToArray();
        }

        public static int getIndex(Type t)
        {
            if (t == null)
                return -1;

            return EffectTypeList.IndexOf(t);
        }
        public static int getIndex(string t)
        {
            if (t == null)
                return -1;

            return TypeNameList.IndexOf(t);
        }

        public static Type getType(int index)
        {
            if (index < 0 || index >= EffectTypeList.Count)
                return null;
            return EffectTypeList[index];
        }
        public static string getName(int index)
        {
            if (index < 0 || index >= TypeNameList.Count)
                return null;
            return TypeNameList[index];
        }
        public static void AddType(Type t)
        {
            if (!EffectTypeList.Contains(t))
            {
                EffectTypeList.Add(t);
                string[] names = t.ToString().Split('_');

                string chinesepath = t.ToString();
                for (int i = 0; i < names.Length; i++)
                {
                    string name = names[i];
                    if (typeChineseNameDict.ContainsKey(name))
                    {
                        string chinese = typeChineseNameDict[name];
                        chinesepath = chinesepath.Replace(name, chinese);
                    }
                }
                string newchn = chinesepath.Replace(@"_", @"/");
                typeChineseNameList.Add(newchn);
                string filePath = t.ToString().Replace(@"_", @"/");
                TypeNameList.Add(filePath);
            }
        }

        public static void SaveJson()
        {
        }

        public static void ReadJson(string data)
        {
            TranslateDict dict = JsonUtility.FromJson<TranslateDict>(data);
            if (dict.keys.Count == dict.values.Count)
            {
                int N = dict.keys.Count;
                typeChineseNameDict.Clear();
                for (int i = 0; i < N; i++)
                {
                    typeChineseNameDict.Add(dict.keys[i], dict.values[i]);
                }
            }
               
        }
    }
