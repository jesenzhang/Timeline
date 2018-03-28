using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using EnumProperty;
using System.Data;

public class DataEditor : Editor {

    [MenuItem("DataEditor/导出Excel到SysytenData文件")]
    private static void CreateSystemData()
    {
        ReadExcelCards();
        ReadExcelRoles();
        ReadExcelRounds();
        ReadExcelDecks();

        SystemDataProperty role = new SystemDataProperty();
        var guids = AssetDatabase.FindAssets("card", new string[] { "Assets/Res/DataAsset/card" });
        role.AllCards = new CardProperty[guids.Length];
        for (int i = 0; i < guids.Length; i++)
        {
            role.AllCards[i] = (CardProperty)AssetDatabase.LoadAssetAtPath(AssetDatabase.GUIDToAssetPath(guids[i]), typeof(CardProperty));
        }

        var guids1 = AssetDatabase.FindAssets("round", new string[] { "Assets/Res/DataAsset/round" });
        role.AllRounds = new RoundProperty[guids1.Length];
        for (int i = 0; i < guids1.Length; i++)
        {
            role.AllRounds[i] = (RoundProperty)AssetDatabase.LoadAssetAtPath(AssetDatabase.GUIDToAssetPath(guids1[i]), typeof(RoundProperty));

        }

        var guids2 = AssetDatabase.FindAssets("role", new string[] { "Assets/Res/DataAsset/role" });
        role.AllRoles = new RoleProperty[guids2.Length];
        for (int i = 0; i < guids2.Length; i++)
        {
            role.AllRoles[i] = (RoleProperty)AssetDatabase.LoadAssetAtPath(AssetDatabase.GUIDToAssetPath(guids2[i]), typeof(RoleProperty));

        }
        var guids3 = AssetDatabase.FindAssets("deck", new string[] { "Assets/Res/DataAsset/deck" });
        role.AllDecks = new DeckProperty[guids3.Length];
        for (int i = 0; i < guids3.Length; i++)
        {
            role.AllDecks[i] = (DeckProperty)AssetDatabase.LoadAssetAtPath(AssetDatabase.GUIDToAssetPath(guids3[i]), typeof(DeckProperty));

        }
        AssetDatabase.CreateAsset(role, "Assets/Res/DataAsset/SystemData/systemdata.asset");

    }

    [MenuItem("DataEditor/ReadAndPerseExcelCards")]
    private static void ReadExcelCards()
    {
        DataRowCollection collect = ExcelAccess.ReadExcel("Res/Excel/GameData.xlsx", "cards");
        for (int i = 2; i < collect.Count; i++)
        {
            CardProperty role = new CardProperty
            {
                id = int.Parse(collect[i][0].ToString()),
                tid =int.Parse(collect[i][1].ToString()),
                CardName = collect[i][2].ToString(),
                Des = collect[i][3].ToString(),
            };
            List<FunctionData> funcList = new List<FunctionData>();

           int N =  (collect[i].ItemArray.Length-4)/4;
            for (int j = 0; j < N; j++)
            {
                if (collect[i].IsNull(4 + j * 4))
                {
                    j = N;
                    break;
                }
                FunctionData temp = new FunctionData();

                temp.type = (CardType)int.Parse(collect[i][4+j*4].ToString());
                temp.func = (CardFunc)int.Parse(collect[i][5 + j * 4].ToString());
                temp.target = (TargetType)int.Parse(collect[i][6 + j * 4].ToString());
                string value = collect[i][7 + j * 4].ToString();
                string[] array = value.Split(',');
                if (array == null || array.Length == 0)
                    temp.Values = new int[] { int.Parse(value) };
                else
                {
                    temp.Values = new int[array.Length];
                    for (int k = 0; k < array.Length; k++)
                    {
                        temp.Values[k] = int.Parse(array[k]);
                    }

                }
                funcList.Add(temp);
            }
            role.functions = funcList.ToArray();
            AssetDatabase.CreateAsset(role, "Assets/Res/DataAsset/card/card"+role.id+".asset");
        }
    }
    [MenuItem("DataEditor/ReadAndPerseExcelRounds")]
    private static void ReadExcelRounds()
    {
        DataRowCollection collect = ExcelAccess.ReadExcel("Res/Excel/GameData.xlsx", "rounds");
        for (int i = 2; i < collect.Count; i++)
        {
            RoundProperty role = new RoundProperty
            {
                id = int.Parse(collect[i][0].ToString()),
                maxRound = int.Parse(collect[i][1].ToString()),
                NeedPerse = collect[i][2].ToString()=="1"?true:false,
                Des = collect[i][3].ToString(),
                TargetDes = collect[i][4].ToString(),
                playerId = int.Parse(collect[i][5].ToString()),
                npcId = int.Parse(collect[i][6].ToString()),
                title = collect[i][7].ToString(),
                title0 = collect[i][8].ToString(),
                title1 = collect[i][9].ToString(),
            };
            List<string> rules = new List<string>();
            if (!collect[i].IsNull(10))
            {
                rules.Add(collect[i][10].ToString());
            }
            if (!collect[i].IsNull(11))
            {
                rules.Add(collect[i][11].ToString());
            }
            role.Rules = rules.ToArray();
            List<RoundGoal> funcList = new List<RoundGoal>();

            int N = (collect[i].ItemArray.Length - 11) / 4;
            for (int j = 0; j < N; j++)
            {
                if (collect[i].IsNull(12 + j * 4))
                {
                    j = N;
                    break;
                }
                RoundGoal temp = new RoundGoal();

                temp.GoalType = (RoundGoalType)int.Parse(collect[i][12 + j * 4].ToString());
                temp.Target = (TargetType)int.Parse(collect[i][13 + j * 4].ToString());
                temp.GoalCondition = (RoundGoalCondition)int.Parse(collect[i][14 + j * 4].ToString());
                temp.Value =int.Parse(collect[i][15 + j * 4].ToString());
               
                funcList.Add(temp);
            }
            role.Goals = funcList.ToArray();
            AssetDatabase.CreateAsset(role, "Assets/Res/DataAsset/round/round" + role.id + ".asset"); 
        }
    }
    [MenuItem("DataEditor/ReadAndPerseExcelRole")]
    private static void ReadExcelRoles()
    {
        DataRowCollection collect = ExcelAccess.ReadExcel("Res/Excel/GameData.xlsx", "roles");
        for (int i = 2; i < collect.Count; i++)
        {
            RoleProperty role = new RoleProperty
            {
                id = int.Parse(collect[i][0].ToString()),
                Money = int.Parse(collect[i][1].ToString()),
                Honor = int.Parse(collect[i][2].ToString()),
                Amity = int.Parse(collect[i][3].ToString()),
                DeckId = int.Parse(collect[i][4].ToString())
            };
            AssetDatabase.CreateAsset(role, "Assets/Res/DataAsset/role/role" + role.id + ".asset");
        }
    }
    [MenuItem("DataEditor/ReadAndPerseExcelDecks")]
    private static void ReadExcelDecks()
    {
        DataRowCollection collect = ExcelAccess.ReadExcel("Res/Excel/GameData.xlsx", "decks");
        for (int i = 2; i < collect.Count; i++)
        {
            DeckProperty role = new DeckProperty
            {
                id = int.Parse(collect[i][0].ToString())
            };
            string value = collect[i][1].ToString();
            string[] array = value.Split(',');
            if (array == null || array.Length == 0)
                role.Deck = new int[] { int.Parse(value) };
            else
            {
                role.Deck = new int[array.Length];
                for (int k = 0; k < array.Length; k++)
                {
                    role.Deck[k] = int.Parse(array[k]);
                }
            }
            AssetDatabase.CreateAsset(role, "Assets/Res/DataAsset/deck/deck" + role.id + ".asset");
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
