 
using System;
using System.Collections.Generic;
using UnityEngine.Animations;
using UnityEngine;
using UnityEngine.Playables;


public class AnimatorControlMixerBehaviour : PlayableBehaviour
{
    private PlayableGraph playableGraph;
    private AnimationMixerPlayable mixer;
    Animator animator = null;
    private List<AnimationClipPlayable> clips = new List<AnimationClipPlayable>();
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (animator == null)
        {
            if (playerData is GameObject)
            {
                animator = ((GameObject)playerData).GetComponent<Animator>();
            }
            else if (playerData is Animator)
            {
                animator = playerData as Animator;
            }
        }

        if (animator == null)
            return;

        Vector3 defaultPosition = animator.gameObject.transform.position;
        Quaternion defaultRotation = animator.gameObject.transform.rotation;

        int inputCount = playable.GetInputCount();
        if (clips.Count <= 0)
        {
            mixer = AnimationPlayableUtilities.PlayMixer(animator, inputCount, out playableGraph);
        }

        Vector3 blendedPosition = Vector3.zero;
        Quaternion blendedRotation = new Quaternion(0f, 0f, 0f, 0f);
        RuntimeAnimatorController controller = animator ? animator.runtimeAnimatorController as RuntimeAnimatorController : null;

        for (int i = 0; i < inputCount; i++)
        {
            ScriptPlayable<AnimatorControlBehavior> playableInput = (ScriptPlayable<AnimatorControlBehavior>)playable.GetInput(i);
            AnimatorControlBehavior input = playableInput.GetBehaviour();
      
            float inputWeight = playable.GetInputWeight(i);
            float normalisedTime = (float)(playableInput.GetTime() * input.inverseDuration);
           
            if (input.Clip == null || input.Clip.name != input.ClipName)
            {
                for (int j= 0; j < controller.animationClips.Length; j++)
                {
                    AnimationClip clip = controller.animationClips[j];
                  
                    if (clip.name == input.ClipName)
                    {
                        input.Clip = clip;
                    }
                }
            }
            if (input.Clip)
            {
                if (clips.Count <= i)
                {
                    AnimationClipPlayable clipplay = AnimationClipPlayable.Create(playableGraph, input.Clip);
                    playableGraph.Connect(clipplay, 0, mixer, i);
                    clips.Add(clipplay);
                }
                mixer.SetInputWeight(i, inputWeight);
                clips[i].SetTime((double)normalisedTime * input.Clip.length);
                clips[i].SetSpeed(0);
            }
        }
        if(!Application.isPlaying)
           playableGraph.Evaluate();
    }

    public override void OnGraphStart(Playable playable)
    {
        base.OnGraphStart(playable);
        clips.Clear();
    }

    public override void PrepareData(Playable playable, FrameData info)
    {
        base.PrepareData(playable, info);
    }

    public override void OnPlayableDestroy(Playable playable)
    {
        if(playableGraph.IsValid())
            playableGraph.Destroy();
    }

}