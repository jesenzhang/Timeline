// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/FX/GrayScale" {
    Properties {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimRange ("RimRange", Range(0, 5)) = 1
    }
    SubShader {
        Tags {
            "Queue"="Geometry+500"
            "RenderType"="Opaque"
			"IgnoreProjector" = "True"
        }
        LOD 150
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            uniform fixed4 _MainColor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform fixed _RimRange;
            uniform fixed4 _RimColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                fixed3 normalDir : TEXCOORD1;
				fixed3 viewDirection : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
				o.normalDir = normalize(o.normalDir);
                o.pos = UnityObjectToClipPos(v.vertex);
				float3 posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.viewDirection = normalize(_WorldSpaceCameraPos.xyz - posWorld);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {

				fixed3 viewDirection = i.viewDirection;
				fixed3 normalDirection = i.normalDir;
                fixed4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
				fixed3 color = (_MainColor.rgb*max(0,dot(_MainTex_var.rgb,fixed3(0.22,0.707,0.071))));
                fixed3 finalColor = color + (pow(1.0-max(0,dot(i.normalDir, viewDirection)),_RimRange)*_RimColor.rgb);
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Unlit/Texture"
}
