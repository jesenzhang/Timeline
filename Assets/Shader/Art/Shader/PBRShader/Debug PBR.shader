Shader "Debug PBR"
{
	Properties
	{
////////////////////////////////////////////// 
///
///         Debug
///
//////////////////////////////////////////////
		[Header(# # # # # # # # #    Debug)]
		[Space(8)]

		// { type
		[KeywordEnum(None,xNormal)] 						_Normal_Type("Type - Normal", Float) = 0
		[KeywordEnum(None,SSSMap,Manul)]					_Metallic_Type("Type - Metallic", Float) = 0
		[KeywordEnum(None,back,forward)] 					_Normal_Dir("Type - NormalDir", Float) = 0
		//[KeywordEnum(Unity,Moba,ShenDu)] _BRDF_Type("Type - BRDF", Float) = 1
		[KeywordEnum(GGX,Legacy,Carton,Carton_Only,Real)] 	_BRDF_Type("Type - BRDF", Float) = 0
		//}
		//{ Channel
		[KeywordEnum(None,R,G,B,A,Custom)] 					_MetallicChannel("Channel - Metallic", Float) = 0
		[KeywordEnum(None,R,G,B,A,Custom)] 					_SmoothnessChannel("Channel - Smoothness", Float) = 0
		[KeywordEnum(Zero,One,R,G,B,A)] 					_SKinChannel("Channel - SKin",Float) = 0
		//}
		
		//{ Debug
		[Toggle] _Debug_Return ("Debug Enable", Int) = 0
		[KeywordEnum(None,Albedo,Metallic,Smoothness,Diffuse,Specular,SkinMask,CubeMap)] _D_Tex("Debug - Texture",Float) = 0
		[KeywordEnum(None,Mask,OnlySkin,Diff,Final)] _Check_SSS("Debug - SSS",Float) = 0
		[KeywordEnum(None,NormalWorld,TangentWorld,BinormalWorld,NormalTexture)] _Debug_Normal("Debug - Normal",Float) = 0

		// Debug BRDF Moudle
		[KeywordEnum(None,D,F,V)] _D_BRDF("Debug - DFV",Float) = 0
		[KeywordEnum(None,Color,Term,Final)] _D_BRDF_Diffuse("Debug - Diffuse",Float) = 0
		[KeywordEnum(None,Color,Final)] _D_BRDF_Specular("Debug - Specular",Float) = 0
		[KeywordEnum(None,Diffuse,Specular,Final)] _D_BRDF_GI("Debug - GI",Float) = 0
		[KeywordEnum(None,Color,Fesnel,FesnelColor,LUTDiff,Final)] _D_SSS("Debug - Fesnel",Float) = 0
		//[Toggle] _Debug_Alapha ("Debug - Alapha", Int) = 0

		// debug final
        [Toggle] _Debug_Enable_Final_Diffuse("Debug - FinalDiffuse", Float) = 0.0
        [Toggle] _Debug_Enable_Final_Specular("Debug - FinalSpecular", Float) = 0.0
        [Toggle] _Debug_Enable_Final_GI("Debug - FinalGI", Float) = 0.0
		
		/*[Space(8)]
		// debug light
        [Toggle] _Debug_Force_NV_Light("Debug - ForceNVLight", Float) = 0.0
        [Toggle] _Debug_NoV("Debug - NoV", Float) = 0.0
        _debug_nv_value("Debug - NoV",  Range(-1,1)) = 0.0
     	[Toggle] _Debug_Print_NV("Debug - Print-NV", Float) = 0.0

		[Space(8)]
        [Toggle] _Debug_Force_NL_Light("Debug - ForceNLLight", Float) = 0.0
     	[Toggle] _Debug_NoL("Debug - NoL", Float) = 0.0
        _debug_nl_value("Debug - NoL",  Range(-1,1)) = 0.0
     	[Toggle] _Debug_Print_NL("Debug - Print-NL", Float) = 0.0
		//}*/

        [Toggle] _SecondLightEnable("SecondLightEnable", Float) = 0.0
		_SecondLight ("_SecondLight", vector) = (0,0,0,1)


		

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
///         Eye
///
//////////////////////////////////////////////		
		[Header(# # # # # # # # #    Eye)]
     	[Toggle] _Eye_Enable("EyeEnable", Float) = 0.0
		
		_Eye_Color("IrisColor", Color) = (1,1,1,1)
		[NoScaleOffset] _EyeBumpMap("IrisNormal", 2D) = "bump" {}
		[NoScaleOffset] _EyeBumpMap2("CorniaNormal", 2D) = "bump" {}
		[NoScaleOffset] _EyeMaps("Gloss Map", 2D) = "black" {}
     	[Toggle] _Eye_RandomScale("EyeRandomScale", Float) = 0.0
		_Eye_IrisScale ("IrisScale", Range (.5, 1.5)) = 1.15
		_Eye_Dilation ("DilationScale", Range (-.5, 2)) = 1
		_Eye_CubeMap ("EyeCubeMap", CUBE) = "" {}
		[Toggle] _CubeMapDir_Enable("CubeMapDirEnable", Float) = 0.0
		_CubeMapDir ("CubeMapDir", Vector) = (0,0,0,1)
		[HideInInspector] _CubeMapDirMvp ("_CubeMapDirMvp", Float) = 0.0
     	[Toggle] _Eye_Specular_Enable("EyeSpecularEnable", Float) = 0.0
		_Eye_SpecStr ("SpecStr", Range (0, 10)) = 0.75
		_Eye_SpecPower ("SpecPower", Range (0, 1024)) = 65
     	[Toggle] _EyeLuminanceColor("EyeLuminanceColor", Float) = 0.0
     	[Toggle] _EyeRefRotaion("EyeRefRotaion", Float) = 0.0


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

		//_MetallicStrength("Metallic Strength", Range(0.0, 1.0)) = 1.0
		//_SmoothnessStrength("Smoothness Strength", Range(0.0, 1.0)) = 1.0
		//_manul_metal ("ManulMetal", Range(0,1)) = 0.0
		//_manul_rough ("ManulRough", Range(0,1)) = 0.0
	
        _MetallicGlossMap("Metallic", 2D) = "white" {}
        [Gamma]  _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0
		_OcclusionMap("Occlusion", 2D) = "black" {}
		_OcclusionStrength("OcclusionStrength", Range(0.0, 1.0)) = 0.0

	  	//_EnvironmentTex ("EnvironmentTex", 2D) = "white" {} 
	  	//_EnvironmentCube ("EnvironmentCube", CUBE) = "" {}  // 立方环境贴图
		//[Toggle] _Enable_Environment ("EnableEnvironment", Int) = 0
		//_max_brightness ("MaxBrightness", float) = 130

		_BloomFactor("BloomFactor", Range(0,1)) = 1


		[Toggle] _SecondLightEnable("SecondLightEnable", Float) = 0.0
        _SecondLightVector ("SecondLightVector", vector) = (0,0,0,1)

		[Toggle] _Enable_CubeMap("EnableCubeMap", Float) = 0.0
		_GI_CubeMap ("CubeMap", CUBE) = "" {}
////////////////////////////////////////////// 
///
///         SSS
///
//////////////////////////////////////////////
		[Header(# # # # # # # # #    SSS)]
		[Space(8)]

		[KeywordEnum(None,LUT,LUT_Fresnel,Fresnel,ClosestPoint,Moba)] _SSSType("SSSType",Float) = 0

        // LUT
        [Header(#Type LUT)]
        _SSSLUT("SSSLUT", 2D) = "white" {}
		[KeywordEnum(Off,Calu,Const,Tex)] _SSSCalType("CalType",Float) = 0
        _CurveTex ("CurveTex", 2D) = "white" {}
     	
        _SSSCurveFactor("CurveFactor",Range(0,1)) = 1
        _LUTScale("LUTScale",Range(1,2)) = 1
		[Toggle] _SSSLUT_Enable_NormalBlur("EnableNormalBlur", Float) = 0.0
     	// Which mip-map to use when calculating curvature. Best to keep this between 1 and 2.
		_SSSLUTBumpBias ("Normal Map Blur Bias", Range(0,5)) = 2
        _SSSLUTNormalBlur("_NormalBlur", 2D) = "white" {}
        // fresnel
		[Header(#Type Fresnel)]
     	[Toggle] _Enable_SSSFresnel("EnableSSSFresnel", Float) = 0.0
		_FresnelColor1("FresnelColor1", Color) = (1,1,1,1)
		_FresnelColor2("FresnelColor2", Color) = (1,1,1,1)
		_FresnelSSSMask("FresnelSSSMask", 2D) = "white" {}
		_FresnelValue("FresnelValue", Float) = 0.0
		_FresnelScale("FresnelScale", Float) = 0.2
		_FresnelPow("FresnelPow", Float) = 3

        // ClosestPoint
		[Header(#Type ClosestPoint)]
		_ClosePointColor("ClosePointColor", Color) = (1,1,1,1)
		_sssLerp("SSSLerp", Range(0.0, 1.0)) = 1
		_sssfresnelLerp("SSSfresnelLerp", Range(0.0, 1.0)) = 1
		_Light_Size("LightSize", Range(0.0, 1.0)) = 1

        // Moba
		[Header(#Type Moba)]
		_sssMobaColor("SSSMobaColor", Color) = (1,1,1,1)
		_sssIntensity ("Intensity",  Range(0.0, 1.0)) = 0.8
		_sssTransmittance ("Transmittance", Range(0.0, 1.0)) = 1
		_sssFrontintensity ("Frontintensity", Range(-10, 10.0)) = 0.5
		_sssBackintensity ("Backintensity", Range(-10, 10.0)) =  0.17
		
////////////////////////////////////////////// 
///
///         Ansio
///
//////////////////////////////////////////////
		[Header(# # # # # # # # #    Ansio)]
		[Space(8)]

		_ansioMask ("Aniso", 2D) = "white" {}
		_ansioColor("Color", Color) = (1,1,1)
		_eyeoffsetX ("EyeOffsetX", Float) = 1.0
		_eyeoffsetY ("EyeOffsetY", Float) = 1.0
		_ansioNoiseOffset("NoiseOffset", Float) = 0.41
		_ansioNormalOffset("NormalOffset", Float) = -0.05
		_anisoControlX("ControlX", Range(-10.0, 10.0)) = 0.4
		_anisoControlY("ControlY", Range(-10.0, 10.0)) = 1
		_anisoControlZ("ControlZ", Range(-10.0, 10.0)) = 1
 
		_tSpecShift("tSpecShift", 2D) = "white" {}
		_primaryShift("primaryShift", Range(-10.0, 10.0)) = 1
		_SpecularGloss1("SpecularGloss1", Range(0, 10.0)) = 1

////////////////////////////////////////////// 
///
///         Unity
///
//////////////////////////////////////////////
		[Header(# # # # # # # # #   Unity)]
		[Space(8)]

		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		[Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

		_Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
		_ParallaxMap ("Height Map", 2D) = "black" {}

		_EmissionColor("Color", Color) = (0,0,0)
		_EmissionMap("Emission", 2D) = "white" {}
		
		_DetailMask("Detail Mask", 2D) = "grey" {}
		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale("Normal Map Scale", Float) = 1.0
		_DetailNormalMap("Normal Map", 2D) = "bump" {}

		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0

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
		

		//{ type
		#pragma shader_feature _NORMAL_TYPE_NONE _NORMAL_TYPE_XNORMAL
		#pragma shader_feature _BRDF_TYPE_GGX _BRDF_TYPE_LEGACY _BRDF_TYPE_CARTON _BRDF_TYPE_CARTON_ONLY _BRDF_TYPE_REAL
		#pragma shader_feature _METALLIC_TYPE_NONE _METALLIC_TYPE_SSSMAP _METALLIC_TYPE_MANUL
		#pragma shader_feature _NORMAL_DIR_NONE _NORMAL_DIR_FORWARD  _NORMAL_DIR_BACK

		//} type 
		//{ Channel
		#pragma shader_feature _ _METALLICCHANNEL_NONE _METALLICCHANNEL_R _METALLICCHANNEL_G _METALLICCHANNEL_B _METALLICCHANNEL_A _METALLICCHANNEL_CUSTOM
		#pragma shader_feature _ _SMOOTHNESSCHANNEL_NONE _SMOOTHNESSCHANNEL_R _SMOOTHNESSCHANNEL_G _SMOOTHNESSCHANNEL_B _SMOOTHNESSCHANNEL_A _SMOOTHNESSCHANNEL_CUSTOM
		#pragma shader_feature _ _SKINCHANNEL_ZERO _SKINCHANNEL_ONE _SKINCHANNEL_R _SKINCHANNEL_G _SKINCHANNEL_B _SKINCHANNEL_A
		//} Channel

		//{ Debug
		#pragma shader_feature _DEBUG_RETURN_ON
		#pragma shader_feature _D_TEX_NONE _D_TEX_ALBEDO _D_TEX_METALLIC _D_TEX_SMOOTHNESS _D_TEX_DIFFUSE _D_TEX_SPECULAR _D_TEX_SKINMASK _D_TEX_CUBEMAP
		#pragma shader_feature _CHECK_SSS_NONE _CHECK_SSS_DIFF  _CHECK_SSS_ONLYSKIN _CHECK_SSS_MASK _CHECK_SSS_FINAL
		#pragma shader_feature _DEBUG_NORMAL_NONE _DEBUG_NORMAL_NORMALWORLD _DEBUG_NORMAL_TANGENTWORLD _DEBUG_NORMAL_BINORMALWORLD _DEBUG_NORMAL_NORMALTEXTURE
		#pragma shader_feature _ _D_BRDF_D _D_BRDF_F _D_BRDF_V
		#pragma shader_feature _ _D_BRDF_DIFFUSE_COLOR _D_BRDF_DIFFUSE_TERM _D_BRDF_DIFFUSE_FINAL
		#pragma shader_feature _ _D_BRDF_SPECULAR_COLOR _D_BRDF_SPECULAR_FINAL
		#pragma shader_feature _ _D_BRDF_GI_DIFFUSE _D_BRDF_GI_SPECULAR _D_BRDF_GI_FINAL
		#pragma shader_feature _ _D_SSS_COLOR _D_SSS_FESNEL _D_SSS_FESNELCOLOR _D_SSS_LUTDIFF _D_SSS_FINAL
		#pragma shader_feature _DEBUG_ALAPHA_ON 
		
		// debug final
        #pragma shader_feature _DEBUG_ENABLE_FINAL_DIFFUSE_ON 
        #pragma shader_feature _DEBUG_ENABLE_FINAL_SPECULAR_ON 
        #pragma shader_feature _DEBUG_ENABLE_FINAL_GI_ON 

        
		// debug light
		//#pragma shader_feature _DEBUG_FORCE_NV_LIGHT_ON 
		//#pragma shader_feature _DEBUG_NOV_ON 
		//#pragma shader_feature _DEBUG_NOL_ON 
		//#pragma shader_feature _DEBUG_PRINT_NV_ON 
		//#pragma shader_feature _DEBUG_PRINT_NL_ON
		//#pragma shader_feature _DEBUG_FORCE_NL_LIGHT_ON 

		//} Debug

		#pragma shader_feature _ _ENABLE_CUBEMAP_ON
		
		// Second Light
		#pragma shader_feature _ _SECONDLIGHTENABLE_ON


		// { SSS
		#pragma shader_feature _ _SSSTYPE_NONE _SSSTYPE_LUT _SSSTYPE_FRESNEL _SSSTYPE_LUT_FRESNEL _SSSTYPE_CLOSESTPOINT _SSSTYPE_MOBA
		#pragma shader_feature _ _SSSCALTYPE_OFF _SSSCALTYPE_CALU _SSSCALTYPE_CONST _SSSCALTYPE_TEX
        #pragma shader_feature _SSSLUT_ENABLE_NORMALBLUR_ON 
        #pragma shader_feature _ENABLE_SSSFRESNEL_ON 
		// }


		#pragma shader_feature _ENABLE_ENVIRONMENT_ON
		

		#pragma shader_feature _ANSIO_TYPE_GGX _ANSIO_TYPE_CARTON _ANSIO_TYPE_CARTON_ONLY _ANSIO_TYPE_REAL
		


		// { Eye Start
        #pragma shader_feature _ _CUBEMAPDIR_ENABLE_ON 
        #pragma shader_feature _ _EYE_ENABLE_ON 
        #pragma shader_feature _ _EYELUMINANCECOLOR_ON 
        #pragma shader_feature _ _EYE_SPECULAR_ENABLE_ON 
        #pragma shader_feature _ _EYE_RANDOMSCALE_ON 
        #pragma shader_feature _ _EYEREFROTAION_ON 
		// } Eye end
		

		// { Detail Start
		//#pragma shader_feature _ _D_DETAIL_ENABLE_ON
		//#pragma shader_feature _ _D_DETAIL_1_CHANNEL_OFF 	_D_DETAIL_1_CHANNEL_R 		_D_DETAIL_1_CHANNEL_G 		_D_DETAIL_1_CHANNEL_B 			_D_DETAIL_1_CHANNEL_A 
		//#pragma shader_feature _ _D_DETAIL_2_CHANNEL_OFF 	_D_DETAIL_2_CHANNEL_R 		_D_DETAIL_2_CHANNEL_G 		_D_DETAIL_2_CHANNEL_B 			_D_DETAIL_2_CHANNEL_A 
		//#pragma shader_feature _ _D_DETAIL_1_METALLIC_OFF 	_D_DETAIL_1_METALLIC_TEXADD	_D_DETAIL_1_METALLIC_TEXMUL	_D_DETAIL_1_METALLIC_ADD 	_D_DETAIL_1_METALLIC_MUL 	_D_DETAIL_1_METALLIC_BLEND 		_D_DETAIL_1_METALLIC_CUSTOM
		//#pragma shader_feature _ _D_DETAIL_2_METALLIC_OFF	_D_DETAIL_2_METALLIC_TEXADD _D_DETAIL_2_METALLIC_MUL	_D_DETAIL_2_METALLIC_ADD 	_D_DETAIL_2_METALLIC_MUL 	_D_DETAIL_2_METALLIC_BLEND 		_D_DETAIL_2_METALLIC_CUSTOM
		//#pragma shader_feature _ _D_DETAIL_1_SMOOTHNESS_OFF _D_DETAIL_1_SMOOTHNESS_TXEADD _D_DETAIL_1_SMOOTHNESS_TEXMUL	_D_DETAIL_1_SMOOTHNESS_ADD 	_D_DETAIL_1_SMOOTHNESS_MUL 	_D_DETAIL_1_SMOOTHNESS_BLEND 	_D_DETAIL_1_SMOOTHNESS_CUSTOM
		//#pragma shader_feature _ _D_DETAIL_2_SMOOTHNESS_OFF _D_DETAIL_2_SMOOTHNESS_TEXADD _D_DETAIL_2_SMOOTHNESS_TEXMUL	_D_DETAIL_2_SMOOTHNESS_ADD 	_D_DETAIL_2_SMOOTHNESS_MUL 	_D_DETAIL_2_SMOOTHNESS_BLEND 	_D_DETAIL_2_SMOOTHNESS_CUSTOM
		//#pragma shader_feature _ _D_DETAIL_1_COLOR_OFF 		_D_DETAIL_1_COLOR_ADD 		_D_DETAIL_1_COLOR_MUL
		//#pragma shader_feature _ _D_DETAIL_2_COLOR_OFF 		_D_DETAIL_2_COLOR_ADD 		_D_DETAIL_2_COLOR_MUL
		
		#define _D_DETAIL_1_CHANNEL_R 1
		#define _D_DETAIL_2_CHANNEL_G 1
		#define _D_DETAIL_1_METALLIC_ADD 1
		#define _D_DETAIL_2_METALLIC_ADD 1
		#define _D_DETAIL_1_SMOOTHNESS_ADD 1
		#define _D_DETAIL_2_SMOOTHNESS_ADD 1
		#define _D_DETAIL_1_COLOR_ADD 1
		#define _D_DETAIL_2_COLOR_ADD 1

		// } Detail end
		
		

		#define UNITY_TANGENT_ORTHONORMALIZE 1
		#define _NORMALMAP 1
		#define UNITY_SETUP_BRDF_INPUT_CUSTOM MetallicSetupCustom
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup
			//#pragma _PARALLAXMAP 1

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
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Deferred pass
		Pass
		{
			Name "DEFERRED"
			Tags { "LightMode" = "Deferred" }

			CGPROGRAM
			#pragma target 3.0
			#pragma exclude_renderers nomrt


			// -------------------------------------

			//#pragma shader_feature _NORMALMAP
			//#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			//#pragma shader_feature _EMISSION
			//#pragma shader_feature _METALLICGLOSSMAP
			//#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			//#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			//#pragma shader_feature ___ _DETAIL_MULX2
			//#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_prepassfinal
			#pragma multi_compile_instancing

			#pragma vertex vertDeferred
			#pragma fragment fragDeferred

			#include "UnityStandardCore.cginc"

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
