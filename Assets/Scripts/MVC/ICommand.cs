using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace VFrame.MVC
{
    public abstract class ICommand : MonoBehaviour
    {
        private void Awake()
        {
            enabled = false;
        }

        /**
         * 执行的命令行代码
         * */
        public abstract void Execute(string command, Dictionary<string, System.Object> value);
    }
}