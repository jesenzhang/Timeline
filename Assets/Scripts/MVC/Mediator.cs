using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace VFrame.MVC
{
    /**
     * ab以及此ab下的asset对象
     * 
     * */
    [Serializable]
    public struct ABLoaderStruct
    {
        public string path;
        public bool isScene;
        public LoadSceneMode loadSceneMode;
    }

    [Serializable]
    public struct CommandStruct
    {
        public string command;
        public Dictionary<string, System.Object> value;
    }

    /**
     * 属性基类
     * */
    public class Mediator : MonoBehaviour
    {
        /**
         * 加载时缓存的命令行
         * */
         [SerializeField]
        protected List<CommandStruct> commandList;

        /**
         * 标记当前mediator为初始化阶段
         * */
        [SerializeField]
        protected bool initMediator;

        /**
         * 当前显示控制中的显示对象集合
         * */
        [SerializeField]
        protected Dictionary<string, UnityEngine.Object> gameObjects;

        /**
         * 是否接受输入控制
         * */
        [SerializeField]
        protected bool input;

    }
}