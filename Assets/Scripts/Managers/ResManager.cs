using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VFrame.ABSystem;
using VFrame.Common;
namespace VFrame.Managers {

    public class ResManager : Singleton<ResManager>  {

        public void LoadPrefabs()
        {
            AssetBundleManager.Instance.Load("Assets.Prefabs.UI.Notice.prefab", (go) => {
                    GameObject g = go.Instantiate();
            });
        }

    }
}