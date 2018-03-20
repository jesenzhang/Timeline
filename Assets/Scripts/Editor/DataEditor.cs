using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using EnumProperty;

public class DataEditor : Editor {

    [MenuItem("DataEditor/CreateSystemData")]
    private static void CreateSystemData()
    {
        RoleProperty role = new RoleProperty();
        string path = EditorUtility.SaveFilePanel("", Application.dataPath + "/", "", "asset");
        if (path.Length != 0)
        {
            path = "Assets" + path.Replace(Application.dataPath, "");
            AssetDatabase.CreateAsset(role, path);
        }
    }

    [MenuItem("DataEditor/CreateRoleData")]
    private static void CreateRoleData()
    {
        RoleProperty role = new RoleProperty();
        string path = EditorUtility.SaveFilePanel("", Application.dataPath + "/","", "asset");
        if (path.Length != 0)
        {
            path = "Assets" + path.Replace(Application.dataPath, "");
            AssetDatabase.CreateAsset(role, path);
        }
    }
    [MenuItem("DataEditor/CreateRoundData")]
    private static void CreateRoundData()
    {
        RoundProperty role = new RoundProperty();
        string path = EditorUtility.SaveFilePanel("", Application.dataPath + "/", "", "asset");
        if (path.Length != 0)
        {
            path = "Assets" + path.Replace(Application.dataPath, "");
            AssetDatabase.CreateAsset(role, path);
        }
    }

    [MenuItem("DataEditor/CreateCardData")]
    private static void CreateCardData()
    {
        CardProperty role = new CardProperty();
        string path = EditorUtility.SaveFilePanel("", Application.dataPath + "/", "", "asset");
        if (path.Length != 0)
        {
            path = "Assets" + path.Replace(Application.dataPath, "");
            AssetDatabase.CreateAsset(role, path);
        }
    }
}
