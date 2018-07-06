// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TLStudio/FX/UVRollingAlpha" {
    Properties {
        _MainColor("Color",Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Light ("Light", Float ) = 2
        _Speed2("Speedu", Float) = 0
        _Speed ("Speedv", Float ) = 0
        
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Light;
            uniform float _Speed, _Speed2;
            uniform float _Alpha;
            uniform float4 _MainColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {

                float4 time = _Time + _TimeEditor;
                float2 rolling = (i.uv0.rg+time.g*float2(1,1)*float2(_Speed2,_Speed));
                float4 tex = tex2D(_MainTex,TRANSFORM_TEX(rolling, _MainTex));
                float3 finalColor = (_Light*tex.rgb)*_MainColor.rgb;

                return fixed4(finalColor,tex.a*_MainColor.a);
            }
            ENDCG
        }
    }

}
