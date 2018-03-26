
using System;
using System.Collections.Generic;
using UnityEngine.Animations;
using UnityEngine;
using UnityEngine.Playables;


public class ParticleSystemControlMixerBehaviour : PlayableBehaviour
{
    ParticleSystem[] particleSystem = null; 

    private Transform ParticleRoot;
    ParticleSystem[] particleSys;

    public bool IsRoot(ParticleSystem ps)
    {
        if (ps == null)
        {
            return false;
        }

        var parent = ps.transform.parent;

        if (parent == null)
            return true;
        if (parent.GetComponent<ParticleSystem>() != null)
            return false;
        else
            return true;

    }

    public ParticleSystem[] ParticleSys
    {
        get
        {
            if (particleSys == null && ParticleRoot != null)
            {
                List<ParticleSystem> aparticleSys = new List<ParticleSystem>();
                ParticleSystem[] tparticleSys = ParticleRoot.GetComponentsInChildren<ParticleSystem>();
                for (int i = 0; i < tparticleSys.Length; i++)
                {
                    if (IsRoot(tparticleSys[i]))
                    {
                        aparticleSys.Add(tparticleSys[i]);
                    }
                }
                particleSys = aparticleSys.ToArray();
            }
            return particleSys;
        }

        set
        {
            particleSys = value;
        }
    }


    public override void ProcessFrame(Playable playable, FrameData info, object playerData)
    {
        if (particleSystem == null)
        {
            if (playerData is GameObject)
            {
                ParticleRoot = ((GameObject)playerData).transform;
            }
            else if (playerData is ParticleSystem)
            {
                ParticleRoot = ((ParticleSystem)playerData).gameObject.transform;
            }
        }

        if (ParticleSys == null)
            return;


        int inputCount = playable.GetInputCount();

        for (int i = 0; i < inputCount; i++)
        {
            ScriptPlayable<ParticleSystemControlBehaviour> playableInput = (ScriptPlayable<ParticleSystemControlBehaviour>)playable.GetInput(i);
            ParticleSystemControlBehaviour input = playableInput.GetBehaviour();

            float inputWeight = playable.GetInputWeight(i);
            float normalisedTime = (float)(playableInput.GetTime() * input.inverseDuration);

            if (ParticleSys != null)
            {
                for (int j = 0; j < ParticleSys.Length; j++)
                {
                    ParticleSys[j].Simulate(normalisedTime, true, true);
                }
            }

        }
    }
    
}