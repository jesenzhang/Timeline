using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using VFrame.ABSystem;

internal class PrefabObjectPool : ObjectPool<GameObject>
{
    public GameObject prefab;
    
    public new GameObject Get()
    {
        GameObject element;
        if (m_Stack.Count == 0)
        {
            element = GameObject.Instantiate(prefab);
            countAll++;
        }
        else
        {
            element = m_Stack.Pop();
        }
        if (m_ActionOnGet != null)
            m_ActionOnGet(element);
        return element;
    }

    public new void Release(GameObject element)
    {
        if (m_Stack.Count > 0 && ReferenceEquals(m_Stack.Peek(), element))
            Debug.LogError("Internal error. Trying to destroy object that is already released to pool.");
        if (m_ActionOnRelease != null)
            m_ActionOnRelease(element);
        m_Stack.Push(element);
    }
}

public class EntityCenter : MonoBehaviour {

    PrefabObjectPool CardPool = new PrefabObjectPool();
    GameObject CardPrefab;
    public static EntityCenter Instance;

    private void Awake()
    {
        Instance = this;
    }

    public void InitData()
    {
        AssetBundleManager.Instance.Load("Assets.Prefabs.Model.Card.prefab", (go) => {
          
            CardPrefab = go.Instantiate();
            CardPrefab.SetActive(false);
            CardPool.prefab = CardPrefab;
        });
    }
    CardProperty CloneCard(CardProperty old)
    {
        CardProperty newcard = new CardProperty
        {
            CardName = old.CardName,
            id = old.id,
            Des = old.Des,
            func = old.func,
            target = old.target,
            tid = old.tid,
            type = old.type,
            Values = (int[])old.Values.Clone()
        };
        return newcard;
    }

    public GameObject GetCard(int id)
    {
        int k = 0;
        CardProperty[] allcard = GameData.Instance.SystemData.AllCards;
        for (int i = 0; i < allcard.Length; i++)
        {
            if (allcard[i].id == id)
            {
                k = i;
                i = allcard.Length;
            }
        }
        GameObject newcard = CardPool.Get();
        newcard.SetActive(true);
        newcard.GetComponent<CardDataObj>().data = (CardProperty)allcard[k].Clone();
        return newcard;
    }

    public void ReleaseCard(GameObject card)
    {
        card.transform.localPosition = Vector3.zero;
        card.transform.localRotation = Quaternion.identity;
        card.transform.localScale = Vector3.one;
        card.transform.parent = this.transform;
        card.SetActive(false);
        card.GetComponent<CardDataObj>().data =null;
        CardPool.Release(card);
    }

    // Use this for initialization
    void Start () {

      
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
