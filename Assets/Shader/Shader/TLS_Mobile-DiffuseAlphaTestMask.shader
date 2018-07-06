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

Shader "Hidden/Transparent/CutoutMask" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
    _Mask("Alpha", 2D) = "white" {}
	_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
}
SubShader {
	Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
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

sampler2D _MainTex;sampler2D _Mask;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 alpha = tex2D(_Mask, IN.uv_MainTex);
	o.Albedo = c.rgb*2;
	o.Alpha = alpha.r;
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

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  o.pos = UnityObjectToClipPos (v.vertex);
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
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
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

	// ---- deferred lighting base geometry pass:
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf

#pragma exclude_renderers flash
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_PREPASSBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 14 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

//#pragma surface surf Lambert noforwardadd alphatest:_Cutoff

sampler2D _MainTex;sampler2D _Mask;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 alpha = tex2D(_Mask, IN.uv_MainTex);
	o.Albedo = c.rgb*2;
	o.Alpha = alpha.r;
}


// vertex-to-fragment interpolation data
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  fixed3 normal : TEXCOORD1;
};
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  o.normal = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  return o;
}
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
  o.Normal = IN.normal;

  // call surface function
  surf (surfIN, o);

  // alpha test
  clip (o.Alpha - _Cutoff);

  // output normal and specular
  fixed4 res;
  res.rgb = o.Normal * 0.5 + 0.5;
  res.a = o.Specular;
  return res;
}

ENDCG

}

	// ---- deferred lighting final pass:
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_prepassfinal
#pragma exclude_renderers flash
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
#define UNITY_PASS_PREPASSFINAL
#include "UnityCG.cginc"
#include "Lighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 14 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

//#pragma surface surf Lambert noforwardadd alphatest:_Cutoff

sampler2D _MainTex;sampler2D _Mask;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 alpha = tex2D(_Mask, IN.uv_MainTex);
	o.Albedo = c.rgb*2;
	o.Alpha = alpha.r;
}


// vertex-to-fragment interpolation data
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float4 screen : TEXCOORD1;
#ifdef LIGHTMAP_OFF
  float3 vlight : TEXCOORD2;
#else
  float2 lmap : TEXCOORD2;
#ifdef DIRLIGHTMAP_OFF
  float4 lmapFadePos : TEXCOORD3;
#endif
#endif
};
#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
#endif
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  o.screen = ComputeScreenPos (o.pos);
#ifndef LIGHTMAP_OFF
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #ifdef DIRLIGHTMAP_OFF
    o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
    o.lmapFadePos.w = (-mul(UNITY_MATRIX_MV, v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
  #endif
#else
  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  o.vlight = ShadeSH9 (float4(worldN,1.0));
#endif
  return o;
}
sampler2D _LightBuffer;
#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
sampler2D _LightSpecBuffer;
#endif
#ifndef LIGHTMAP_OFF
// sampler2D unity_Lightmap;
// sampler2D unity_LightmapInd;
float4 unity_LightmapFade;
#endif
fixed4 unity_Ambient;
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

  // call surface function
  surf (surfIN, o);

  // alpha test
  clip (o.Alpha - _Cutoff);
  half4 light = tex2Dproj (_LightBuffer, UNITY_PROJ_COORD(IN.screen));
#if defined (SHADER_API_MOBILE)
  light = max(light, half4(0.001));
#endif
#ifndef HDR_LIGHT_PREPASS_ON
  light = -log2(light);
#endif
#if defined (SHADER_API_XBOX360) && defined (HDR_LIGHT_PREPASS_ON)
  light.w = tex2Dproj (_LightSpecBuffer, UNITY_PROJ_COORD(IN.screen)).r;
#endif

  // add lighting from lightmaps / vertex / ambient:
  #ifndef LIGHTMAP_OFF
    #ifdef DIRLIGHTMAP_OFF
      // dual lightmaps
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed4 lmtex2 = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
      half lmFade = length (IN.lmapFadePos) * unity_LightmapFade.z + unity_LightmapFade.w;
      half3 lmFull = DecodeLightmap (lmtex);
      half3 lmIndirect = DecodeLightmap (lmtex2);
      half3 lm = lerp (lmIndirect, lmFull, saturate(lmFade));
      light.rgb += lm;
    #else
      // directional lightmaps
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap, IN.lmap.xy);
      half4 lm = LightingLambert_DirLightmap(o, lmtex, lmIndTex, 0);
      light += lm;
    #endif
  #else
    light.rgb += IN.vlight;
  #endif
  half4 c = LightingLambert_PrePass (o, light);
  return c;
}

ENDCG

}

	// ---- end of surface shader generated code

#LINE 31

}

Fallback "Transparent/Cutout/VertexLit"
}
