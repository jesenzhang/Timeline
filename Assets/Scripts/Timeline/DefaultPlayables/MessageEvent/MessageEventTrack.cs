
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[TrackColor(0.855f, 0.8623f, 0.87f)]
[TrackClipType(typeof(MessageEventClip))]
public class MessageEventTrack : TrackAsset
{
    public override Playable CreateTrackMixer(PlayableGraph graph, GameObject go, int inputCount)
    {

        foreach (TimelineClip clip in m_Clips)
        {
            MessageEventClip mouthClip = clip.asset as MessageEventClip;
            // the template variable comes from classes made with the playable wizard
            MessageEventBehaviour behaviour = mouthClip.template;
            // name the track with my variables value
            // clip.duration = 0.03f;
             behaviour.Data = go.GetComponent<TimelineTools.SequenceData>();
        }

        return ScriptPlayable<MessageEventMixerBehaviour>.Create(graph, inputCount);
    }
}
