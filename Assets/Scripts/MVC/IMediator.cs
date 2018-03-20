using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using VFrame.ABSystem;

namespace VFrame.MVC
{
    

    /**
     * 模块的控制逻辑基础类
     * 提供自动根据配置信息加载ab文件
     * TODO: 控制器如何做
     * 
     * */
    public abstract class IMediator : Mediator
    {

        protected List<IView> inputViews;
        protected List<IView> updateViews;

        private void Awake()
        {
            initMediator = true;
            // 载入完成后的对象列表
            gameObjects = new Dictionary<string, UnityEngine.Object>();
            commandList = new List<CommandStruct>();
            inputViews = new List<IView>();
            updateViews = new List<IView>();
            // 开启一个加载
            StartCoroutine(loaderAssetBundles());
        }

        /**
         * 当前需要载入的ab列表
         * */
        protected abstract ABLoaderStruct[] getLoaderABNames();

        /**
         * 载入资源，最后通过映射返回asset对象
         * */
        private IEnumerator loaderAssetBundles()
        {
            ABLoaderStruct[] loaderList = getLoaderABNames();
            for (int i = 0; i < loaderList.Length; i++)
            {
                // 加载ab到内存
                ABLoaderStruct abs = loaderList[i];
                AssetBundleManager.Instance.Load(abs.path, (a) =>
                {
                    GameObject go = a.Instantiate();
                    gameObjects.Add(abs.path, go);
                });

            }
            yield return null;
            initMediator = false;
            // 资源载入完成后的处理操作
            int Length = commandList.Count;
            if(Length > 0)
            {
                for (int i = 0; i < Length; i++)
                {
                    CommandStruct cs = commandList[i];
                    Execute(cs.command, cs.value);
                }
                commandList.Clear();
            }
            input = true;
        }

        public abstract string GetMediatorName();

        public abstract string[] GetListNotifications();

        /**
         * 执行的命令行代码
         * */
        public abstract void Execute(string command, System.Object value);

        /**
         * 清理操作
         * */
        public abstract void RemoveMediator();

        public void Update()
        {
            for (int i = 0; i < updateViews.Count; i++)
            {
                updateViews[i].UpdateEvent();
            }

            if (input)
            {
                for (int i = 0; i < inputViews.Count; i++)
                {
                    inputViews[i].InputEvent();
                }
                InputEvent();
            }
        }

        protected abstract void InputEvent();

        /**
         * 添加新的模型对象进入
         * */
        public void AddViewToInputEvent(IView view)
        {
            inputViews.Add(view);
        }

        public void AddViewToUpdateEvent(IView view)
        {
            updateViews.Add(view);
        }

        /**
         * 预执行
         * */
        public void PreExecute(string command, Dictionary<string, System.Object> value)
        {
            if (initMediator)
            {
                CommandStruct cs = new CommandStruct();
                cs.command = command;
                cs.value = value;
                commandList.Add(cs);
            }else
            {
                Execute(command, value);
            }
        }

        /**
         * 预删除
         * */
        public void PreRemoveMediator()
        {
            input = false;
            // 清理
            commandList.Clear();
            inputViews.Clear();
            updateViews.Clear();
            // 清理显示对象
                foreach (KeyValuePair<string, UnityEngine.Object> kv in gameObjects)
                {
                    GameObject.Destroy(kv.Value);
                }
            gameObjects.Clear();

            // 清理ab
            ABLoaderStruct[] loaderList = getLoaderABNames();
            for (int i = 0; i < loaderList.Length; i++)
            {
                AssetBundleManager.Instance.RemoveBundle(loaderList[i].path);
            }
            // 调用删除
            RemoveMediator();

           
        }

    }
}