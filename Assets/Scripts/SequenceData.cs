using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

public class SequenceEventArgs : EventArgs
{
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

    public SequenceEventArgs(string msg0, string[] param0)
    {
        msg = msg0;
        paramlist = param0;
    }
}

[RequireComponent(typeof(PlayableDirector))]
public class SequenceData : MonoBehaviour {

    private TimelineData timelineData;
    PlayableDirector director;
    
    public delegate void SequenceHandler(object sender, SequenceEventArgs e);

    public event SequenceHandler SequenceFinished;
    public event SequenceHandler OnMessageEvent;

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
    }

    public void Play()
    {
        if (Director == null) return;
        Director.Play();
    }

    public void Pause()
    {
        if (Director == null) return;
        Director.Pause();
    }

    public void Resume()
    {
        if (Director == null) return;
        Director.Resume();
    }
    public void Skip()
    {
        if (Director == null) return;
        Director.time = Director.duration;
        Stop();
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

    public void OnMessage(string msg, string[] param)
    {
        if (OnMessageEvent != null)
        {
            SequenceEventArgs args = new SequenceEventArgs(msg, param);
            OnMessageEvent(this, args);
        }
    }
    /*
    void OnMessage(object sender, SequenceEventArgs arg)
    {
        if (Director == null)
            return;
        LuaInterface.LuaFunction func = LuaManager.GetFunction("SequenceCall.OnMessage");
        string name = this.gameObject.name;
        int index = name.IndexOf("(");
        if (index >= 0)
            name = name.Substring(0, index);
        LuaManager.CallFunc_VX(func, arg.msg, arg.param, arg.paramlist);
    }
    */

    // Use this for initialization
    void Start () {
      
    }
	
	// Update is called once per frame
	void Update () {
        if (Input.GetKeyDown(KeyCode.N))
        {
            Play();
        }
       // if (Director && Director.state == PlayState.Playing)
        {
            double f = Director.duration - Director.time;
           // Debug.Log("Director.time " + f );
            if (f < 0.015f)
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
