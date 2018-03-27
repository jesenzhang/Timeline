using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VFrame.ABSystem;
using VFrame.UI;

public class GameMain : MonoBehaviour {

    
    //初始化系统
    public void InitSystems()
    {
        GameObject absystem = new GameObject("AssetBundleManager");
        absystem.AddComponent<AssetBundleManager>();
        absystem.transform.parent = this.transform;

        GameObject GameDataSystem = new GameObject("GameData");
        GameDataSystem.AddComponent<GameData>();
        GameDataSystem.transform.parent = this.transform;

        GameObject roundSystem = new GameObject("RoundSystem");
        roundSystem.AddComponent<RoundSystem>();
        roundSystem.transform.parent = this.transform;

        GameObject entityCenter = new GameObject("EntityCenter");
        entityCenter.AddComponent<EntityCenter>();
        entityCenter.transform.parent = this.transform;

        GameObject caculateSystem = new GameObject("CaculateSystem");
        entityCenter.AddComponent<CaculateSystem>();
        entityCenter.transform.parent = this.transform;
    }
    
    private void Awake()
    {
        DontDestroyOnLoad(this);
    }
    // Use this for initialization
    void Start () {

        InitSystems();

        GameData.Instance.InitData();
        EntityCenter.Instance.InitData();
      
        // AssetBundleManager.Instance.Load("Assets.Prefabs.UI.Notice.prefab",(go)=> {
        //     GameObject g = go.Instantiate();
        // });
        UIPage.ShowPage<UIMainPage>(null);
    }
    GameObject temp = null;
    // Update is called once per frame
    void Update () {

        RoundSystem.Instance.Tick(Time.deltaTime,Time.realtimeSinceStartup);
       
    }
}
