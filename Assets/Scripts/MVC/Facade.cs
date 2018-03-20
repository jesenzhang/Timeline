using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


namespace VFrame.MVC
{
    /**
     * 全局的模块管理工具
     * 所有的模块间消息传递
     * 所有的模块生成
     * */
    public class Facade : MonoBehaviour
    {
        #region single&init
        /**
         * 单利对象
         * */
        protected static Facade instance = null;

        public static Facade Instance()
        {
            if (instance == null)
            {
                instance = FindObjectOfType<Facade>();

                if (FindObjectsOfType<Facade>().Length > 1)
                {
                    return instance;
                }

                if (instance == null)
                {
                    string instanceName = typeof(Facade).Name;
                    GameObject instanceGO = GameObject.Find(instanceName);
                    if (instanceGO == null)
                        instanceGO = new GameObject(instanceName);
                    instance = instanceGO.AddComponent<Facade>();

                    instance.commandParent = new GameObject("Command");
                    instance.mediatorParent = new GameObject("Mediator");
                    //保证实例不会被释放
                    DontDestroyOnLoad(instanceGO);
                }
            }
            return instance;
        }
        #endregion

        /**
         * 命令控制器容器
         * */
        private Dictionary<string, ICommand> commandMap;

        private Dictionary<string, IMediator> mediatorMap;

        /**
         * 观察者对象
         * */
        private Notifier notifier;

        public GameObject mediatorParent;

        public GameObject commandParent;

        public Facade()
        {
            commandMap = new Dictionary<string, ICommand>();
            mediatorMap = new Dictionary<string, IMediator>();
            notifier = new Notifier();
        }

        private void Awake()
        {
            enabled = false;
        }

        /**
         * 注册一个模块的命令调度器
         * */
        public void RegisterCommand(string commandName, Type command)
        {
            if (commandMap.ContainsKey(commandName) == false)
            {
                Scene scene = SceneManager.GetActiveScene();
                SceneManager.SetActiveScene(SceneManager.GetSceneByName("EngineScene"));
                GameObject go = new GameObject();
                go.name = commandName;
                go.transform.parent = commandParent.transform;
                ICommand m = go.AddComponent(command) as ICommand;
                commandMap.Add(commandName, m);
                go.SetActive(false);
                SceneManager.SetActiveScene(scene);
            }
               
        }

        /**
         * 移除一个模块的命令调度器
         * */
        public void RemoveCommand(string commandName)
        {
            if (commandMap.ContainsKey(commandName) == true)
            {
                ICommand mediator = commandMap[commandName];
                commandMap.Remove(commandName);
                GameObject.Destroy(mediator.gameObject);
            }
        }

        /**
         * 是否存在该命令控制器
         * */
        public bool HasCommand(string commandName)
        {
            if (commandMap.ContainsKey(commandName) == true)
                return true;
            return false;
        }

        /**
         * 注册模块逻辑控制器
         * */
        public void RegisterMediator(string mediatorName,Type mediator)
        {
            if (mediatorMap.ContainsKey(mediatorName) == true)
                return;
            Scene scene = SceneManager.GetActiveScene();
            SceneManager.SetActiveScene(SceneManager.GetSceneByName("EngineScene"));
            GameObject go = new GameObject();
            go.name = mediatorName;
            go.transform.parent = mediatorParent.transform;
            IMediator m = go.AddComponent(mediator) as IMediator;
            mediatorMap.Add(m.GetMediatorName(), m);
            notifier.AddObserver(m);
            SceneManager.SetActiveScene(scene);
        }

        /**
         * 移除模块逻辑控制器
         * */
        public void RemoveMediator(string mediatorName)
        {
            if (mediatorMap.ContainsKey(mediatorName) == false)
                return;
            IMediator mediator = mediatorMap[mediatorName];
            notifier.RemoveObserver(mediator);
            mediator.PreRemoveMediator();
            mediatorMap.Remove(mediatorName);
            GameObject.Destroy(mediator.gameObject);
        }

        /**
         * 是否存在该模块
         * */
        public bool HasMediator(string mediatorName)
        {
            if (mediatorMap.ContainsKey(mediatorName) == false)
                return false;
            return true;
        }

        /**
         * 通过Facade进行模块之间的消息传递
         * notifierName为接受消息的模块标签
         * body为传递的消息参数
         * command为指定的命令行为
         * */
        public void SendNotifacation(string notifierName,Dictionary<string,System.Object> body,string command = null)
        {
            // 该消息是发送给命令控制单元的消息
            if(commandMap.ContainsKey(notifierName) == true)
            {
                ICommand commandObj = commandMap[notifierName];
                commandObj.Execute(command,body);
                return;
            }
            // 该消息是广播给所有显示控制单元的消息
            notifier.NotiftyObservers(notifierName, body);
        }

        /**
         * 将view注册进入mediator
         * */
        public void RegisterViewToMediator(string mediatorName,IView view,bool usedInputEvent, bool usedUpdateEvent)
        {
            if (mediatorMap.ContainsKey(mediatorName) == false)
                return;
            IMediator mediator = mediatorMap[mediatorName];
            if(usedInputEvent)
                mediator.AddViewToInputEvent(view);
            if (usedUpdateEvent)
                mediator.AddViewToUpdateEvent(view);
        }

        /**
         * 注册一个模块的命令调度器
         * */
        public void RegisterCommand(string commandName)
        {
            //RegisterCommand(commandName,typeof(TestCommand));
        }
        /**
         * 注册模块逻辑控制器
         * */
        public void RegisterMediator(string mediatorName)
        {
            //RegisterMediator(mediatorName, typeof(TestMediator));
        }
    }
}