using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

namespace TimelineTools
{

    [CustomEditor(typeof(TimelineData))]
    public class TimelineDataEditor : Editor
    {
        Dictionary<string, int> replacebindingCount = new Dictionary<string, int>();
        SerializableDictionaryReplaceInfo replaceDict;
        //对象与轨道的对应关系
        Dictionary<GameObject, List<string>> referDict = new Dictionary<GameObject, List<string>>();
        private ReorderableList replaceList;
        private Vector2 replace;
        bool showData = false;
        public override void OnInspectorGUI()
        {
            CheckOut();
            DrawReplay();
        }

        //得到节点的路径
        public void GetNodePath(Transform trans, ref string path)
        {
            if (path == "")
            {
                path = trans.name;
            }
            else
            {
                path = trans.name + "/" + path;
            }

            if (trans.parent != null)
            {
                GetNodePath(trans.parent, ref path);
            }
        }
        //获取对象的依赖关系
        public void GetReferInfo(GameObject obj, ref ReplaceInfo info)
        {
            Transform trans = obj.transform;
            if (trans.parent != null)
            {
                if (referDict.ContainsKey(trans.parent.gameObject))
                {
                    if (info.dependence == null)
                        info.dependence = new string[0];
                    List<string> tlist = new List<string>(info.dependence);
                    tlist.AddRange(referDict[trans.parent.gameObject]);
                    info.dependence = tlist.ToArray();
                }
                GetReferInfo(trans.parent.gameObject, ref info);
            }
        }

        //得到轨道绑定对象的GameObject
        public GameObject GetObj(PlayableDirector Director, UnityEngine.Object sourceObject)
        {
            GameObject obj = null;
            UnityEngine.Object a = (UnityEngine.Object)Director.GetGenericBinding(sourceObject);
            if (a is GameObject)
            {
                obj = (GameObject)a;
            }
            else if (a is Graphic)
            {
                Graphic ui = (Graphic)a;
                obj = ui.rectTransform.gameObject;
            }
            else if (a is CinemachineBrain)
            {
                CinemachineBrain cina = (CinemachineBrain)a;
                obj = cina.gameObject;
            }
            else if (a is Component)
            {
                Component cina = (Component)a;
                obj = cina.gameObject;
            }
            return obj;
        }

        //填充替换字典
        public void FillReplaceDict()
        {
            TimelineData data = (TimelineData)target;
            PlayableDirector Director = data.Director;
            replaceDict = data.replaceDict;
            replaceDict.Clear();
            referDict.Clear();
            replacebindingCount.Clear();
            
            SerializedObject serializedObject = new UnityEditor.SerializedObject(Director);

            SerializedProperty m_SceneBindings = serializedObject.FindProperty("m_SceneBindings");

            List<int> propertyArray = new List<int>();
            for (int i = 0; i < m_SceneBindings.arraySize; i++)
            {
                SerializedProperty property = m_SceneBindings.GetArrayElementAtIndex(i);
                if (property.FindPropertyRelative("key").objectReferenceValue == null)
                {
                    propertyArray.Add(i);
                }
            }
            foreach (int property in propertyArray)
            {
                m_SceneBindings.DeleteArrayElementAtIndex(property);
            }
            serializedObject.ApplyModifiedProperties();

            var timelineAsset = Director.playableAsset as TimelineAsset;
            data.PlayAseetName = timelineAsset.name;
            //轨道唯一性操作
            foreach (var at in timelineAsset.GetOutputTracks())
            {
                ReplaceInfo info = new ReplaceInfo();
                if (!replaceDict.ContainsKey(at.name))
                {
                    replaceDict.Add(at.name, info);
                    replacebindingCount.Add(at.name, 0);

                }
                else
                {
                    int n = replacebindingCount[at.name];
                    n++;
                    replacebindingCount[at.name] = n;
                    at.name = at.name + "_" + n;
                    replaceDict.Add(at.name, info);
                    if (!replacebindingCount.ContainsKey(at.name))
                        replacebindingCount.Add(at.name, 0);
                    else
                    {
                        int n2 = replacebindingCount[at.name];
                        n2++;
                        replacebindingCount[at.name] = n2;
                    }
                }
            }
            //
            foreach (var at in timelineAsset.outputs)
            {
                if (replaceDict.ContainsKey(at.streamName))
                {
                    GameObject obj = GetObj(Director, at.sourceObject);
                    
                    ReplaceInfo info = replaceDict[at.streamName];

                    if (obj != null)
                    {
                        string tpath = "";
                        GetNodePath(obj.transform, ref tpath);
                        //判断GameObject是否为一个Prefab的引用
                        PrefabType tt = PrefabUtility.GetPrefabType(obj);
                        if (PrefabUtility.GetPrefabType(obj) == PrefabType.PrefabInstance || PrefabUtility.GetPrefabType(obj) == PrefabType.ModelPrefabInstance)
                        {
                            UnityEngine.Object prfabObject = PrefabUtility.GetPrefabParent(obj);
                            info.res = prfabObject.name;
                        }
                        else
                        {
                            info.res = obj.name;
                        }
                       
                        info.path = tpath;
                        string[] list = info.path.Split('/');
                        int start = list[0].Length + 1;
                        int last = tpath.Length - list[list.Length - 1].Length;
                        Debug.Log(info.parentPath + "  " + start + " last" + last);
                        string objpath = info.path.Substring(start);
                        if (last > start)
                            info.parentPath = info.path.Substring(start, last - start - 1);
                        else
                            info.parentPath = "";

                        info.path = objpath;
                        info.isReplace = false;
                        Animator animator = obj.GetComponent<Animator>();
                        if (animator)
                        {
                            info.isAnimator = true;
                            if (animator.runtimeAnimatorController)
                            {
                                info.controller = animator.runtimeAnimatorController.name;
                            }
                        }
                        else
                        {
                            info.isAnimator = false;
                        }

                        if (!referDict.ContainsKey(obj))
                        {
                            referDict.Add(obj, new List<string>() { at.streamName });
                        }
                        else
                        {
                            referDict[obj].Add(at.streamName);
                        }
                    }

                }
            }
            foreach (var at in timelineAsset.outputs)
            {
                if (replaceDict.ContainsKey(at.streamName))
                {
                    GameObject obj = GetObj(Director, at.sourceObject);
                    if (obj)
                    {
                        ReplaceInfo info = replaceDict[at.streamName];
                        GetReferInfo(obj, ref info);
                    }
                }
            }

            foreach (var at in timelineAsset.GetOutputTracks())
            {
                if (at is AnimatorControlTrack)
                {
                    foreach (var clip in at.GetClips())
                    {
                        AnimatorControlClip mouthClip = clip.asset as AnimatorControlClip;
                        // the template variable comes from classes made with the playable wizard
                        AnimatorControlBehavior behaviour = mouthClip.template;
                        behaviour.Clip = null;
                        behaviour.animator = null;
                        mouthClip.template.Clip = null;
                        mouthClip.template.animator = null;
                    }
                }
                ReplaceInfo info = replaceDict[at.name];

            }
            foreach (var obj in replaceDict)
            {
                Debug.Log(obj.Key + " ---- " + obj.Value.res + "--- path : " + obj.Value.path);
            }
        }
        public void CheckOut()
        {
            if (GUILayout.Button("导出"))
            {
                ExportTimeline();
            }
            GUILayout.Space(10);
            if (GUILayout.Button("生成数据"))
            {
                FillReplaceDict();
            }
            if (GUILayout.Button(showData ? "隐藏数据" : "显示数据"))
            {
                showData = !showData;
            }
        }
        //导出资源
        public void ExportTimeline()
        {
            TimelineData data = (TimelineData)target;
            GameObject item = data.gameObject;

            // 创建一个新的对象用于导出
            GameObject obj = Instantiate(item) as GameObject;
            obj.name = item.name;
            SequenceData mit = obj.GetComponent<SequenceData>();
            if (mit == null)
            {
                mit = obj.AddComponent<SequenceData>();
            }
            mit.TimelineData = data;

            foreach (KeyValuePair<string, ReplaceInfo> kvp in data.replaceDict)
            {
                ReplaceInfo info = kvp.Value;
                if (info.isReplace && (info.dependence == null || info.dependence.Length == 0))
                {
                    Transform tt = obj.transform.Find(info.path);
                    if (tt != null)
                    {
                        GameObject.DestroyImmediate(tt.gameObject);
                    }
                }
            }

            if (!Directory.Exists("Assets/Prefabs/Timeline"))
            {
                Directory.CreateDirectory("Assets/Prefabs/Timeline");
            }
            // 保存该物件预制体
            GameObject prefab = PrefabUtility.CreatePrefab("Assets/Prefabs/Timeline/" + obj.name + ".prefab", obj);
            TimelineExportor.ExportTimelinepPrefab(new UnityEngine.Object[] { prefab });

            //AssetDatabase.DeleteAsset("Assets/Prefabs/Timeline" + obj.name + ".prefab");
            GameObject.DestroyImmediate(obj);
        }

        public void ReplaceBindingKey(string oldkey, string newkey)
        {
            TimelineData data = (TimelineData)target;
            PlayableDirector Director = data.Director;
            var timelineAsset = Director.playableAsset as TimelineAsset;
            foreach (var at in timelineAsset.GetOutputTracks())
            {
                if (at.name == oldkey)
                {
                    at.name = newkey;
                    break;
                }
            }
        }
        List<string> keys = null;
        private void DrawReplay()
        {
            if (!showData) return;
            if (replaceDict == null || replaceDict.Count <= 0)
            {
                TimelineData data = (TimelineData)target;
                PlayableDirector Director = data.Director;
                replaceDict = data.replaceDict;
            }
            if (replaceDict == null || replaceDict.Count <= 0)
                return;

            replace = EditorGUILayout.BeginScrollView(replace, GUILayout.Height(400));

            if (replaceList == null)
            {
                keys = new List<string>(replaceDict.Keys);
                replaceList = new ReorderableList(keys, typeof(List<string>), false, false, true, true);
            }

            replaceList.drawElementCallback = (Rect rect, int index, bool isActive, bool isFocused) =>
            {
                string id = keys[index];
                EditorGUI.BeginChangeCheck();
                id = EditorGUI.TextField(new Rect(rect.x, rect.y, rect.width, EditorGUIUtility.singleLineHeight), "替换编号：", id);
                if (EditorGUI.EndChangeCheck())
                {
                //不能使用已经有的id
                if (!replaceDict.ContainsKey(id))
                    {
                        ReplaceInfo info = replaceDict[keys[index]];
                        if (replaceDict.ContainsKey(id) == false)
                        {
                            ReplaceBindingKey(keys[index], id);
                            replaceDict.Remove(keys[index]);
                            replaceDict.Add(id, info);
                            replaceList = null;
                        }
                    }
                }
                replaceDict[id].res = EditorGUI.TextField(new Rect(rect.x, rect.y + EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "资源名称：", replaceDict[id].res);
                EditorGUI.TextField(new Rect(rect.x, rect.y + 2 * EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "路径：", replaceDict[id].path);
                EditorGUI.TextField(new Rect(rect.x, rect.y + 3 * EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "父节点路径：", replaceDict[id].parentPath);

                replaceDict[id].isReplace = EditorGUI.Toggle(new Rect(rect.x, rect.y + 4 * EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "是否替换：", replaceDict[id].isReplace);
                EditorGUI.Toggle(new Rect(rect.x, rect.y + 5 * EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "是否有动画：", replaceDict[id].isAnimator);
                EditorGUI.TextField(new Rect(rect.x, rect.y + 6 * EditorGUIUtility.singleLineHeight, rect.width, EditorGUIUtility.singleLineHeight), "动画控制器：", replaceDict[id].controller);

            };
            // 绘制表头
            replaceList.drawHeaderCallback = (Rect rect) =>
            {
                EditorGUI.LabelField(rect, "替换对象");
            };
            // 选择回调
            replaceList.onSelectCallback = (ReorderableList l) =>
            {
            };
            replaceList.onRemoveCallback = (ReorderableList l) =>
            {
                if (replaceDict.ContainsKey(keys[l.index]) == false)
                {
                    replaceDict.Remove(keys[l.index]);
                }
                keys.RemoveAt(l.index);
            };
            replaceList.onAddCallback = (ReorderableList l) =>
            {
                string id = "请修改该参数";
                keys.Add(id);
                if (replaceDict.ContainsKey(id) == false)
                {
                    replaceDict.Add(id, null);
                }
            };
            replaceList.elementHeight = 120;
            replaceList.DoLayoutList();
            EditorGUILayout.EndScrollView();

        }
    }
}