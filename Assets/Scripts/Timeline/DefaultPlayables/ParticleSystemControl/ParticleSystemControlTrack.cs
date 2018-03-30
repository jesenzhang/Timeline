
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.855f, 0.8623f, 0.870f)]
[TrackClipType(typeof(ParticleSystemControlClip))]
[TrackBindingType(typeof(GameObject))]
public class ParticleSystemControlTrack : TrackAsset
{
    public float GetParticleDuration(GameObject gameObject)
    {
        ParticleSystem[] pchild = gameObject.GetComponentsInChildren<ParticleSystem>();

        float duration = 0;
        int len = pchild.Length;
        for (int i = 0; i < len; i++)
        {
            if (pchild[i].main.duration > duration)
            {
                duration = pchild[i].main.duration;
            }
        }
        return duration;
    }


    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
#if UNITY_EDITOR
        foreach (TimelineClip clip in m_Clips)
        {
            ParticleSystemControlClip mouthClip = clip.asset as ParticleSystemControlClip;
            // the template variable comes from classes made with the playable wizard
            ParticleSystemControlBehaviour behaviour = mouthClip.template;
            // name the track with my variables value
            clip.displayName =go.name;
            clip.duration = GetParticleDuration(go);
        }
#endif
        ScriptPlayable<ParticleSystemControlMixerBehaviour> playable = ScriptPlayable<ParticleSystemControlMixerBehaviour>.Create(graph, inputCount);

        return playable;
    }

}


