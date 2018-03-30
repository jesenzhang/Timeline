

using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class ParticleSystemControlClip : PlayableAsset, ITimelineClipAsset
{
    public ParticleSystemControlBehaviour template = new ParticleSystemControlBehaviour();
 
    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<ParticleSystemControlBehaviour>.Create(graph, template);
        ParticleSystemControlBehaviour clone = playable.GetBehaviour();
 
        return playable;
    }
}