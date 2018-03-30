using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace TimelineTools
{
    public class TimelineExportor : Editor
    {
        //新打包方式
        [MenuItem("Export/导出替换后的预制体剧情资源")]
        public static void ExportTimelinepPrefab(UnityEngine.Object[] objs)
        {
            if (objs == null || objs.Length == 0)
            {
                Debug.LogError("no sequence selected");
                return;
            }

            BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;

            string exportPath = TimelineEditorUtils.PlatformPath(buildTarget);
            if (exportPath == null)
            {
                Debug.LogError("get export path error");
                return;
            }

            exportPath += "Sequence/";

            if (!Directory.Exists(exportPath))
                Directory.CreateDirectory(exportPath);

            List<AssetBundleBuild> list = new List<AssetBundleBuild>();
            //标记所有 asset bundle name 
            for (int m = 0, mcount = objs.Length; m < mcount; m++)
            {
                UnityEngine.Object prefab = objs[m];
                string assetpath = AssetDatabase.GetAssetPath(prefab);
                AssetBundleBuild build = new AssetBundleBuild();
                build.assetBundleName = prefab.name;
                build.assetNames = new string[] { assetpath };
                list.Add(build);
            }
            //开始打包
            BuildPipeline.BuildAssetBundles(exportPath, list.ToArray(), BuildAssetBundleOptions.ChunkBasedCompression, EditorUserBuildSettings.activeBuildTarget);

        }

        //单个整体打包
        public static void ExportSequenceObj(UnityEngine.Object[] objs)
        {
            if (objs == null || objs.Length == 0)
            {
                Debug.LogError("no sequence selected");
                return;
            }

            BuildTarget buildTarget = EditorUserBuildSettings.activeBuildTarget;

            string exportPath = TimelineEditorUtils.PlatformPath(buildTarget);
            if (exportPath == null)
            {
                Debug.LogError("get export path error");
                return;
            }

            exportPath += "Sequence/";

            if (!Directory.Exists(exportPath))
                Directory.CreateDirectory(exportPath);

            for (int m = 0, mcount = objs.Length; m < mcount; m++)
            {
                UnityEngine.Object prefab = objs[m];
                BuildPipeline.BuildAssetBundle(prefab, null, exportPath + prefab.name, BuildAssetBundleOptions.ChunkBasedCompression, buildTarget);
            }
        }


        public static void ExportExchangeTimeline()
        {
            UnityEngine.Object[] objs = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
            if (objs == null || objs.Length == 0)
            {
                Debug.LogError("no sequence selected");
                return;
            }
            for (int m = 0, mcount = objs.Length; m < mcount; m++)
            {
                UnityEngine.Object obj = objs[m];
                GameObject go = (GameObject)UnityEngine.Object.Instantiate(obj);
                go.name = obj.name;
            }
        }
    }


}