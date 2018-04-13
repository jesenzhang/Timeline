
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VFrame.ABSystem;
using VFrame.UI;

public class GameStart : MonoBehaviour
{
    //初始化系统
    public void InitSystems()
    {
        GameObject absystem = new GameObject("AssetBundleManager");
        absystem.AddComponent<AssetBundleManager>();
        absystem.transform.parent = this.transform;

        GameObject GameDataSystem = new GameObject("GameData");
        GameDataSystem.AddComponent<GameData>();
        GameDataSystem.transform.parent = this.transform;

        GameObject roundSystem = new GameObject("GameRoundSystem");
        roundSystem.AddComponent<GameRoundSystem>();
        roundSystem.transform.parent = this.transform;
         
    }

    private void Awake()
    {
        DontDestroyOnLoad(this);
    }
    // Use this for initialization
    void Start()
    { 
           
        InitSystems();
        GameData.Instance.InitData();
        StartCoroutine(StartBattle());
       
    }

    //开始
    public IEnumerator StartBattle()
    {
        yield return new WaitUntil(() => { return GameData.Instance.SystemData!=null; });

        GameRoundSystem.Instance.LoadAsset(0); 
    }

    GameObject temp = null;
    // Update is called once per frame
    void Update()
    {
        GameRoundSystem.Instance.Tick(Time.deltaTime, Time.realtimeSinceStartup);

    }
}
