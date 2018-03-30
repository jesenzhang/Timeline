
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
namespace TimelineTools
{

    [System.Serializable]
    [RequireComponent(typeof(PlayableDirector))]
    public class TimelineData : MonoBehaviour
    {

        public string PlayAseetName = "";
        PlayableDirector director;
        [SerializeField]
        public SerializableDictionaryReplaceInfo replaceDict = new SerializableDictionaryReplaceInfo();
        public Dictionary<string, Object> ObjectDict = new Dictionary<string, Object>();//资源名 -- 对象
        int replaceCount = 0;

        public PlayableDirector Director
        {
            get
            {

                if (director == null)
                {
                    director = GetComponent<PlayableDirector>();
                }
                return director;
            }

            set
            {
                director = value;
            }
        }

        public void ResetData()
        {
            ObjectDict.Clear();
        }

        public int GetReplaceCount()
        {
            return replaceCount;
        }

        //得到加载资源列表
        public ReplaceInfo[] GetResourceList()
        {
            List<ReplaceInfo> list = new List<ReplaceInfo>();
            foreach (KeyValuePair<string, ReplaceInfo> kvp in replaceDict)
            {
                if (kvp.Value.isReplace && !list.Contains(kvp.Value))
                {
                    list.Add(kvp.Value);
                }
            }
            replaceCount = list.Count;
            return list.ToArray();
        }

        //设置资源对象
        public void SetResourceObj(string key, Object obj)
        {
            if (ObjectDict.ContainsKey(key))
            {
                ObjectDict[key] = obj;
            }
            else
            {
                ObjectDict.Add(key, obj);
            }
        }

        //绑定对象
        public void ReBindObjs()
        {
            foreach (var att in Director.playableAsset.outputs)
            {
                if (replaceDict.ContainsKey(att.streamName))
                {
                    string objkey = replaceDict[att.streamName].path;
                    if (ObjectDict.ContainsKey(objkey))
                    {
                        Object obj = ObjectDict[objkey];
                        Director.SetGenericBinding(att.sourceObject, obj);
                    }
                }
            }
        }
        //替换对象
        public void ReplaceObjs()
        {
            foreach (var att in Director.playableAsset.outputs)
            {
                if (replaceDict.ContainsKey(att.streamName))
                {
                    ReplaceObj(att.streamName);
                }
            }
        }

        public void ReplaceObj(string key)
        {
            if (!replaceDict.ContainsKey(key))
                return;
            ReplaceInfo info = replaceDict[key];
            if (!info.isReplace)
                return;
            Transform objt = transform.Find(info.path);
            if (objt != null)
            {
                return;
            }
            GameObject obj = (GameObject)ObjectDict[info.path];

            if (info.dependence == null || info.dependence.Length == 0)
            {
                if (info.parentPath.Length > 0)
                {
                    Transform parent = transform.Find(info.parentPath);
                    obj.transform.SetParent(parent);
                }
                else
                {
                    obj.transform.SetParent(transform);
                }
                obj.transform.localPosition = Vector3.zero;
                obj.transform.localRotation = Quaternion.identity;
                obj.transform.localScale = Vector3.one;
            }
            else
            {
                Transform parent = transform.Find(info.parentPath);
                if (parent != null)
                {
                    obj.transform.SetParent(parent);
                    obj.transform.localPosition = Vector3.zero;
                    obj.transform.localRotation = Quaternion.identity;
                    obj.transform.localScale = Vector3.one;
                }
                else
                {
                    for (int i = 0; i < info.dependence.Length; i++)
                    {
                        string ckey = info.dependence[i];
                        ReplaceObj(ckey);
                    }
                }
            }
        }
    }
}