using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections;
using TMPro;

public class CardDataObj : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler
{
    Image face;
    TextMeshProUGUI des;

    public void OnBeginDrag(PointerEventData eventData)
    {
        SetDraggedPosition(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        SetDraggedPosition(eventData);
    }

    public void OnEndDrag(PointerEventData eventData)
    {
        SetDraggedPosition(eventData);
        UICardPad cardpad = (UICardPad)UIManager.Instance.GetPageInstatnce<UICardPad>();
        cardpad.UseCard(this);
    }

    private void SetDraggedPosition(PointerEventData eventData)
    {
        var rt = gameObject.GetComponent<RectTransform>();

        // transform the screen point to world point int rectangle
        Vector3 globalMousePos;
        if (RectTransformUtility.ScreenPointToWorldPointInRectangle(rt, eventData.position, eventData.pressEventCamera, out globalMousePos))
        {
            rt.position = globalMousePos;
        }
    }
    public CardProperty data;

    public int CardId = 0;

    public void UpdateShow()
    {
        if (data==null)
            return;
        if (des)
        {
            des.text = data.Des;
        }
        if (face)
        {
            
        }
    }

    // Use this for initialization
    private void Awake()
    {
        face = this.transform.Find("face").GetComponent<Image>();
        des = this.transform.Find("des").GetComponent<TextMeshProUGUI>();
    }

    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
