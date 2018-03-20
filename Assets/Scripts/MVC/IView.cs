using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace VFrame.MVC
{
    /**
     * 可以直接添加到场景中对象身上的脚本
     * */
    public abstract class IView : MonoBehaviour
    {
        /**
         * 该脚本对应的模块
         * */
        public string MediatorName;

        /**
         * 是否使用输入事件
         * */
        public bool UsedInputEvent = false;

        /**
         * 是否使用每帧调度事件
         * */
        public bool UsedUpdateEvent = false;

        private void Awake()
        {
            enabled = false;
            if (UsedInputEvent || UsedUpdateEvent)
            {
                Facade.Instance().RegisterViewToMediator(MediatorName, this, UsedInputEvent, UsedUpdateEvent);
            }
        }

        /**
         * 如果需要使用输入事件，请重写该方法
         * */
        public abstract void InputEvent();

        /**
         * 需要调用每帧事件时重新该方法
         * */
        public abstract void UpdateEvent();
    }
}