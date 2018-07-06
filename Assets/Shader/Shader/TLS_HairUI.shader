// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/Character/HairUI" {
Properties {
	_ColorA("Color1",Color) = (1,1,1,1)
    _ColorB("Color2",Color) = (1,1,1,1)
    _RimColor("RimColor",Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	 _Reflection ("Reflection", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_lightDirection("LightDireciotn",Vector) = (1,1,1,1)
	_AmbientColor("AmbientLight",Color) = (0.5,0.5,0.5,0.5)
}
SubShader {
	Tags {"Queue"="AlphaTest+150" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 100

	Lighting Off

		Pass {  
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				
				#include "UnityCG.cginc"
				struct v2f {
					float4 vertex : SV_POSITION;
					half2 texcoord : TEXCOORD0;
					float3 normal : TEXCOORD1;
					float3 viewDirection:TEXCOORD2;
				};

				sampler2D _MainTex;
				sampler2D _Reflection;
				half4 _MainTex_ST;
				fixed _Cutoff;
				fixed4 _ColorA;
				fixed4 _ColorB;
				fixed4 _RimColor;
				float4 _lightDirection;
				fixed4 _AmbientColor;

				v2f vert (appdata_full v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.normal =  mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
					o.viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
					return o;
				}
				
				fixed4 frag (v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.texcoord);
					clip(col.b - _Cutoff);
					fixed3 lightDirection =  normalize (_lightDirection.xyz);
					fixed3 normalDirection =normalize(i.normal);
					fixed2 ReflUV = mul( UNITY_MATRIX_V, float4(normalDirection,0)).rg*0.5+0.5;
                    fixed4 _Reflection_var = tex2D(_Reflection,ReflUV);
                    fixed rim =1 - max(0,dot(i.viewDirection,normalDirection));
					fixed diffLight =max(0.2,dot(lightDirection,normalDirection))+_AmbientColor;
					fixed4 hairColor = lerp(_ColorB,_ColorA,col.r)*col.g;
					fixed4 final = diffLight*hairColor+_Reflection_var*pow(col.g,5)+rim*rim*_RimColor;
					return final;
				}
			ENDCG
		}
	}
}
