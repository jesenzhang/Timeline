// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/Character/Character1\4" {
    Properties {
		_Color("AddColor", Color) = (0,0,0,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Reflection ("Reflection", 2D) = "white" {}
        _RimColor ("RimColor", Color) = (1,1,1,1)
        _ShadeColor ("Shade Color", Color) = (0.7, 0.3, 0.6, 1)
		[HideInInspector]_Cutoff ("",float) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest+50"
            "RenderType"="TransparentCutout"
        }
		LOD 150
		//Pass
		//{
		//   Blend One One
  //         Lighting Off   
		//   ZTest Greater 
		//   ZWrite Off
		//   CGPROGRAM
		//   #pragma vertex vert
		//   #pragma fragment frag
		//   #pragma fragmentoption ARB_precision_hint_fastest   
   
		//   float4 _ShadeColor;
		//   struct appdata
		//   {
		//		float4 vertex : POSITION;
		//		float3 _normal : NORMAL;
		//		half2 uv0 : TEXCOORD0;
		//   };

		//   struct v2f
		//   {
		//		float4 pos : POSITION; 
		//		float2 uv0 : TEXCOORD0;  
		//   };

		//   v2f vert(appdata v)
		//   {
		//		v2f o;
		//		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		//		o.uv0 = v.uv0;
		//		return o;
		//   }
		//   float4 frag(v2f i) : COLOR
		//   {
		//		return _ShadeColor;
		//   }
		//   ENDCG
		//} 
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            ColorMask RGBA
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #define SHOULD_SAMPLE_SH_PROBE ( defined (LIGHTMAP_OFF) )
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            uniform float4 _LightColor0;
            uniform sampler2D _Reflection; uniform float4 _Reflection_ST;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform fixed4 _Color;
            uniform fixed4 _RimColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                fixed3 viewDirection : TEXCOORD1;
                fixed3 normalDir : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                float3 shLight : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                #if SHOULD_SAMPLE_SH_PROBE
                    o.shLight = ShadeSH9(float4(mul(unity_ObjectToWorld, float4(v.normal,0)).xyz * 1.0,1));
                #endif
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                fixed3 normalDirection = i.normalDir;
                half2 uvEighth = ((i.uv0*0.4375)+0.53135);
                fixed4 CtrlTex = tex2D(_MainTex,TRANSFORM_TEX(uvEighth, _MainTex));
				fixed4 _MainTexColor = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                clip(_Color.a-CtrlTex.g);
                fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                fixed attenuation = LIGHT_ATTENUATION(i)*0.9;
                fixed3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                fixed NdotL = max(0.2,dot( normalDirection, lightDirection ));
                fixed3 indirectDiffuse = UNITY_LIGHTMODEL_AMBIENT.rgb*2;
                fixed3 directDiffuse =NdotL* attenColor*(1-CtrlTex.b);
                #if SHOULD_SAMPLE_SH_PROBE
                    indirectDiffuse += i.shLight;
                #endif
                fixed3 diffuse = (directDiffuse + indirectDiffuse) * _MainTexColor.rgb;
////// Emissive:
				fixed rimRange = 1-abs(dot(i.viewDirection,normalDirection));
                fixed2 ReflUV = mul( UNITY_MATRIX_V, float4(normalDirection,0)).rg*0.5+0.5;
                fixed4 _Reflection_var = tex2D(_Reflection,TRANSFORM_TEX(ReflUV, _Reflection));
				//fixed ReflectionRange = tex2D(_Reflection, TRANSFORM_TEX(i.uv0, _MainTex));
                fixed3 emissive = _Color.rgb+_Reflection_var.rgb*CtrlTex.r+rimRange*rimRange*_RimColor+ _MainTexColor.rgb * CtrlTex.b*0.5;
;
				//float3 emissive = _Color.rgb + _Reflection_var.rgb*ReflectionRange;
/// Final Color:
                fixed3 finalColor = diffuse + emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
			FallBack "Mobile/Diffuse"
}
