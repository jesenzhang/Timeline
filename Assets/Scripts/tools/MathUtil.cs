using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
namespace VFrame.GameTools
{
    public static class MathUtil
    {
        public static int GetRandom(int Min, int Max)
        {
            long tick = DateTime.Now.Ticks;
            System.Random ran = new System.Random((int)(tick & 0xffffffffL) | (int)(tick >> 32));
            return ran.Next(Min, Max+1);
        }
    }
}