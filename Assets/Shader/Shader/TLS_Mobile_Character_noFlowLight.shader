// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

//2015_10_22//
//CYED_TAShader_XYJCharacter_3.0 By KK//

Shader "TLStudio/Character/Non FlowingLight" 
{
	Properties 
	{
	  	_Color ("基础颜色", Color) = (1,1,1,1)
	  	_MainTex ("固有色(RGB) 透贴(A)", 2D) = "white" {}	  	
		
		_AmbientColor("环境光颜色", Color) = (0.92,0.92,0.92,1)
		_LightDirection("方向光朝向(XYZ) 方向光强度(W)",Vector) = (-16.8,78.8,-89.5,0.1)
		_DirLightColor("方向光颜色",Color) = (0.98,0.98,0.97,1)
		_SpecColor ("高光颜色", Color) = (1,1,1,1)
		_SpecLevel ("高光强度",Range( 0.0 , 10.0 )) = 2
		_SpecPower ("高光范围",Range( 0.1 , 1.0 )) = 0.5

		_RimColor ("边缘光颜色", Color) = (1,1,1,1)
		_RimLevel ("边缘光强度",Range( 0.0 , 1.0 )) = 0.5
		_RimPower ("边缘光范围",Range( 0.0 , 5.0 )) = 0.5

		_Cutoff ("透明范围",float) = 0.5
	}

	SubShader 
	{
	    Tags {"Queue" = "Transparent-500" "IgnoreProjector"="True" "RenderType" = "TransparentCutout" }
        LOD 300

		
	// ------------------------------------------------------------
	// Surface shader code generated out of a CGPROGRAM block:
	

	// ---- forward rendering base pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		ColorMask RGB

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile _ISUSEMC_DISABLE _ISUSEMC_ENABLE
#pragma debug
#pragma multi_compile_fwdbase nodirlightmap
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
// -------- variant for: _ISUSEMC_DISABLE 
#if defined(_ISUSEMC_DISABLE)
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 33 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		//#pragma surface surf BlinnPhong2D vertex:vert alphatest:_Cutoff noambient
		//#pragma multi_compile _ISUSEMC_DISABLE _ISUSEMC_ENABLE
		//#pragma debug
		fixed4 _Color;
		fixed _SpecLevel;
		fixed _SpecPower;
		fixed4 _RimColor;
		fixed4 _AmbientColor;
		half4 _LightDirection;
		fixed4 _DirLightColor;
		fixed _RimLevel;
		fixed _RimPower;

		sampler2D _MainTex;

		fixed _MatCapMulti;

		struct Input 
		{
			  float2 uv_MainTex;
			  float3 viewDir;

			  #ifdef _ISUSEMC_ENABLE
			  	float2 matcapUV;
			  #endif
		};

		inline fixed4 LightingBlinnPhong2D (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize (lightDir + viewDir);
				
			//Make less volume shading
			fixed diff = max (0.45, dot (s.Normal, lightDir));
	
			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular * 128) * s.Gloss;
	
			fixed4 c;
			c.rgb = (s.Albedo * (_DirLightColor.rgb*_LightDirection.w) * diff) * (atten * 0.9) + (_DirLightColor.rgb*_LightDirection.w * _SpecColor.rgb * spec) * (atten * 3)+_AmbientColor*s.Albedo;
			c.a = s.Alpha + _DirLightColor.a * _SpecColor.a * spec * atten;
			return c;
		}


		
		void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			#ifdef _ISUSEMC_ENABLE
				o.matcapUV = float2(dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal),dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal)) * 0.5 + 0.5;
			#endif
		}
		
		void surf (Input IN, inout SurfaceOutput o)
		{
            // Diffuse
			fixed4 diff = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = diff.rgb;
			// Cutoff
		  	o.Alpha = diff.a;

		 	// Specular
		 	o.Specular = _SpecPower;
		 	o.Gloss = _SpecLevel;

		  	// Fresnel 
		  	fixed rim = 1 - saturate(dot (normalize(IN.viewDir), o.Normal));
		  	o.Emission = pow(rim, _RimPower)  * _RimLevel * _RimColor;
		}
	

// vertex-to-fragment interpolation data
#ifdef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float3 viewDir : TEXCOORD1;
  fixed3 normal : TEXCOORD2;
  fixed3 vlight : TEXCOORD3;
  LIGHTING_COORDS(4,5)
};
#endif
#ifndef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float3 viewDir : TEXCOORD1;
  fixed3 normal : TEXCOORD2;
  float2 lmap : TEXCOORD3;
  LIGHTING_COORDS(4,5)
};
#endif
#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
#endif
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  Input customInputData;
  vert (v, customInputData);
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  #ifndef LIGHTMAP_OFF
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif
  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  o.normal = worldN;
  float3 viewDirForLight = WorldSpaceViewDir( v.vertex );
  o.viewDir = viewDirForLight;

  // SH/ambient and vertex lights
  #ifdef LIGHTMAP_OFF
  o.vlight = 0.0;
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
  surfIN.viewDir = IN.viewDir;
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

  // compute lighting & shadowing factor
  fixed atten = LIGHT_ATTENUATION(IN);
  fixed4 c = 0;

  // realtime lighting: call lighting function
  #ifdef LIGHTMAP_OFF
  c = LightingBlinnPhong2D (o, normalize(_LightDirection.xyz), normalize(half3(IN.viewDir)), atten);
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

  c.rgb += o.Emission;
  c.a = o.Alpha;
  return c;
}


#endif

// -------- variant for: _ISUSEMC_ENABLE 
#if defined(_ISUSEMC_ENABLE)
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 33 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		//#pragma surface surf BlinnPhong2D vertex:vert alphatest:_Cutoff noambient
		//#pragma multi_compile _ISUSEMC_DISABLE _ISUSEMC_ENABLE
		//#pragma debug
		fixed4 _Color;
		fixed _SpecLevel;
		fixed _SpecPower;
		fixed4 _RimColor;
		fixed4 _AmbientColor;
		half4 _LightDirection;
		fixed4 _DirLightColor;
		fixed _RimLevel;
		fixed _RimPower;

		sampler2D _MainTex;

		fixed _MatCapMulti;

		struct Input 
		{
			  float2 uv_MainTex;
			  float3 viewDir;

			  #ifdef _ISUSEMC_ENABLE
			  	float2 matcapUV;
			  #endif
		};

		inline fixed4 LightingBlinnPhong2D (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize (lightDir + viewDir);
				
			//Make less volume shading
			fixed diff = max (0.45, dot (s.Normal, lightDir));
	
			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular * 128) * s.Gloss;
	
			fixed4 c;
			c.rgb = (s.Albedo * (_DirLightColor.rgb*_LightDirection.w) * diff) * (atten * 0.9) + (_DirLightColor.rgb*_LightDirection.w * _SpecColor.rgb * spec) * (atten * 3)+_AmbientColor*s.Albedo;
			c.a = s.Alpha + _DirLightColor.a * _SpecColor.a * spec * atten;
			return c;
		}


		
		void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			#ifdef _ISUSEMC_ENABLE
				o.matcapUV = float2(dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal),dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal)) * 0.5 + 0.5;
			#endif
		}
		
		void surf (Input IN, inout SurfaceOutput o)
		{
            // Diffuse
			fixed4 diff = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = diff.rgb;
			// Cutoff
		  	o.Alpha = diff.a;

		 	// Specular
		 	o.Specular = _SpecPower;
		 	o.Gloss = _SpecLevel;

		  	// Fresnel 
		  	fixed rim = 1 - saturate(dot (normalize(IN.viewDir), o.Normal));
		  	o.Emission = pow(rim, _RimPower)  * _RimLevel * _RimColor;
		}
	

// vertex-to-fragment interpolation data
#ifdef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float3 viewDir : TEXCOORD1;
  float2 cust_matcapUV : TEXCOORD2;
  fixed3 normal : TEXCOORD3;
  fixed3 vlight : TEXCOORD4;
  LIGHTING_COORDS(5,6)
};
#endif
#ifndef LIGHTMAP_OFF
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0;
  float3 viewDir : TEXCOORD1;
  float2 cust_matcapUV : TEXCOORD2;
  fixed3 normal : TEXCOORD3;
  float2 lmap : TEXCOORD4;
  LIGHTING_COORDS(5,6)
};
#endif
#ifndef LIGHTMAP_OFF
// float4 unity_LightmapST;
#endif
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  Input customInputData;
  vert (v, customInputData);
  o.cust_matcapUV = customInputData.matcapUV;
  o.pos = UnityObjectToClipPos (v.vertex);
  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  #ifndef LIGHTMAP_OFF
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif
  float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
  o.normal = worldN;
  float3 viewDirForLight = WorldSpaceViewDir( v.vertex );
  o.viewDir = viewDirForLight;

  // SH/ambient and vertex lights
  #ifdef LIGHTMAP_OFF
  o.vlight = 0.0;
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
  surfIN.matcapUV = IN.cust_matcapUV;
  surfIN.viewDir = IN.viewDir;
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

  // compute lighting & shadowing factor
  fixed atten = LIGHT_ATTENUATION(IN);
  fixed4 c = 0;

  // realtime lighting: call lighting function
  #ifdef LIGHTMAP_OFF
  c = LightingBlinnPhong2D (o, normalize(_LightDirection.xyz), normalize(half3(IN.viewDir)), atten);
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

  c.rgb += o.Emission;
  c.a = o.Alpha;
  return c;
}


#endif


ENDCG

}


	// ---- end of surface shader generated code

#LINE 112

	}
Fallback "Transparent/Cutout/Diffuse"
}