using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VFrame.MVC
{
    /**
     * 通知者对象
     * 用于mediator对象的消息通知
     * 
     * */
    public class Notifier
    {
        /**
         * 消息对应的通知对象
         * */
        private Dictionary<string, List<IMediator>> container;

        public Notifier()
        {
            container = new Dictionary<string, List<IMediator>>();
        }

        /**
         * 添加消息注册
         * */
        public void AddObserver(IMediator mediator)
        {
            string[] keys = mediator.GetListNotifications();
            int length = keys.Length;
            for (int i = 0; i < length; i++)
            {
                string key = keys[i];
                if (container.ContainsKey(key) == false)
                    container.Add(key, new List<IMediator>());
                container[key].Add(mediator);
            }
        }

        /**
         * 清理消息注册
         * */
        public void RemoveObserver(IMediator mediator)
        {
            string[] keys = mediator.GetListNotifications();
            int length = keys.Length;
            for (int i = 0; i < length; i++)
            {
                List<IMediator> list = container[keys[i]];
                list.Remove(mediator);
                if (list.Count == 0)
                    container.Remove(keys[i]);
            }
        }

        /**
         * 分发消息
         * */
        public void NotiftyObservers(string notifierName, Dictionary<string, System.Object> body)
        {
            if (container.ContainsKey(notifierName) == false)
                return;
            List<IMediator> list = container[notifierName];
            int length = list.Count;
            for (int i = 0; i < length; i++)
            {
                list[i].PreExecute(notifierName, body);
            }
        }
    }
}