
using UnityEditor;
using UnityEngine;
/*
[CustomPropertyDrawer(typeof(MessageEventBehaviour))]
public class MessageEditorDrawer : PropertyDrawer
{
    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        int fieldCount = 20;
        return fieldCount * EditorGUIUtility.singleLineHeight;
    }

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        SerializedProperty timeScaleProp = property.FindPropertyRelative("msg");
        SerializedProperty paramList = property.FindPropertyRelative("paramList");
        SerializedProperty hasParam = property.FindPropertyRelative("hasParam");
        SerializedProperty param = property.FindPropertyRelative("param");

 
        Rect singleFieldRect = new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight);
        EditorGUI.PropertyField(singleFieldRect, timeScaleProp);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, hasParam);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, param);

        singleFieldRect.y += EditorGUIUtility.singleLineHeight;
        singleFieldRect.height = 10 * EditorGUIUtility.singleLineHeight;
        EditorGUI.PropertyField(singleFieldRect, paramList);

        



    }
}
*/