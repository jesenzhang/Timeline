using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using XLua;
namespace LuaInterface
{
    public class LuaModule
    {
        private static LuaModule instance;
        public static LuaModule Instance
        {
            get {
                if (instance == null)
                {
                    instance = new LuaModule();
                    luaEnv = new LuaEnv();
                }
                return instance;
            }
        }
        private static LuaEnv luaEnv;
        //public delegate byte[] CustomLoader(ref string filepath);
        public void AddLoader(LuaEnv.CustomLoader loader)
        {
            luaEnv.AddLoader(loader);
        }

        public byte[] DefaultLoader(ref string filepath)
        {
            //将Lua文件放置在StreamingAssets文件夹下
            //Application.streamingAssetsPath获取StreamingAssets文件夹的目录地址
            string absPath = Application.streamingAssetsPath + "/" + filepath + ".lua";
            return Encoding.UTF8.GetBytes(File.ReadAllText(absPath)); //读取lua文件
        }
        public void Init()
        {
            AddLoader(DefaultLoader);
        }

        // Update is called once per frame
        void Update()
        {
            if (luaEnv != null)
            {
                luaEnv.Tick();
            }
        }

        void OnDestroy()
        {
            if (luaEnv != null)
            {
                luaEnv.Dispose();
            }
        }
    }
}