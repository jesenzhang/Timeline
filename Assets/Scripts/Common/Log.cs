using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

namespace VFrame.Common
{
    /// <summary>
    /// 日志输出服务
    /// 在player setting中设置Scripting define symbols中添加LOG字段，开启日志打印功能
    /// TODO：目前缺少日志写入到文件
    /// </summary>
    /// <seealso cref="DPHGame.UnitySingleton{DPHGame.Framework.Log}" />
    public class Log : UnitySingleton<Log>
    {
        private void Awake()
        {
            enabled = false;
            Application.logMessageReceived += HandleLog;
        }

        private void OnDisable()
        {
            Application.logMessageReceived -= HandleLog;
        }

        /// <summary>
        /// 日志回调
        /// </summary>
        /// <param name="logString">The log string.</param>
        /// <param name="stackTrace">The stack trace.</param>
        /// <param name="logType">Type of the log.</param>
        void HandleLog(string logString,string stackTrace,LogType logType)
        {
            if (LogType.Exception == logType)
            {
                errorPrint(logString);
                errorPrint(stackTrace);
            }
        }

        /// <summary>
        /// Errors错误日志输出
        /// </summary>
        /// <param name="msg">The MSG.</param>
        /// <param name="msgs">The MSGS.</param>
        public void Error(string msg, params string[] msgs)
        {
            errorPrint(msg, msgs);
        }

        [Conditional("LOG")]
        private void errorPrint(string msg, params string[] msgs)
        {
            if (msgs != null)
            {
                UnityEngine.Debug.LogError(msg + string.Concat(msgs));
            }
            else
            {
                UnityEngine.Debug.LogError(msg);
            }
        }


        /// <summary>
        /// info日志输出
        /// </summary>
        /// <param name="msg">The MSG.</param>
        /// <param name="msgs">The MSGS.</param>
        public void Info(string msg, params string[] msgs)
        {
            info(msg, msgs);
        }

        [Conditional("LOG")]
        private void info(string msg, params string[] msgs)
        {
            if (msgs != null)
            {
                UnityEngine.Debug.Log(msg + string.Concat(msgs));
            }else
            {
                UnityEngine.Debug.Log(msg);
            }
        }

        /// <summary>
        /// Warnings日志输出
        /// </summary>
        /// <param name="msg">The MSG.</param>
        /// <param name="msgs">The MSGS.</param>
        public void Warning(string msg, params string[] msgs)
        {
            warning(msg, msgs);
        }

        [Conditional("LOG")]
        private void warning(string msg, params string[] msgs)
        {
            if (msgs != null)
            {
                UnityEngine.Debug.LogWarning(msg + string.Concat(msgs));
            }
            else
            {
                UnityEngine.Debug.LogWarning(msg);
            }
        }
    }
}
