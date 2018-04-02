

using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using TimelineTools;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[CustomPropertyDrawer(typeof(CameraEffectBehaviour))]
public class CameraEffectDrawer : PropertyDrawer
{
    List<string> names = new List<string>(); 
    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        int fieldCount = 1;
        return fieldCount * EditorGUIUtility.singleLineHeight;
    }
    

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        CameraEffectClip cameraeffect = (CameraEffectClip)property.serializedObject.targetObject;

        if (cameraeffect.camera == null)
        {
            EditorGUILayout.HelpBox("请先设置相机 ", MessageType.Error);
            return;
        }

        if (CameraEffectTypes.InitData == false)
        {
            LoadCameraEffects();
            CameraEffectTypes.InitData = true;
        }

        if (cameraeffect.EffectType!=null)
        {
            cameraeffect.EffectObj = (MonoBehaviour)cameraeffect.camera.gameObject.GetComponent(cameraeffect.EffectType);
        }
    
        int newselect = EditorGUILayout.Popup("Select Effect:", cameraeffect.EffectIndex, CameraEffectTypes.getEnums());
        if (cameraeffect.EffectIndex != newselect)
        {
            cameraeffect.EffectIndex = newselect;
            cameraeffect.EffectName = CameraEffectTypes.getName(cameraeffect.EffectIndex);
            if (cameraeffect.EffectObj != null)
            {
                GameObject.DestroyImmediate(cameraeffect.EffectObj); 
            }
            cameraeffect.EffectType =CameraEffectTypes.getType(cameraeffect.EffectIndex);
            cameraeffect.EffectObj = (MonoBehaviour)cameraeffect.camera.gameObject.AddComponent(cameraeffect.EffectType);
            cameraeffect.Effect.exposedName = cameraeffect.EffectType.ToString();
            cameraeffect.Effect.defaultValue = cameraeffect.EffectObj;
            cameraeffect.director.SetReferenceValue(cameraeffect.Effect.exposedName, cameraeffect.EffectObj);
            cameraeffect.EffectObj.enabled = false;
        }
        Type effectype = cameraeffect.EffectType;
        if (effectype != null)
        {
            FieldInfo[] fields = effectype.GetFields();
            foreach (FieldInfo f in fields)
            {
                if (f.IsPublic)
                    if (f.FieldType == typeof(bool))
                    {
                        bool oldvalue = (bool)f.GetValue(cameraeffect.EffectObj);
                        bool newvalue = EditorGUILayout.Toggle(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    {
                    if (f.FieldType == typeof(string))
                    {
                        string oldvalue = (string)f.GetValue(cameraeffect.EffectObj);
                        string newvalue = EditorGUILayout.TextField(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(float))
                    {
                        float oldvalue = (float)f.GetValue(cameraeffect.EffectObj);
                        float newvalue = EditorGUILayout.FloatField(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(int))
                    {
                        int oldvalue = (int)f.GetValue(cameraeffect.EffectObj);
                        int newvalue = EditorGUILayout.IntField(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(Vector2))
                    {
                        Vector2 oldvalue = (Vector2)f.GetValue(cameraeffect.EffectObj);
                        Vector2 newvalue = EditorGUILayout.Vector2Field(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(Vector3))
                    {
                        Vector3 oldvalue = (Vector3)f.GetValue(cameraeffect.EffectObj);
                        Vector3 newvalue = EditorGUILayout.Vector3Field(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(Vector4))
                    {
                        Vector4 oldvalue = (Vector4)f.GetValue(cameraeffect.EffectObj);
                        Vector4 newvalue = EditorGUILayout.Vector4Field(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(Color))
                    {
                        Color oldvalue = (Color)f.GetValue(cameraeffect.EffectObj);
                        Color newvalue = EditorGUILayout.ColorField(f.Name, oldvalue);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                    if (f.FieldType == typeof(Texture))
                    {
                        Texture oldvalue = (Texture)f.GetValue(cameraeffect.EffectObj);
                        Texture newvalue = (Texture)EditorGUILayout.ObjectField(f.Name, oldvalue, typeof(Texture), false);
                        if (newvalue != oldvalue)
                        {
                            f.SetValue(cameraeffect.EffectObj, newvalue);
                        }
                    }
                }
            }
        }
    }
    

    [MenuItem("CameraEffect/Load CameraEffects")]
    public static void LoadCameraEffects()
    {
        string[] folds = Directory.GetDirectories("Assets/Scripts", "Camera Filter Pack", SearchOption.AllDirectories);
        string Root = "";
        if (folds.Length == 1)
        {
            Root = folds[0];
        }
        CameraEffectTypes.Clean();

        string Path = Root + "/Scripts";
        DirectoryInfo direction = new DirectoryInfo(Path);
        FileInfo[] files = direction.GetFiles("*.cs", SearchOption.AllDirectories);

        string ChnPath = Root + "/CHN";
        DirectoryInfo ChnPathdirection = new DirectoryInfo(ChnPath);
        FileInfo[] jsons = ChnPathdirection.GetFiles("*.json");
        if (jsons.Length > 0)
        {
            string data = jsons[0].OpenText().ReadToEnd();
            Debug.Log("Json : " + data);
            CameraEffectTypes.ReadJson(data);
        }


        for (int i = 0; i < files.Length; i++)
        {
            string name = files[i].Name.Split('.')[0];

            Assembly asmb = Assembly.GetAssembly(typeof(TimelineData));
            Type type = asmb.GetType(name);
            CameraEffectTypes.AddType(type);
        }

    }

}

