
using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class MessageEventClip : PlayableAsset, ITimelineClipAsset
{
    public MessageEventBehaviour template = new MessageEventBehaviour();

    public ClipCaps clipCaps
    {
        get { return ClipCaps.None; }
    }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<MessageEventBehaviour>.Create(graph, template);
        return playable;
    }
    
}
