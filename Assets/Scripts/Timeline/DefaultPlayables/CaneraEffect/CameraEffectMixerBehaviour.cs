
using System;
using System.Collections.Generic;
using UnityEngine.Animations;
using UnityEngine;
using UnityEngine.Playables;


public class CameraEffectMixerBehaviour : PlayableBehaviour
{
    Camera cameraObj;
    List<MonoBehaviour> effectList = new List<MonoBehaviour>();
    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (cameraObj == null)
        {
            if (playerData is GameObject)
            {
                cameraObj = ((GameObject)playerData).GetComponent<Camera>();
            }
            else if (playerData is Camera)
            {
                cameraObj = playerData as Camera;
            }
        }
        if (cameraObj == null)
            return;

        int inputCount = playable.GetInputCount();
   
        Vector3 blendedPosition = Vector3.zero;
        Quaternion blendedRotation = new Quaternion(0f, 0f, 0f, 0f);
  
        for (int i = 0; i < inputCount; i++)
        {
            ScriptPlayable<CameraEffectBehaviour> playableInput = (ScriptPlayable<CameraEffectBehaviour>)playable.GetInput(i);
            CameraEffectBehaviour input = playableInput.GetBehaviour();

            float inputWeight = playable.GetInputWeight(i);
            float normalisedTime = (float)(playableInput.GetTime() * input.inverseDuration);
    
           // if (input.Effect == null && input.EffectType != null)
           // {
           //     Type effectype = input.EffectType;
           //     input.Effect = (MonoBehaviour)cameraObj.gameObject.AddComponent(effectype);
           // }

            if (input.Effect != null)
            {
                if (!effectList.Contains(input.Effect))
                {
                    effectList.Add(input.Effect);
                }
                if (inputWeight > 0)
                {
                    input.Effect.enabled = true;
                }
                else
                {
                    input.Effect.enabled = false;
                }
            }
          
        }
    }
    public override void OnGraphStart(Playable playable)
    {
        base.OnGraphStart(playable);
    }

    public override void OnGraphStop(Playable playable)
    {
        base.OnGraphStop(playable);
        for (int i = 0; i < effectList.Count; i++)
        {
            if(effectList[i])
                effectList[i].enabled = false;
        }
        effectList.Clear();
    }

}