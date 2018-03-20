using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

[System.Serializable]
public class TestPlayableAsset : PlayableAsset
{
    public TestPlayableBehaviour behaviour;
	// Factory method that generates a playable based on this asset
	public override Playable CreatePlayable(PlayableGraph graph, GameObject go) {
		return Playable.Create(graph);
	}
}
