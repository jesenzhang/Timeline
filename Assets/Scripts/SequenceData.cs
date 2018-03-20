using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;


[RequireComponent(typeof(PlayableDirector))]
public class SequenceData : MonoBehaviour {

    private TimelineData timelineData;
    PlayableDirector director;
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


    // Use this for initialization
    void Start () {
      
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
