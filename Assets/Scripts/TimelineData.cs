
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

[System.Serializable]
[RequireComponent(typeof(PlayableDirector))]
public class TimelineData : MonoBehaviour {

    public string PlayAseetName = "";
    PlayableDirector director;
    [SerializeField]
    public SerializableDictionaryReplaceInfo replaceDict = new SerializableDictionaryReplaceInfo();
    public Dictionary<string, Object> ObjectDict = new Dictionary<string, Object>();

    public PlayableDirector Director
    {
        get
        {
            if (director == null)
            {
                director = GetComponent<PlayableDirector>();
            }
            return director;
        }

        set
        {
            director = value;
        }
    }
    public IEnumerator LoadRes()
    {
        yield return new WaitForEndOfFrame(); 
    }

    public void ReplaceObj(string key ,Object obj)
    {
       
        foreach (KeyValuePair<string, ReplaceInfo> kvp in replaceDict)
        {
            ReplaceInfo info = kvp.Value;
            if (!ObjectDict.ContainsKey(kvp.Key))
            {
                ObjectDict.Add(kvp.Key, null);
            }
            if (info.dependence == null || info.dependence.Length==0)
            {
                if (info.isAnimator && !string.IsNullOrEmpty(info.controller))
                {
                    
                }
            }
        }
        var timelineAsset = Director.playableAsset as TimelineAsset;
        foreach (var at in timelineAsset.GetOutputTracks())
        {
            foreach (var att in Director.playableAsset.outputs)
            {
                Director.SetGenericBinding(att.sourceObject, null);
            }
        }
         
    }

    void Start()
    {
       
    }

    // Update is called once per frame
    void Update () {
		
	}
}
