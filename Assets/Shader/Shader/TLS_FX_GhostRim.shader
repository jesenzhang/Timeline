// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/FX/Ghost" {
    Properties {
        _MainColor ("MainColor", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _RimRange ("RimRange", Range(0, 1)) = 1
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 150
			Pass
		{
			ColorMask A
		}
        Pass {
			//ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 3.0
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
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);

                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                fixed4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (_MainColor.rgb*max(0,dot(_MainTex_var.rgb,fixed3(0.22,0.707,0.071))));
                float rim = pow(1.0-max(0,dot(i.normalDir, viewDirection)),_RimRange);
                float3 finalColor = emissive + (rim*_RimColor.rgb)*2;
                return fixed4(finalColor,(_MainTex_var.a*(rim *2+0.3)));
            }
            ENDCG
        }
    }
    FallBack "Unlit/Texture"
}
