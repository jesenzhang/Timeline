using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VFrame.Coroutinue
{

    /// <summary>
    /// 服务协程控制积累
    /// 用于串行化服务逻辑调度过程
    /// </summary>
    /// <seealso cref="UnityEngine.MonoBehaviour" />
    public class CoroutineCtrl : MonoBehaviour {
    
        protected class CoroutinueModel
        {
            public Coroutine c;
            public int session;
        }

        protected int session;

        /// <summary>
        /// 执行队列
        /// </summary>
        protected List<CoroutinueModel> coroutinueQueue;

        private void Awake()
        {
            coroutinueQueue = new List<CoroutinueModel>();
            session = 1;
        }

        /// <summary>
        /// 启动协程调度队列
        /// </summary>
        /// <param name="actionName">Name of the action.</param>
        /// <returns>Coroutine.</returns>
        protected CoroutinueModel StartCoroutinueQueue(Func<IEnumerator> action)
        {
            CoroutinueModel cm = new CoroutinueModel();
            cm.session = session++;
            coroutinueQueue.Add(cm);
            cm.c = StartCoroutine(coroutinueQueueScheduling(action,cm));
            return cm;
        }

        protected CoroutinueModel StartCoroutinueQueue(Func<string, System.Object, IEnumerator> action, string key, System.Object value)
        {
            CoroutinueModel cm = new CoroutinueModel();
            cm.session = session++;
            coroutinueQueue.Add(cm);
            cm.c = StartCoroutine(coroutinueQueueScheduling(action, key, value, cm));
            return cm;
        }

        /// <summary>
        /// 暂停队列中的某个方法
        /// </summary>
        /// <param name="routine">The routine.</param>
        protected void StopCoroutineQueue(CoroutinueModel routine)
        {
            bool b = coroutinueQueue.Remove(routine);
            if (b && routine.c != null)
            {
                StopCoroutine(routine.c);
            }
        }

        /// <summary>
        /// 队列协程调度
        /// </summary>
        /// <returns>IEnumerator.</returns>
        IEnumerator coroutinueQueueScheduling(Func<IEnumerator> action, CoroutinueModel cm)
        {
            while (true) {
                // 获得当前调度对象
                CoroutinueModel cmTmp = coroutinueQueue[0];
                if (cmTmp.session == cm.session)
                    break;
                yield return null;
            }
            // 运行逻辑协程
            IEnumerator ie = action();
            if(ie != null)
            {
                yield return ie;
            }
            coroutinueQueue.RemoveAt(0);
        }

        IEnumerator coroutinueQueueScheduling(Func<string, System.Object, IEnumerator> action, string key, System.Object value, CoroutinueModel cm)
        {
            while (true)
            {
                // 获得当前调度对象
                CoroutinueModel cmTmp = coroutinueQueue[0];
                if (cmTmp.session == cm.session)
                    break;
                yield return null;
            }
            // 运行逻辑协程
            IEnumerator ie = action(key, value);
            if (ie != null)
            {
                yield return ie;
            }
            coroutinueQueue.RemoveAt(0);
        }
    }
}
