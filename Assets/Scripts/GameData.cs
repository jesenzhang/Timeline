using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using VFrame.ABSystem;

public class GameData : MonoBehaviour {

    public SystemDataProperty SystemData;

    public static GameData Instance;

    public void InitData()
    {
        AssetBundleManager.Instance.Load("Assets.Res.DataAsset.SystemData.systemdata.asset", (go) =>
        {
            SystemData = (SystemDataProperty)go.mainObject;
        });
    }

    private void Awake()
    {
        Instance = this;
    }
    // Use this for initialization
    void Start() {
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
