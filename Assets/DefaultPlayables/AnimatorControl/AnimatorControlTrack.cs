
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.855f, 0.8623f, 0.870f)]
[TrackClipType(typeof(AnimatorControlClip))]
[TrackBindingType(typeof(Animator))]
public class AnimatorControlTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {
#if UNITY_EDITOR
        foreach (TimelineClip clip in m_Clips)
        {
            AnimatorControlClip mouthClip = clip.asset as AnimatorControlClip;
            // the template variable comes from classes made with the playable wizard
            AnimatorControlBehavior behaviour = mouthClip.template;
            // name the track with my variables value
            clip.displayName =  behaviour.ClipName;
            if(behaviour.Clip)
                clip.duration = behaviour.Clip.length;
            behaviour.animator = go.GetComponent<PlayableDirector>().GetGenericBinding(this) as Animator;
        }
#endif
        ScriptPlayable<AnimatorControlMixerBehaviour> playable = ScriptPlayable<AnimatorControlMixerBehaviour>.Create(graph, inputCount);
      
        return playable;
    }

    public override void GatherProperties(PlayableDirector director, IPropertyCollector driver)
    {
#if UNITY_EDITOR
        var comp = director.GetGenericBinding(this) as Animator;
        if (comp == null)
            return;
        var so = new UnityEditor.SerializedObject(comp);
        var iter = so.GetIterator();
        while (iter.NextVisible(true))
        {
            if (iter.hasVisibleChildren)
                continue;
            driver.AddFromName<Animator>(comp.gameObject, iter.propertyPath);
        }
#endif
        base.GatherProperties(director, driver);
    }
}


