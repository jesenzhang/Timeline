// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TLStudio/Effect/Destabilization" {
    Properties {
        _MainTexture ("MainTexture", 2D) = "white" {}
        _OffsetTexture ("NoiseTexture", 2D) = "bump" {}
        _Offset ("Intensity", Range(0, 1)) = 0
        _horizontal("HorizontalSpeed",float) = 0
        _vertical("VerticalSpeed",float) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
			Cull Off
            Blend One OneMinusSrcColor
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            uniform float4 _TimeEditor;
            uniform float  _horizontal,_vertical;
            uniform sampler2D _MainTexture; uniform float4 _MainTexture_ST;
            uniform sampler2D _OffsetTexture; uniform float4 _OffsetTexture_ST;
            uniform float _Offset;
            struct VertexInput {
                float4 vertex : POSITION;
                half2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float4 timer = _Time + _TimeEditor;
                half2 speed= half2(_horizontal,_vertical);
                half2 offsetTextureUV = (i.uv0+timer.g*speed);
                fixed3 _OffsetTexture_var = tex2D(_OffsetTexture,TRANSFORM_TEX(offsetTextureUV, _OffsetTexture))*2-1;
                half2 mainTextureUV = (i.uv0+_OffsetTexture_var.rg*_Offset);
                fixed4 _MainTexture_var = tex2D(_MainTexture,TRANSFORM_TEX(mainTextureUV, _MainTexture));
                _MainTexture_var.rgb = _MainTexture_var.rgb*_MainTexture_var.a;
                return _MainTexture_var;
                
            }
            ENDCG
        }
    }
}
