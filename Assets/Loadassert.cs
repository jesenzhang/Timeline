
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using TimelineTools;

public class Loadassert : MonoBehaviour
{
    string BundleURL = "file:///E:/Github/Timeline/Export/odie/PC/Sequence/testtimeline";
    string AssetName = "testtimeline";
    public GameObject player;
    public GameObject cube;

    //从文件夹里加载一个异步加载
    public GameObject LoadOne()
    {
        var myLoadedAssetBundle = AssetBundle.LoadFromFile(Path.Combine(Application.streamingAssetsPath, "testtimeline"));
        if (myLoadedAssetBundle == null)
        {
            Debug.Log("Failed to load AssetBundle!");
            return null;
        }
        var prefab = myLoadedAssetBundle.LoadAsset<GameObject>("TestTimeline");
        GameObject go = Instantiate(prefab);
        // Unload the AssetBundles compressed contents to conserve memory
        myLoadedAssetBundle.Unload(false);
        return go;
    }


    //从文件夹里加载一个同步加载
    public void LoadNoRequest()
    {
        var bundle = AssetBundle.LoadFromFile("Assets/AssetBundles/Sphere");
        UnityEngine.Object obj = bundle.LoadAsset("sphere");
        Instantiate(obj);
        // Unload the AssetBundles compressed contents to conserve memory
        bundle.Unload(false);
    }
    //从文件夹里加载全部
    public void loadAll()
    {
        var bundle = AssetBundle.LoadFromFile("Assets/AssetBundles/Sphere");
        foreach (UnityEngine.Object temp in bundle.LoadAllAssets())
        {
            Instantiate(temp);
        }
        bundle.Unload(false);
    }
    //从文件夹里通过依赖关系加载
    public void LoadManifest()
    {
        //加载那个打包时额外打出来的总包
        var bundle = AssetBundle.LoadFromFile("Assets/AssetBundles/AssetBundles");
        //   var bundle = AssetBundle.LoadFromFile("Assets/AssetBundles/AssetBundles.manifest");//不能这样加载manifest。
        AssetBundleManifest manifest = bundle.LoadAsset("AssetBundleManifest") as AssetBundleManifest;
        //AssetBundleManifest不是某个文件的名字，是固定的一个东西
        string[] deps = manifest.GetAllDependencies("earth");
        //earth是打出的包名
        List<AssetBundle> depList = new List<AssetBundle>();
        Debug.Log(deps.Length);
        for (int i = 0; i < deps.Length; ++i)
        {
            AssetBundle ab = AssetBundle.LoadFromFile(Application.dataPath + "/AssetBundles/" + deps[i]);
            depList.Add(ab);
        }

        AssetBundle cubeAb = AssetBundle.LoadFromFile(Application.dataPath + "/AssetBundles/earth");
        GameObject org = cubeAb.LoadAsset("earth") as GameObject;
        Instantiate(org);

        cubeAb.Unload(false);
        for (int i = 0; i < depList.Count; ++i)
        {
            depList[i].Unload(false);
        }
        bundle.Unload(true);
    }
    public void LoadNoManifest()
    {
        var bundle = AssetBundle.LoadFromFile("Assets/AssetBundles/earth11");

        AssetBundleRequest gObject = bundle.LoadAssetAsync("earth11", typeof(GameObject));
        GameObject obj = gObject.asset as GameObject;
        Instantiate(obj);
        // Unload the AssetBundles compressed contents to conserve memory
        bundle.Unload(false);
    }
    public void loadWWWNoStored()
    {
        StartCoroutine(_loadWWWNoStored());
    }
    public void LoadWWWStored()
    {
        StartCoroutine(_LoadWWWStored());
    }
    /// <summary>
    /// -变量BundleURL的格式–如果为UnityEditor本地：
    /// —“file://”+“application.datapath”+“/文件夹名称/文件名”
    /// –如果为服务器： —http://….
    ///-变量AssetName: 
    ///–为prefab或文件的名字。
    /// </summary>
    public IEnumerator _loadWWWNoStored()
    {
        // Download the file from the URL. It will not be saved in the Cache
        using (WWW www = new WWW(BundleURL))
        {
            yield return www;
            if (www.error != null)
                throw new Exception("WWW download had an error:" + www.error);
            AssetBundle bundle = www.assetBundle;
            if (AssetName == "")
                Instantiate(bundle.mainAsset);
            else
                Instantiate(bundle.LoadAsset(AssetName));
            // Unload the AssetBundles compressed contents to conserve memory
            bundle.Unload(false);

        } // memory is freed from the web stream (www.Dispose() gets called implicitly)
    }
    public IEnumerator _LoadWWWStored()
    {
        // Wait for the Caching system to be ready
        while (!Caching.ready)
            yield return null;

        // Load the AssetBundle file from Cache if it exists with the same version or download and store it in the cache
        using (WWW www = WWW.LoadFromCacheOrDownload(BundleURL, /*version*/ 0))
        {
            yield return www;
            if (www.error != null)
                throw new Exception("WWW download had an error:" + www.error);
            AssetBundle bundle = www.assetBundle;
            if (AssetName == "")
                Instantiate(bundle.mainAsset);
            else
                //              Instantiate(bundle.mainAsset);

                //              Instantiate(bundle.LoadAsset(AssetName));
                foreach (UnityEngine.Object temp in bundle.LoadAllAssets())
                {
                    Instantiate(temp);
                }
            //      Instantiate(bundle.LoadAllAssets());
            // Unload the AssetBundles compressed contents to conserve memory
            bundle.Unload(false);

        } // memory is freed from the web stream (www.Dispose() gets called implicitly)
    }

    GameObject go;
    private void Start()
    {
       Transform t = transform.Find("/Sphere");
        Debug.Log(t);
        go = LoadOne();
        go.transform.localPosition = Vector3.zero;
        go.transform.localRotation = Quaternion.identity;
        go.transform.localScale = Vector3.one;
        TimelineData td = go.GetComponent<TimelineData>();
            ReplaceInfo[] slist = td.GetResourceList();
            for (int i = 0; i < slist.Length; i++)
            {
                if (slist[i].res == player.name)
                {
                    td.SetResourceObj(slist[i].path, player);
                }
                if (slist[i].res == cube.name)
                {
                    td.SetResourceObj(slist[i].path, cube);
                }
            }
    }

    private void Update()
    {
        TimelineData td = go.GetComponent<TimelineData>();

        if (Input.GetKeyDown(KeyCode.N))
        {
            td.ReplaceObjs();
            td.ReBindObjs();
        }
    }
}
