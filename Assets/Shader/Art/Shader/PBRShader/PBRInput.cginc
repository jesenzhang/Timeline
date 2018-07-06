#ifndef PBRINPUT_CGINC
#define PBRINPUT_CGINC

#include "UnityLightingCommon.cginc"

#if !defined(_METALLICCHANNEL_USE)
    #if defined(_METALLICCHANNEL_R)
        #define _METALLICCHANNEL_USE r
    #elif defined(_METALLICCHANNEL_G)
        #define _METALLICCHANNEL_USE g
    #elif defined(_METALLICCHANNEL_B)
        #define _METALLICCHANNEL_USE b
    #elif defined(_METALLICCHANNEL_A)
        #define _METALLICCHANNEL_USE a
    #else
        #define _METALLICCHANNEL_USE r
    #endif
#endif

#if !defined(_SMOOTHNESSCHANNEL_USE)
    #if defined(_SMOOTHNESSCHANNEL_R)
        #define _SMOOTHNESSCHANNEL_USE r
    #elif defined(_SMOOTHNESSCHANNEL_G)
        #define _SMOOTHNESSCHANNEL_USE g
    #elif defined(_SMOOTHNESSCHANNEL_B)
        #define _SMOOTHNESSCHANNEL_USE b
    #elif defined(_SMOOTHNESSCHANNEL_A)
        #define _SMOOTHNESSCHANNEL_USE a
    #else
        #define _SMOOTHNESSCHANNEL_USE a
    #endif
#endif

#if !defined(_SKINCHANNEL_USE)
    #if defined(_SKINCHANNEL_R)
        #define _SKINCHANNEL_USE r
    #elif defined(_SKINCHANNEL_G)
        #define _SKINCHANNEL_USE g
    #elif defined(_SKINCHANNEL_B)
        #define _SKINCHANNEL_USE b
    #elif defined(_SKINCHANNEL_A)
        #define _SKINCHANNEL_USE a
    #endif
#endif

#if defined(_ENABLE_EMISSION_ON)
    #if !defined(_EMISSION)
        #define _EMISSION
    #endif
#elif defined(_ENABLE_EMISSION_OFF)
    #if defined(_EMISSION)
        #undef _EMISSION
    #endif
#endif

// { Custom SSS
#if defined(_ENABLE_SSSCUSTOM_ON)
    float4 _SSSCustomColor;
    half _SSSCustomSmoothness;
#endif
// }


struct BRDFInput
{
    half2 uv;
    half occlusion;
    float skinMask;
    half3 diffColor; 
    half3 specColor; 
    half oneMinusReflectivity;
    half metallic;
    half smoothness;
    half3 normalBase;
    half3 normal;
    half3 tangent; 
    half3 binormal; 
    half3 viewDir;
    UnityLight light; 
    UnityIndirect gi;
    float atten;
    half3 posWorld;
};


half _Smoothness;
//sampler2D _BumpMap;
//float _BumpMapScale;
float _AO_slider;
float _MetallicStrength;
float _SmoothnessStrength;

float _manul_metal;
float _manul_rough;

sampler2D _ansioMask;
fixed4 _ansioColor;
float _ansioNoiseOffset;
float _ansioNormalOffset;
float _anisoControlX;
float _anisoControlY;
float _anisoControlZ;
sampler2D   _tSpecShift;
float   _primaryShift;
float   _SpecularGloss2;

float _max_brightness;
float _eyeoffsetX = 1.0;
float _eyeoffsetY = 1.0;

half OcclusionCustom(float2 uv)
{
//#if (SHADER_TARGET < 30)
    // SM20: instruction count limitation
    // SM20: simpler occlusion
//    return tex2D(_OcclusionMap, uv).g;
//#else
    half occ = tex2D(_OcclusionMap, uv).g;
    return LerpOneTo (occ, _OcclusionStrength);
//#endif
}

//[KeywordEnum(None,Fresnel,ClosestPoint,Moba)]_SSSType("SSSType",Float) = 0
#if defined(_SSSTYPE_FRESNEL) || defined(_SSSTYPE_LUT_FRESNEL)  
    // sss fresnel
    //[Header(#Type Fresnel)]
    float3 _FresnelColor1;// = float3(1,0,0,1);
    float3 _FresnelColor2;// = float3(1,0,0,1);
    sampler2D _FresnelSSSMask;// = "white" {};
    float _FresnelValue = 0.41;
    float _FresnelScale = 0.41;
    float _FresnelPow = 0.41;
#endif

#if defined(_SSSTYPE_CLOSESTPOINT)
//[Header(#Type ClosestPoint)]
    fixed4  _ClosePointColor = fixed4(1,0,0,1);
    float _sssLerp = 1;
    float _sssfresnelLerp = 1;
    float _Light_Size = 0.104;
#endif
#if defined(_SSSTYPE_MOBA)
    //[Header(#Type Moba)]
    fixed4 _sssMobaColor = fixed4(1,0,0,1);
    float _sssIntensity = 0.8;
    float _sssTransmittance = 1;
    float _sssFrontintensity = 0.5;
    float _sssBackintensity =  0.17;
#endif

#if defined(_SSSTYPE_LUT) || defined(_SSSTYPE_LUT_FRESNEL)  
    sampler2D _SSSLUT;// = "white" {};
    #if defined(_SSSLUT_ENABLE_NORMALBLUR_ON)
        sampler2D _SSSLUTNormalBlur;// = "white" {};
        float _SSSLUTBumpBias;
    #endif
    float _SSSCurveFactor;
    float _LUTScale;

    #if defined(_SSSCALTYPE_TEX)
        sampler2D _CurveTex;
    #endif
    
#endif

#if defined(_DEBUG_NOV_ON)
float _debug_nv_value;
#endif
#if defined(_DEBUG_NOL_ON)
float _debug_nl_value;
#endif

float _BloomFactor;
sampler2D   _EnvironmentTex;
samplerCUBE _EnvironmentCube;


// Eye
//{
#if defined(_EYE_ENABLE_ON)
    half4       _Eye_Color;
    sampler2D   _Eye_BumpMap;
    sampler2D   _Eye_BumpMap2;
    sampler2D   _Eye_Maps;
    float       _Eye_IrisScale = 1.15;
    float       _Eye_Dilation = 0.2;
    float       _Eye_SpecStr = 0.75;
    float       _Eye_SpecPower = 65;

    #if defined(_EYE_SPECULAR_ENABLE_ON)
    samplerCUBE _Eye_CubeMap;
    #endif

    #if defined(_EYEREFROTAION_ON)
        float4x4 _Eye_RotationMVP;
    #endif
    #if defined(_CUBEMAPDIR_ENABLE_ON)
        float4x4 _CubeMapDirMvp;
        //float4 _CubeMapDir; 
    #endif

#endif
//} End 

// Detail
//{
#if defined(_D_DETAIL_ENABLE_ON)
// map
sampler2D _DetailMaps;

#if ! defined(_D_DETAIL_1_CHANNEL_OFF)
    float3 _Detail_1_Color;
    #if !defined(_D_DETAIL_1_CHANNEL_USE)
        #if defined(_D_DETAIL_1_CHANNEL_R)
            #define _D_DETAIL_1_CHANNEL_USE r
        #elif defined(_D_DETAIL_1_CHANNEL_G)
            #define _D_DETAIL_1_CHANNEL_USE g
        #elif defined(_D_DETAIL_1_CHANNEL_B)
            #define _D_DETAIL_1_CHANNEL_USE b
        #elif defined(_D_DETAIL_1_CHANNEL_A)
            #define _D_DETAIL_1_CHANNEL_USE a
        #endif
    #endif
    #if ! defined(_D_DETAIL_1_METALLIC_OFF)
        float _Detail_1_Metallic;
    #endif
    #if ! defined(_D_DETAIL_1_SMOOTHNESS_OFF)
        float _Detail_1_Smoothness;
    #endif
#endif

#if ! defined(_D_DETAIL_2_CHANNEL_OFF)
    float3 _Detail_2_Color;
    #if !defined(_D_DETAIL_2_CHANNEL_USE)
        #if defined(_D_DETAIL_2_CHANNEL_R)
            #define _D_DETAIL_2_CHANNEL_USE r
        #elif defined(_D_DETAIL_2_CHANNEL_G)
            #define _D_DETAIL_2_CHANNEL_USE g
        #elif defined(_D_DETAIL_2_CHANNEL_B)
            #define _D_DETAIL_2_CHANNEL_USE b
        #elif defined(_D_DETAIL_2_CHANNEL_A)
            #define _D_DETAIL_2_CHANNEL_USE a
        #endif
    #endif
    #if ! defined(_D_DETAIL_2_METALLIC_OFF)
        float _Detail_2_Metallic;
    #endif
    #if ! defined(_D_DETAIL_2_SMOOTHNESS_OFF)
        float _Detail_2_Smoothness;
    #endif
#endif

#endif
//} End 

#endif
