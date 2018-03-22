
using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class AnimatorControlClip : PlayableAsset, ITimelineClipAsset
{
    public AnimatorControlBehavior template = new AnimatorControlBehavior();
    public string ClipName;
    public ClipCaps clipCaps
    {
        get { return ClipCaps.Blending; }
    }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<AnimatorControlBehavior>.Create(graph, template);
        AnimatorControlBehavior clone = playable.GetBehaviour();
       // template = clone;
        return playable;
    }
}