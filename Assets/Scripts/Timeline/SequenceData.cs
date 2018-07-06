
//ine LUACOMPILE
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

#if LUACOMPILE
using GameBase;
using LuaInterface;
#endif

namespace TimelineTools
{

    public class SequenceEventArgs : EventArgs
    {
        public GameObject[] objs;
        public string msg;
        public int param;
        public string[] paramlist;
        public SequenceEventArgs()
        {
        }
        public SequenceEventArgs(string msg0, int param0)
        {
            msg = msg0;
            param = param0;
        }

        public SequenceEventArgs(string msg0, string[] param0, GameObject[] objs0)
        {
            msg = msg0;
            paramlist = param0;
            objs = objs0;
        }
        public SequenceEventArgs(string msg0, string[] param0)
        {
            msg = msg0;
            paramlist = param0;
        }
    }

    [RequireComponent(typeof(PlayableDirector))]
    public class SequenceData : MonoBehaviour
    {
        private TimelineData timelineData;
        PlayableDirector director;

        public delegate void SequenceHandler(object sender, SequenceEventArgs e);

        public event SequenceHandler SequenceFinished;
        public event SequenceHandler OnMessageEvent;

        double localTime = 0;
        bool countTime = false;
        public PlayableDirector Director
        {
            get
            {
                if (director == null)
                {
                    director = GetComponent<PlayableDirector>();
                }
                return director;
            }

            set
            {
                director = value;
            }
        }

        public TimelineData TimelineData
        {
            get
            {
                if (timelineData == null)
                {
                    timelineData = GetComponent<TimelineData>();
                }
                return timelineData;
            }

            set
            {
                timelineData = value;
            }
        }


        public float Duration
        {
            get
            {
                return (float)Director.duration;
            }
        }
        public void SetCurrentTime(float t)
        {
            Director.time = t;
            localTime = t;
        }

        public float RunningTime()
        {
            if (Director)
                return (float)Director.time;
            return -1;
        }

        public void Stop()
        {
            if (Director == null) return;
            Director.Stop();
            countTime = false;
            localTime = 0;
        }

        public void Play()
        {
            if (Director == null) return;
            Director.Play();
            countTime= true;
        }

        public void Pause()
        {
            if (Director == null) return;
            countTime = false;
            Director.Pause();
           
        }

        public void Resume()
        {
            if (Director == null) return;
            countTime = true;
            Director.Resume();
        }
        public void Skip()
        {
            if (Director == null) return;
            Director.time = Director.duration;
            localTime = Director.duration;
        }


        public void OnMessage(string msg, int param)
        {
            if (OnMessageEvent != null)
            {
                OnMessageEvent(this, new SequenceEventArgs(msg, param));
            }
        }
        public void OnMessage(string msg)
        {
            if (OnMessageEvent != null)
            {
                SequenceEventArgs args = new SequenceEventArgs();
                args.msg = msg;
                OnMessageEvent(this, args);
            }
        }
        
        public void OnMessage(string msg, string[] param,GameObject[] objs)
        {
            if (OnMessageEvent != null)
            {
                SequenceEventArgs args = new SequenceEventArgs(msg, param, objs);
                OnMessageEvent(this, args);
            }
        }

        public void OnMessage(string msg, string[] param)
        {
            if (OnMessageEvent != null)
            {
                SequenceEventArgs args = new SequenceEventArgs(msg, param);
                OnMessageEvent(this, args);
            }
        }

        void OnCuteSceneFinished(object sender, SequenceEventArgs arg)
        {
            if (Director == null)
                return;
#if LUACOMPILE
            LuaInterface.LuaFunction func = LuaManager.GetFunction("SequenceCall.OnFinished");
            string name = this.gameObject.name;
            int index = name.IndexOf("(");
            if (index >= 0)
                name = name.Substring(0, index);
            LuaManager.CallFunc_VX(func, name);
# endif
        }

     
        void OnMessage(object sender, SequenceEventArgs arg)
        {
            if (Director == null)
                return;
#if LUACOMPILE
            LuaInterface.LuaFunction func = LuaManager.GetFunction("SequenceCall.OnMessage");
            string name = this.gameObject.name;
            int index = name.IndexOf("(");
            if (index >= 0)
                name = name.Substring(0, index);
            LuaManager.CallFunc_VX(func, arg.msg, arg.param, arg.paramlist,arg.objs);
#endif
        }
     
        void Awake()
        {
            if (Director)
            {
                SequenceFinished += OnCuteSceneFinished;
                OnMessageEvent += OnMessage;
            }
            

        }
        // Use this for initialization
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {
            //if (Director && Director.state == PlayState.Playing)
            if(countTime)
            {
                localTime += Time.deltaTime;
                //double f = Director.duration - Director.time;
                // Debug.Log("Director.time " + f );
                //if (f < 0.030f)
                if (localTime >= Director.duration)
                {
                    Debug.Log("Finish");
                    if (SequenceFinished != null)
                    {
                        SequenceFinished(this, new SequenceEventArgs());
                    }
                    Stop();
                }
            }
        }
    }
}