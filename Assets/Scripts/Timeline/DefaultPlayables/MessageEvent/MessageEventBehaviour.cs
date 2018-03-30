
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using TimelineTools;

[Serializable]
public class MessageEventBehaviour : PlayableBehaviour
{
    private TimelineTools.SequenceData data;
    public string msg = "";
    public int param = -1;
    public string[] paramList;
    public bool hasParam = false;

    public TimelineTools.SequenceData Data
    {
        get
        {
            return data;
        }

        set
        {
            data = value;
        }
    }

    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        base.OnBehaviourPlay(playable, info);
        if (Application.isPlaying && Data)
        {
            Debug.Log("msg " + msg);
            if (hasParam)
            {
                if (param != -1)
                    Data.OnMessage(msg, param);
                else
                    Data.OnMessage(msg, paramList);
            }
            else
                Data.OnMessage(msg);
        }
    }
}
