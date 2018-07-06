// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "TLStudio/Transparent/Cutout_Ani" {
Properties {
	_Color("Color",Color) = (1.0, 1.0, 1.0, 1.0)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	_Range("Range" , Range(0,0.1)) = 0.05

}
SubShader {
	Tags { "Queue"="AlphaTest+100" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
	LOD 200
	Cull Off


	// ------------------------------------------------------------
	// Surface shader code generated out of a CGPROGRAM block:
	

	// ---- forward rendering base pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		ColorMask RGBA

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_fwdbase
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 14 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

//#pragma surface surf Lambert noforwardadd alphatest:_Cutoff

sampler2D _MainTex;
	fixed4 _Color;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb*_Color.rgb;
	o.Alpha = c.a*_Color.a;
}


// vertex-to-fragment interpolation data
#ifdef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  fixed3 normal : TEXCOORD1;
  fixed3 vlight : TEXCOORD2;
  LIGHTING_COORDS(3,4)
};
#endif
#ifndef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float2 lmap : TEXCOORD1;
  LIGHTING_COORDS(2,3)
};
#endif
#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
#endif
float4 _MainTex_ST;
half	_Range;
// vertex shader
v2f_surf vert_surf (appdata_full v) {
	half4	finalpos = mul(unity_ObjectToWorld,v.vertex);
	half3	dist =	_WorldSpaceCameraPos.xyz - finalpos.xyz;
	half4	mdlPos;
	if(length(dist) < 25)
	{
		float 	finalbias = fmod(finalpos.x*finalpos.x + finalpos.y*finalpos.y + finalpos.z*finalpos.z,4);
		if(v.color.r == 0)
		{
			mdlPos	= v.vertex;
		}
		else
		{
			half st = 0;
			if(finalbias < 1) st = max(_CosTime.w + 0.3, -0.5);
			else if(finalbias >= 1 && finalbias < 2) st = min(_SinTime.w, 0.8) * finalbias;
			else if(finalbias >= 2 && finalbias < 3) st = min(_CosTime.w, 0.9) * finalbias;
			else if(finalbias >= 3 && finalbias < 4) st = max(_SinTime.w + 0.8, -0.8) * finalbias;
			mdlPos.xyz = v.vertex.xyz + v.tangent * st * _Range ;
			mdlPos.w = v.vertex.w;
		}
	}
	else
	{
		mdlPos = v.vertex;
	}

	v2f_surf o;
	o.pos = UnityObjectToClipPos(mdlPos);
	o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);

	#ifndef LIGHTMAP_OFF
		o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#endif
	
	float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);

	#ifdef LIGHTMAP_OFF
		o.normal = worldN;
	#endif

	// SH/ambient and vertex lights
	#ifdef LIGHTMAP_OFF
		float3 shlight = ShadeSH9 (float4(worldN,1.0));
		o.vlight = shlight;
		#ifdef VERTEXLIGHT_ON
			float3 worldPos = mul(unity_ObjectToWorld, mdlPos).xyz;
			o.vlight += Shade4PointLights (
			  unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			  unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			  unity_4LightAtten0, worldPos, worldN );
		#endif // VERTEXLIGHT_ON
	#endif // LIGHTMAP_OFF

	  // pass lighting information to pixel shader
	  TRANSFER_VERTEX_TO_FRAGMENT(o);
	  return o;
}
#ifndef LIGHTMAP_OFF
// sampler2D unity_Lightmap;
#ifndef DIRLIGHTMAP_OFF
// sampler2D unity_LightmapInd;
#endif
#endif
fixed _Cutoff;

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  // prepare and unpack data
  #ifdef UNITY_COMPILER_HLSL
  Input surfIN = (Input)0;
  #else
  Input surfIN;
  #endif
  surfIN.uv_MainTex = IN.pack0.xy;
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutput o = (SurfaceOutput)0;
  #else
  SurfaceOutput o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Specular = 0.0;
  o.Alpha = 0.0;
  o.Gloss = 0.0;
  #ifdef LIGHTMAP_OFF
  o.Normal = IN.normal;
  #endif

  // call surface function
  surf (surfIN, o);

  // alpha test
  clip (o.Alpha - _Cutoff);

  // compute lighting & shadowing factor
  fixed atten = LIGHT_ATTENUATION(IN);
  fixed4 c = 0;

  // realtime lighting: call lighting function
  #ifdef LIGHTMAP_OFF
  c = LightingLambert (o, _WorldSpaceLightPos0.xyz, atten);
  #endif // LIGHTMAP_OFF || DIRLIGHTMAP_OFF
  #ifdef LIGHTMAP_OFF
  c.rgb += o.Albedo * IN.vlight;
  #endif // LIGHTMAP_OFF

  // lightmaps:
  #ifndef LIGHTMAP_OFF
    #ifndef DIRLIGHTMAP_OFF
      // directional lightmaps
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
      half3 lm = LightingLambert_DirLightmap(o, lmtex, lmIndTex, 0).rgb;
    #else // !DIRLIGHTMAP_OFF
      // single lightmap
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed3 lm = DecodeLightmap (lmtex);
    #endif // !DIRLIGHTMAP_OFF

    // combine lightmaps with realtime shadows
    #ifdef SHADOWS_SCREEN
      #if defined(UNITY_NO_RGBM)
      c.rgb += o.Albedo * min(lm, atten*2);
      #else
      c.rgb += o.Albedo * max(min(lm,(atten*2)*lmtex.rgb), lm*atten);
      #endif
    #else // SHADOWS_SCREEN
      c.rgb += o.Albedo * lm;
    #endif // SHADOWS_SCREEN
  c.a = o.Alpha;
  #endif // LIGHTMAP_OFF

  c.a = o.Alpha;
  return c;
}

ENDCG

}
    	Pass
	{
		Name "ShadowCollector"
		Tags { "LightMode" = "ShadowCollector" }
		
		Fog {Mode Off}
		ZWrite On ZTest LEqual

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_shadowcollector

		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"

		struct appdata {
			float4 vertex : POSITION;
		};

		struct v2f {
			V2F_SHADOW_COLLECTOR;
		};

		v2f vert (appdata v)
		{
			v2f o;
			TRANSFER_SHADOW_COLLECTOR(o)
			return o;
		}

		fixed4 frag (v2f i) : SV_Target
		{
			SHADOW_COLLECTOR_FRAGMENT(i)
		}
		ENDCG
	}
	// ---- end of surface shader generated code

#LINE 31

}
Fallback "TLStudio/Transparent/UnLit Cutout"
}
