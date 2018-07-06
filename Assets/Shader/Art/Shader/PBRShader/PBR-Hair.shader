Shader "PBR - Hair"
{
	Properties
	{
////////////////////////////////////////////// 
///
///         Custom
///
//////////////////////////////////////////////		
        _BumpMap ("Normap", 2D) = "bump" {}
		[HideInInspector]_BumpScale("NormapScale", Float) = 1.0

		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}

		[HideInInspector]_MetallicGlossMap("Metallic", 2D) = "white" {}
		_Metallic("Metallic", Range(0.0, 1.0)) = 0
        _Glossiness("Glossiness", Range(0.0, 1.0)) = 0.5

		_OcclusionStrength("OcclusionStrength", Range(0.0, 1.0)) = 1.0
		_OcclusionMap("Occlusion", 2D) = "black" {}

////////////////////////////////////////////// 
///
///         Ansio
///
//////////////////////////////////////////////
		_ansioMask ("Aniso", 2D) = "grey" {}
		_ansioColor("SpecColor", Color) = (1,1,1,1)
		_ansioNoiseOffset("Aniso NoiseOffset", Float) = 0.41
		_ansioNormalOffset("Aniso NormalOffset", Float) = -0.05
		//_tSpecShift("SpecShift", 2D) = "white" {}
		//_primaryShift("PrimaryShift", Range(-10.0, 10.0)) = 0.4
		//_SpecularGloss1("SpecularExp", Range(0, 10.0)) = 15

		// Blending state
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
		LOD 300
		CGINCLUDE		
		
			#define _JUST_ONLY_ANSIO 1
			//#define UNITY_PBS_USE_BRDF1 1
			#define _DEBUG_RETURN_ON 1
			#define _METALLIC_TYPE_MANUL 1
			#define _BRDF_TYPE_CARTON 1
			#define _SSSTYPE_NONE 1
			#define _BRDF_TYPE_MOBA 1
			#define _NORMALMAP 1
			#define UNITY_TANGENT_ORTHONORMALIZE 1
			#define _NORMAL_TYPE_XNORMAL 1
			#define UNITY_SETUP_BRDF_INPUT_CUSTOM MetallicSetupCustom
			#define UNITY_SETUP_BRDF_INPUT MetallicSetup
			#define PASS_EYEOFFSET 1

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

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing
			
			//#pragma shader_feature _ENABLEDEBUGCOLOR_ON
			//#pragma vertex vertBase
			//#pragma fragment fragBase
			//#include "UnityStandardCoreForward.cginc"

			#pragma vertex vertCustom
			#pragma fragment fragCustom
			#include "PBR.cginc"
		
			ENDCG
		}
		/*
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

			#pragma vertex vertAddCustom
			#pragma fragment fragAddCustom
			#include "PBR.cginc"
		
			ENDCG
		}
		*/
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
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

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
			#pragma shader_feature EDITOR_VISUALIZATION

			#include "UnityStandardMeta.cginc"
			ENDCG
		}


	}
}
