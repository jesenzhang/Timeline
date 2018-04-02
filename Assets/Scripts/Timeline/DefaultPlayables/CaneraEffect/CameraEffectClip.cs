
using System;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[Serializable]
public class CameraEffectClip : PlayableAsset, ITimelineClipAsset
{
    public CameraEffectBehaviour template = new CameraEffectBehaviour();
    public ExposedReference<MonoBehaviour> Effect;
    public string EffectName;
#if UNITY_EDITOR
    public MonoBehaviour EffectObj;
    public Type EffectType;
    public PlayableDirector director;
    public int EffectIndex;
    public Camera camera;
#endif
    public ClipCaps clipCaps
    {
        get { return ClipCaps.Blending; }
    }

    public override Playable CreatePlayable(PlayableGraph graph, GameObject owner)
    {
        var playable = ScriptPlayable<CameraEffectBehaviour>.Create(graph, template);
        CameraEffectBehaviour clone = playable.GetBehaviour();
        clone.Effect = Effect.Resolve(graph.GetResolver());
        return playable;
    }
}