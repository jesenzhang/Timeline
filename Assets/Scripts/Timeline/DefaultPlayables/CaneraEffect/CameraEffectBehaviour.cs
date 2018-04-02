
using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class CameraEffectBehaviour : PlayableBehaviour
{
    public MonoBehaviour Effect;

    public float inverseDuration;
    double duration = 0;

    public double Duration
    {
        get
        {
            return duration;
        }

        set
        {
            duration = value;
        }
    }

    public override void OnGraphStart(Playable playable)
    {
        Duration = playable.GetDuration();
        if (Mathf.Approximately((float)Duration, 0f))
            throw new UnityException("A TransformTween cannot have a duration of zero.");
        inverseDuration = 1f / (float)Duration;

    }
}