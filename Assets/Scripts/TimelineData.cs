
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

[System.Serializable]
[RequireComponent(typeof(PlayableDirector))]
public class TimelineData : MonoBehaviour {

    public string PlayAseetName = "";
    PlayableDirector director;
    [SerializeField]
    public SerializableDictionaryReplaceInfo replaceDict = new SerializableDictionaryReplaceInfo();

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


    public void ReplaceObj()
    {

    }

    void Start()
    {
       
    }

    // Update is called once per frame
    void Update () {
		
	}
}
