using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using VFrame.UI;
using VFrame.Common;
using System;

public class UIManager : UnitySingleton<UIManager>  {


    public void ShowUI<T>() where T : UIPage, new()
    {
        UIPage.ShowPage<T>(null);
    }

    public void ShowUI<T>(Action callback,object data) where T : UIPage, new()
    {
        UIPage.ShowPage<T>(callback,data);
    }

    public UIPage GetPageInstatnce<T>() where T : UIPage, new()
    {
        return UIPage.GetPageInstatnce<T>();
    }

    internal void ShowUI<T>(object p)
    {
        throw new NotImplementedException();
    }
}
