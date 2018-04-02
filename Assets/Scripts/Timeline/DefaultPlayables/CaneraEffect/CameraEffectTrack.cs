
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.845f, 0.8123f, 0.860f)]
[TrackClipType(typeof(CameraEffectClip))]
[TrackBindingType(typeof(Camera))]
public class CameraEffectTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
#if UNITY_EDITOR
        foreach (TimelineClip clip in m_Clips)
        {
            CameraEffectClip mouthClip = clip.asset as CameraEffectClip;
            // the template variable comes from classes made with the playable wizard
            CameraEffectBehaviour behaviour = mouthClip.template;
            mouthClip.camera = go.GetComponent<PlayableDirector>().GetGenericBinding(this) as Camera;
            // name the track with my variables value
            clip.displayName = mouthClip.EffectName;
            mouthClip.director = go.GetComponent<PlayableDirector>();
        }
#endif
        ScriptPlayable<CameraEffectMixerBehaviour> playable = ScriptPlayable<CameraEffectMixerBehaviour>.Create(graph, inputCount);

        return playable;
    }
}


