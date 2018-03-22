
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;
using UnityEngine.UI;

[CustomPropertyDrawer(typeof(AnimatorControlBehavior))]
public class AnimatorControlDraw : PropertyDrawer
{

    List<string> names = new List<string>();
    int select = 0;
    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        int fieldCount = 1;
        return fieldCount * EditorGUIUtility.singleLineHeight;
    }

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        AnimatorControlClip obj = (AnimatorControlClip)property.serializedObject.targetObject;
        Animator animator = obj.template.animator;

        if (animator == null)
        {
            names.Clear();
            return;
        }
        AnimatorController controller = animator ? animator.runtimeAnimatorController as AnimatorController : null;
        int N = controller.animationClips.Length;
        if (names.Count <= 0 && N>0)
        {
            for (int i = 0; i < N; i++)
            {
                names.Add(controller.animationClips[i].name);
            }
        }

        select = EditorGUILayout.Popup("Select Clip", select, names.ToArray());

        obj.template.ClipName = controller.animationClips[select].name;
        obj.template.Clip = controller.animationClips[select];
        obj.ClipName = obj.template.ClipName;
       // SerializedProperty colorProp = property.FindPropertyRelative("ClipName");

        //  Rect singleFieldRect = new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight);
        // EditorGUI.PropertyField(singleFieldRect, colorProp);


    }
}
