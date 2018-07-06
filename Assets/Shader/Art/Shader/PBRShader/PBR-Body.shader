Shader "PBR - Body"
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
		_Color("Color", Color) = (1,1,1,1)


     	[Toggle] _Enable_Emission("EnableEmission", Float) = 0.0
     	_EmissionColor("EmissionColor", Color) = (0,0,0)
        _EmissionMap("EmissionMap", 2D) = "white" {}
        
		_BloomFactor("BloomFactor", Range(0,1)) = 1

     	[Toggle] _SecondLightEnable("SecondLightEnable", Float) = 0.0
        _SecondLightVector ("SecondLightVector", vector) = (0,0,0,1)

        [Toggle] _CubeMapEnable("CubeMap", Float) = 0.0
        _GI_CubeMap ("CubeMap", CUBE) = "" {}

////////////////////////////////////////////// 
///
///         SSS
///
//////////////////////////////////////////////
		[Header(# # # # # # # # #    SSS)]
		[Space(8)]

     	[Toggle] _Enable_SSSCustom("EnableSSSCustom", Float) = 0.0
		 _SSSCustomColor("CustomColor", Color) = (1,1,1,1)
		 _SSSCustomSmoothness("CustomSmoothness", Range(0,1)) = 1

        // LUT
        [Header(#Type LUT)]
       
        _SSSLUT("SSSLUT", 2D) = "white" {}
		[KeywordEnum(Off,Calu,Const,Tex)] _SSSCalType("CalType",Float) = 0
        _CurveTex ("CurveTex", 2D) = "white" {}
     	
        _SSSCurveFactor("CurveFactor",Range(0,1)) = 1
        _LUTScale("LUTScale",Range(1,2)) = 1
		//[Toggle] _SSSLUT_Enable_NormalBlur("EnableNormalBlur", Float) = 0.0
     	// Which mip-map to use when calculating curvature. Best to keep this between 1 and 2.
		//_SSSLUTBumpBias ("Normal Map Blur Bias", Range(-2,2)) = 1.5
        //_SSSLUTNormalBlur("_NormalBlur", 2D) = "white" {}
        // fresnel
		[Header(#Type Fresnel)]
     	[Toggle] _Enable_SSSFresnel("EnableSSSFresnel", Float) = 0.0
		_FresnelColor1("FresnelColor1", Color) = (1,1,1,1)
		_FresnelColor2("FresnelColor2", Color) = (1,1,1,1)
		_FresnelSSSMask("FresnelSSSMask", 2D) = "white" {}
		_FresnelValue("FresnelValue", Float) = 0.0
		_FresnelScale("FresnelScale", Float) = 0.2
		_FresnelPow("FresnelPow", Float) = 3
		
////////////////////////////////////////////// 
///
///         Detail
///
//////////////////////////////////////////////		
		[Header(# # # # # # # # #    Detail)]
		[Space(8)]
     	[Toggle] _D_Detail_Enable("DetailEnable", Float) = 0
		_DetailMaps("Detail Map", 2D) = "black" {}
		
		[Space(4)]
		//[KeywordEnum(Off,R,G,B,A)] 					_D_Detail_1_Channel		("Detail-1 Channel",			Float) = 0
		//[KeywordEnum(Off,TexAdd,TexMul,Add,Mul,Custom)] _D_Detail_1_Metallic	("Detail-1 Metallic - Type", 	Float) = 0
		_Detail_1_Metallic 													("Detail-1 Metallic", 			Float) = 1
		//[KeywordEnum(Off,TexAdd,TexMul,Add,Mul,Custom)] _D_Detail_1_Smoothness	("Detail-1 Smoothness - Type", 	Float) = 0
		_Detail_1_Smoothness 												("Detail-1 Smoothness", 		Float) = 1
		//[KeywordEnum(Off,Add,Mul)] 					_D_Detail_1_Color		("Detail-1 Type - Color",		Float) = 0
		_Detail_1_Color														("Detail-1 Color", 				Color) = (1,1,1,1)
		
		[Space(4)]
		//[KeywordEnum(Off,R,G,B,A,Custom)] 			_D_Detail_2_Channel		("Detail-2 Channel",			Float) = 0
		//[KeywordEnum(Off,TexAdd,TexMul,Add,Mul,Blend,Custom)] _D_Detail_2_Metallic	("Detail-2 Metallic - Type",	Float) = 0
		_Detail_2_Metallic 													("Detail-2 Metallic",			Float) = 1
		//[KeywordEnum(Off,TexAdd,TexMul,Add,Mul,Blend,Custom)] _D_Detail_2_Smoothness	("Detail-2 Smoothness - Type",	Float) = 0
		_Detail_2_Smoothness 												("Detail-2 Smoothness",			Float) = 1
		//[KeywordEnum(Off,Add,Mul)] 					_D_Detail_2_Color		("Detail-2 Type - Color",		Float) = 0
		_Detail_2_Color														("Detail-2 Color",				Color) = (1,1,1,1)
		////////////////////////////////////////////// 
///
///         Unity
///
//////////////////////////////////////////////
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		// Blending state
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
		
		[Header(# # # # # # # # #    Fabric)]
		[Toggle] _UseSilk("UseSilk", Float) = 0
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0
		[MaterialToggle] _IsAlembic("Is Alembic", Float) = 0

        [Enum(Silk, 0, CottonWool, 1)] _FabricType("Fabric Type", Float) = 0
        _FuzzTint("FuzzTint", Color) = (1.0, 1.0, 1.0)

        [MaterialToggle] _DoubleSided("Double Sided", Float) = 0
        [MaterialToggle] _BackFaceTextureSet("BackFaceTextureSet", Float) = 0
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

		// { Custom
		#pragma shader_feature _ENABLE_EMISSION_OFF _ENABLE_EMISSION_ON
		// }
		//{ Channel
		#define _METALLICCHANNEL_R
		#define _SMOOTHNESSCHANNEL_A
		#define _SKINCHANNEL_G
		#pragma shader_feature _SECONDLIGHTENABLE_OFF _SECONDLIGHTENABLE_ON
		#pragma shader_feature _ _CUBEMAPENABLE_ON
		
		// { SSS

		#pragma shader_feature _ _ENABLE_SSSCUSTOM_ON
		#define _SSSTYPE_LUT_FRESNEL 
		#pragma shader_feature _ _SSSCALTYPE_OFF _SSSCALTYPE_CALU _SSSCALTYPE_CONST _SSSCALTYPE_TEX
		#pragma shader_feature _ _ENABLE_SSSFRESNEL_ON


		// { Detail Start
		#pragma shader_feature _ _D_DETAIL_ENABLE_ON
		
		#define _D_DETAIL_1_CHANNEL_R 
		#define _D_DETAIL_2_CHANNEL_G 
		#define _D_DETAIL_1_METALLIC_ADD 
		#define _D_DETAIL_2_METALLIC_ADD 
		#define _D_DETAIL_1_SMOOTHNESS_ADD 
		#define _D_DETAIL_2_SMOOTHNESS_ADD 
		#define _D_DETAIL_1_COLOR_ADD 
		#define _D_DETAIL_2_COLOR_ADD 

		// } Detail end
		
		
		#define UNITY_TANGENT_ORTHONORMALIZE 1
		#define _NORMALMAP 1
		#define UNITY_SETUP_BRDF_INPUT_CUSTOM MetallicSetupCustom
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup

		ENDCG

		//UsePass "PBR/CommonPass/FORWARD"  
		//UsePass "PBR/CommonPass/FORWARD_DELTA"  
		//UsePass "PBR/CommonPass/SHADOWCASTER"
		//UsePass "PBR/CommonPass/DEFERRED"  
		//UsePass "PBR/CommonPass/META"
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
			
			#pragma shader_feature _FABRIC_SILK //Swap Fabric BRDFS
            #pragma shader_feature _DOUBLE_SIDED_FABRIC
            #pragma shader_feature _HAS_BACKFACE_TEXTURE_SET
			#pragma shader_feature _ _USESILK_ON
			#pragma shader_feature _ _ENABLE_CUBEMAP_ON
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
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Deferred pass
		/*Pass
		{
			Name "DEFERRED"
			Tags { "LightMode" = "Deferred" }

			CGPROGRAM
			#pragma target 3.0
			#pragma exclude_renderers nomrt


			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_prepassfinal
			#pragma multi_compile_instancing

			#pragma vertex vertDeferred
			#pragma fragment fragDeferred

			#include "UnityStandardCore.cginc"

			ENDCG
		}*/

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
	//CustomEditor "MobaStandardShaderGUI"
}
