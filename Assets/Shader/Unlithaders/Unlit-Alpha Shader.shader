Shader "Unlit/UnlitAlphaWithFade"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)   
        _MainTex ("Base (RGB) Alpha (A)", 2D) = "white"
    }

    Category
    {
		Tags {"Queue"="Geometry+1" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Lighting Off
        ZWrite Off
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        Tags {Queue=Transparent}

        SubShader
        {

             Pass
             {
                        SetTexture [_MainTex]
                        {
                    ConstantColor [_Color]
                   Combine Texture * constant
                }
            }
        }
    }
}