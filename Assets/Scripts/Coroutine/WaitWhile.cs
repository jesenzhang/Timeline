using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace VFrame.Coroutinue
{
    /// <summary>
    /// 自定义等待
    /// </summary>
    /// <seealso cref="System.Collections.IEnumerator" />
    public sealed class WaitWhile : CustomYieldInstruction
    {
        Func<bool> m_Predicate;

        public override bool keepWaiting { get { return m_Predicate(); } }

        public WaitWhile(Func<bool> predicate) { m_Predicate = predicate; }
    }
}