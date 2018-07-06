// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/FX/WaterReflection" { 
Properties {
	_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.063
	_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.44
	_BumpMap ("Normalmap ", 2D) = "bump" {}
	WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
	_ReflectiveColorCube ("Reflective color cube", Cube) = "" { TexGen EyeLinear }
	_MainTex ("Fallback texture", 2D) = "" {}
	_ReflectionTex ("Internal Reflection", 2D) = "" {}
}


// -----------------------------------------------------------
// Fragment program cards


	Subshader { 
		LOD 200
		Tags { "WaterMode"="Reflective" "RenderType"="Opaque" }
		Pass {
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma fragmentoption ARB_precision_hint_fastest 
	#pragma multi_compile  WATER_REFLECTIVE WATER_SIMPLE
	#if defined (WATER_REFLECTIVE)
	#define HAS_REFLECTION 1
	#endif

	#include "UnityCG.cginc"

	uniform float4 _WaveScale4;
	uniform float4 _WaveOffset;
	uniform float _ReflDistort;
	struct appdata {
		float4 vertex : POSITION;
		float3 normal : NORMAL;
	};

	struct v2f {
		float4 pos : SV_POSITION;
		float4 ref : TEXCOORD0;
		float2 bumpuv0 : TEXCOORD1;
		float2 bumpuv1 : TEXCOORD2;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos (v.vertex);
		
		// scroll bump waves
		float4 temp;
		temp.xyzw = v.vertex.xzxz * _WaveScale4/ 1.0 + _WaveOffset;
		o.bumpuv0 = temp.xy;
		o.bumpuv1 = temp.wz;
		#if defined(HAS_REFLECTION)
		o.ref = ComputeScreenPos(o.pos);
		#else
		float3 viewDir = WorldSpaceViewDir( v.vertex );
		float3 worldN = mul((float3x3)unity_ObjectToWorld, v.normal * 1.0);
		o.ref =  float4(reflect( -viewDir, worldN),1);
		#endif	
		return o;
	}

	#if defined (WATER_REFLECTIVE) 
	sampler2D _ReflectionTex;
	#else
	samplerCUBE  _ReflectiveColorCube;
	#endif
	sampler2D _BumpMap;
	half4 frag( v2f i ) : SV_Target
	{
		// combine two scrolling bumpmaps into one
		half3 bump1 = UnpackNormal(tex2D( _BumpMap, i.bumpuv0 )).rgb;
		half3 bump2 = UnpackNormal(tex2D( _BumpMap, i.bumpuv1 )).rgb;
		half3 bump = (bump1 + bump2) * 0.5;
		// perturb reflection/refraction UVs by bumpmap, and lookup colors
		float4 uv1 = i.ref; 
		uv1.xy += bump * _ReflDistort;
		#if HAS_REFLECTION
		half4 refl = tex2Dproj( _ReflectionTex, UNITY_PROJ_COORD(uv1) );
		#endif
		half4 color;
		#if defined(WATER_REFLECTIVE)
		color.rgb =refl.rgb;
		color.a = refl.a;
		#else
		fixed4 tex = texCUBE( _ReflectiveColorCube, uv1);
		color.rgb =  tex.rgb;
		color.a = tex.a;
		#endif
		return color;
	}
	ENDCG
		}
	}
	// single texture
	Subshader {
		LOD 150
		Tags { "WaterMode"="Simple" "RenderType"="Opaque" }
		Pass {
			//Color (0.5,0.5,0.5,0.5)
			SetTexture [_MainTex] {
				Matrix [_WaveMatrix]
				combine texture * primary
			}
			SetTexture [_MainTex] {
				Matrix [_WaveMatrix2]
				combine texture * primary + previous
			}
			SetTexture [_ReflectiveColorCube] {
				combine texture +- previous, primary
				Matrix [_Reflection]
			}
		}
	}
}
