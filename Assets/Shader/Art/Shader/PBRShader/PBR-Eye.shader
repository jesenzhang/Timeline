Shader "PBR - Eye"
{
	Properties
	{

////////////////////////////////////////////// 
///
///         Custom
///
//////////////////////////////////////////////		
		[Header(# # # # # # # # #    Custom)]
		[Space(8)]
		_MainTex("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)

        _BumpMap ("Normap", 2D) = "bump" {}
		_BumpScale("BumpScale", Range(0,1)) = 1.0
	
        _MetallicGlossMap("Metallic", 2D) = "white" {}
		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
		//[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		//[ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0
		_OcclusionMap("Occlusion", 2D) = "black" {}
		_OcclusionStrength("OcclusionStrength", Range(0.0, 1.0)) = 0.0

		_BloomFactor("BloomFactor", Range(0,1)) = 1

////////////////////////////////////////////// 
///
///         Eye
///
//////////////////////////////////////////////		
		[Header(# # # # # # # # #    Eye)]
     	[Toggle] _Eye_Enable("EyeEnable", Float) = 0.0
		
		_Eye_Color("IrisColor", Color) = (1,1,1,1)
		//[NoScaleOffset] _EyeBumpMap("IrisNormal", 2D) = "bump" {}
		//[NoScaleOffset] _EyeBumpMap2("CorniaNormal", 2D) = "bump" {}
		//[NoScaleOffset] _EyeMaps("Gloss Map", 2D) = "black" {}
     	//[Toggle] _Eye_RandomScale("EyeRandomScale", Float) = 0.0
		[HideInInspector] _Eye_IrisScale ("IrisScale", Range (.5, 1.5)) = 1.15
		//_Eye_Dilation ("DilationScale", Range (-.5, 2)) = 0.2
		_Eye_CubeMap ("EyeCubeMap", CUBE) = "" {}
     	[Toggle] _CubeMapDir_Enable("CubeMapDirEnable", Float) = 0.0
		_CubeMapDir ("CubeMapDir", Vector) = (0,0,0,1)
		[HideInInspector] _CubeMapDirMvp ("_CubeMapDirMvp", Float) = 0.0
     	[Toggle] _Eye_Specular_Enable("EyeSpecularEnable", Float) = 0.0
		_Eye_SpecStr ("SpecularStr", Range (0, 10)) = 0.75
		_Eye_SpecPower ("SpecularPower", Range (0, 100)) = 4
     	//[Toggle] _EyeLuminanceColor("EyeLuminanceColor", Float) = 0.0
     	//[Toggle] _EyeRefRotaion("EyeRefRotaion", Float) = 0.0

		


////////////////////////////////////////////// 
///
///         Unity
///
//////////////////////////////////////////////

		// Blending state
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque"  }
		LOD 300
		CGINCLUDE		

		#define _NORMAL_TYPE_NONE
		#define _BRDF_TYPE_GGX
		#define _METALLIC_TYPE_NONE
		#define _NORMAL_DIR_NONE

		//{ Channel
		#define _METALLICCHANNEL_R
		#define _SMOOTHNESSCHANNEL_A
		#define _SKINCHANNEL_ZERO


        #define _SSSTYPE_NONE 
		
		// { Eye Start
        #pragma shader_feature _ _CUBEMAPDIR_ENABLE_ON 
        #pragma shader_feature _ _EYE_ENABLE_ON 
        //#pragma shader_feature _ _EYELUMINANCECOLOR_ON 
        #define _EYELUMINANCECOLOR_ON 
        #pragma shader_feature _ _EYE_SPECULAR_ENABLE_ON 
        #pragma shader_feature _ _EYE_RANDOMSCALE_ON 
        #pragma shader_feature _ _EYEREFROTAION_ON 
        //#define _EYELUMINANCECOLOR_ON 
        //#define _EYE_SPECULAR_ENABLE_ON 
        //#define _EYE_RANDOMSCALE_ON 
        //#define _EYEREFROTAION_ON 
		// } Eye end
		
		
		#define UNITY_TANGENT_ORTHONORMALIZE 1
		#define _NORMALMAP 1
		#define UNITY_SETUP_BRDF_INPUT_CUSTOM MetallicSetupCustom
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup

		ENDCG

		Pass
		{
			Cull Off
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" }

			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------

			//#pragma shader_feature _NORMALMAP
			//#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			//#pragma shader_feature _EMISSION
			//#pragma shader_feature _METALLICGLOSSMAP
			//#pragma shader_feature ___ _DETAIL_MULX2
			//#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			//#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			//#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			
			#pragma vertex vertCustom
			#pragma fragment fragCustom
			#include "PBR.cginc"
		
			ENDCG
		}

		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)
		Pass
		{
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Fog { Color (0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------

			//#pragma shader_feature _NORMALMAP
			//#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			//#pragma shader_feature _METALLICGLOSSMAP
			//#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			//#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			//#pragma shader_feature ___ _DETAIL_MULX2
			//#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog

			#pragma vertex vertForwardAddCustom
			#pragma fragment fragForwardAddCustom
			#include "PBR.cginc"
			
			ENDCG
		}
		// ------------------------------------------------------------------
		//  Shadow rendering pass
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------


			//#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			//#pragma shader_feature _METALLICGLOSSMAP
			//#pragma shader_feature _PARALLAXMAP
			//#pragma multi_compile_shadowcaster
			//#pragma multi_compile_instancing

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
		
		// ------------------------------------------------------------------
		// Extracts information for lightmapping, GI (emission, albedo, ...)
		// This pass it not used during regular rendering.
		Pass
		{
			Name "META" 
			Tags { "LightMode"="Meta" }

			Cull Off

			CGPROGRAM
			#pragma vertex vert_meta
			#pragma fragment frag_meta

			//#pragma shader_feature _EMISSION
			//#pragma shader_feature _METALLICGLOSSMAP
			//#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			//#pragma shader_feature ___ _DETAIL_MULX2
			//#pragma shader_feature EDITOR_VISUALIZATION

			#include "UnityStandardMeta.cginc"
			ENDCG
		}


	}
	//CustomEditor "MobaStandardShaderGUI"
}
