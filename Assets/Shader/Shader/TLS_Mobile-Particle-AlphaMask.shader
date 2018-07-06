// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Effect/AlphaBlendedMask" {
    Properties {
		_MainTex("Particle Texture", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 150
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
			Cull Off Lighting Off ZWrite Off Fog{ Color(0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			sampler2D _Mask; sampler2D _MainTex; float4 _MainTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float3 finalColor = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                fixed4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _MainTex));
                return fixed4(finalColor,_Mask_var.r);
            }
            ENDCG
        }
    }
}
