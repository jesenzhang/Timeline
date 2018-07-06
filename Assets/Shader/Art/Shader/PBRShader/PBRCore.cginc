// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

#ifndef PBRCORE_CGINC
#define PBRCORE_CGINC

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityStandardInput.cginc"
#include "UnityPBSLighting.cginc"
#include "UnityStandardUtils.cginc"
#include "UnityGBuffer.cginc"
#include "UnityStandardBRDF.cginc"
#include "UnityStandardBRDFDouble.cginc"
#include "AutoLight.cginc"
#include "UnityStandardCore.cginc"
#include "Fabric.cginc"

struct FragmentCommonDataCustom
{
    half3 diffColor;
    half3 specColor;
    half oneMinusReflectivity;
    half smoothness;
    half metallic;
    half3 normalWorld; 
    half3 normalWorldBase; 
    half3 tangentWorld;
    half3 binormalWorld;
    half3 xnormal;
    half3 eyeVec;
    half3 posWorld;
    half alpha;

    float skinMask;
    half occlusion;
    half2 uv;
    #if defined(_D_TEX_ALBEDO)
    half3 albedo;
    #endif

#if UNITY_STANDARD_SIMPLE
    half3 reflUVW;
#endif

#if UNITY_STANDARD_SIMPLE
    half3 tangentSpaceNormal;
#endif
};

half3 GetAlbedo(float4 texcoords)
{
    half3 albedo = _Color.rgb * tex2D (_MainTex, texcoords.xy).rgb;
    return albedo;
}

// metallic越高 返回值越低
// metallic等于1，返回0
// metallic等于0，返回介质的alpha
inline half GetOneMinusReflectivity(half metallic)
{
   return unity_ColorSpaceDielectricSpec.a - unity_ColorSpaceDielectricSpec.a * metallic;
}

half3 GetSpecularColor2(half3 albedo, half metallic)
{
    half3 specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);
    return specColor;
}

half2 MetallicGlossCustom(float2 uv)
{
    half2 mg;
    mg.r = _Metallic;
    mg.g = _Glossiness;
    //mg.r = 0.5f;
    //mg.g = 0.5f;
    return mg;
}

inline FragmentCommonDataCustom MetallicSetupCustom (float4 i_tex)
{
    float skinMask = 0;
    //float occlusion = 0;

float metallic;
half smoothness;

#if defined(_METALLIC_TYPE_NONE)
    half4 metallicGloss =  tex2D(_MetallicGlossMap, i_tex.xy);
    metallic = metallicGloss.r;
    smoothness = metallicGloss.a; // this is 1 minus the square root of real roughness m.
    smoothness *= _GlossMapScale;
    
    #if defined(_SKINCHANNEL_USE)
        skinMask = metallicGloss._SKINCHANNEL_USE;
    #endif

#elif defined(_METALLIC_TYPE_SSSMAP)

    fixed4 metallicGloss = tex2D (_MetallicGlossMap, i_tex.xy);
    metallic = pow(metallicGloss.x, 2.2);
    skinMask = metallicGloss.y;
    //occlusion = LerpOneTo (metallicGloss.y, _OcclusionStrength);
    //[-1, 1] * 0.5 + 0.5  = [ 0, 1]  
    //[ 0, 1] * 2 -1       = [-1, 1]  
    //[0 , 1] * 0.5
    smoothness = pow(metallicGloss.z, 2.2);// * 0.5;//+ _Glossiness;

    smoothness = smoothness * 0.5 + 0.5;
    //smoothness =_Glossiness;
    //smoothness = _DebugAlapha(smoothness);
    //metallic = _DebugAlapha(metallic);
#elif defined(_METALLIC_TYPE_MANUL)
    metallic = _Metallic;
    smoothness = _Glossiness; // this is 1 minus the square root of real roughness m.
#endif

#if defined(_SMOOTHNESSCHANNEL_CUSTOM)
    smoothness = _Glossiness;
#endif

#if defined(_METALLICCHANNEL_CUSTOM)
    metallic = _Metallic;
#endif

#if defined(_SKINCHANNEL_ONE)
    skinMask = 1;
#elif defined(_SKINCHANNEL_ZERO)
    skinMask = 0;
#endif

 
    half3 colorMain = _Color.rgb;
// { Detail
#if defined(_D_DETAIL_ENABLE_ON) 
    half4 detailMap =  tex2D(_DetailMaps, i_tex.xy);

    #if defined(_D_DETAIL_1_CHANNEL_USE)
        // Detail Metallic
        #if defined(_D_DETAIL_1_METALLIC_ADD)
            metallic += detailMap._D_DETAIL_1_CHANNEL_USE * _Detail_1_Metallic;
        #endif
        // Detail Smoothness
        #if defined(_D_DETAIL_1_SMOOTHNESS_ADD)
            smoothness += detailMap._D_DETAIL_1_CHANNEL_USE * _Detail_1_Smoothness;
        #endif

        // Detail color 1
        #if defined(_D_DETAIL_1_COLOR_ADD)
            colorMain += detailMap._D_DETAIL_1_CHANNEL_USE * _Detail_1_Color;;
        #endif
    #endif

    #if defined(_D_DETAIL_2_CHANNEL_USE)
        // Detail Metallic
        #if defined(_D_DETAIL_2_METALLIC_ADD)
            metallic += detailMap._D_DETAIL_2_CHANNEL_USE * _Detail_2_Metallic;
        #endif
        // Detail Smoothness
        #if defined(_D_DETAIL_2_SMOOTHNESS_ADD)
            smoothness += detailMap._D_DETAIL_2_CHANNEL_USE * _Detail_2_Smoothness;
        #endif

        // Detail color 2
        #if defined(_D_DETAIL_2_COLOR_ADD)
            colorMain += detailMap._D_DETAIL_2_CHANNEL_USE * _Detail_2_Color;;
        #endif
    #endif
   
#endif
// }

    half4 mainTex = tex2D (_MainTex, i_tex.xy);
    half3 albedo = mainTex.rgb * colorMain;

// { Custom SSS
#if defined(_ENABLE_SSSCUSTOM_ON)
    // SSS Color
    #if defined(_SKINCHANNEL_ONE)
       albedo *= _SSSCustomColor;
    #endif
    #if defined(_SKINCHANNEL_USE)
        albedo = lerp(albedo, albedo * _SSSCustomColor.rgb *_SSSCustomColor.a, skinMask);
    #endif   
    smoothness = lerp(smoothness, smoothness * _SSSCustomSmoothness, skinMask);
#endif
// }

    half oneMinusReflectivity;
    half3 specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, albedo, metallic);
    oneMinusReflectivity = lerp(unity_ColorSpaceDielectricSpec.a, 0, metallic);
    //oneMinusReflectivity = OneMinusReflectivityFromMetallic(metallic);
    half3 diffColor = albedo * oneMinusReflectivity;

#if defined(_EYE_ENABLE_ON)
    diffColor.rgb *= (_Eye_Color * mainTex.a) + (1- mainTex.a);
#endif

    FragmentCommonDataCustom o = (FragmentCommonDataCustom)0;
    o.oneMinusReflectivity = oneMinusReflectivity;
    o.diffColor = diffColor;
    o.specColor = specColor;
    o.smoothness = smoothness;
    o.metallic = metallic;
    o.skinMask = skinMask;
    o.uv = i_tex;
#if defined(_D_TEX_ALBEDO)
    o.albedo = albedo;
#endif


    return o;
}

half3 UnpackScaleNormalRGorAGCustom(half4 packednormal, half bumpScale)
{
    #if defined(UNITY_NO_DXT5nm1)
        half3 normal = packednormal.xyz * 2 - 1;
        #if (SHADER_TARGET >= 30)
            // SM2.0: instruction count limitation
            // SM2.0: normal scaler is not supported
            normal.xy *= bumpScale;
        #endif
        return normal;
    #else
        // This do the trick
        packednormal.x *= packednormal.w;

        half3 normal;
        normal.xy = (packednormal.xy * 2 - 1);
        #if (SHADER_TARGET >= 30)
            // SM2.0: instruction count limitation
            // SM2.0: normal scaler is not supported
            normal.xy *= bumpScale;
        #endif
        normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
        return normal;
    #endif
}

half3 PerPixelWorldNormalCustom(float4 i_tex, half4 tangentToWorld[3], out half3 outNormalWorldBase, out half3 outNormal, out half3 outTangent, out half3 outBinormal, out half occlusion)
{
    #ifdef _NORMALMAP 

        half3 tangent = tangentToWorld[0].xyz;
        half3 binormal = tangentToWorld[1].xyz;
        half3 normal = tangentToWorld[2].xyz;
        #if UNITY_TANGENT_ORTHONORMALIZE 
            normal = NormalizePerPixelNormal(normal);

            // ortho-normalize Tangent
            tangent = normalize (tangent - normal * dot(tangent, normal));

            // recalculate Binormal
            half3 newB = cross(normal, tangent);
            binormal = newB * sign (dot (newB, binormal));
        #endif


        #if !defined(_SSSTYPE_NONE) && defined(_SSSLUT_ENABLE_NORMALBLUR_ON) 
            half4 tex = tex2Dbias (_SSSLUTNormalBlur, float4 (i_tex.xy, 0.0, _SSSLUTBumpBias));
        #else
            half4 tex = tex2D (_BumpMap, i_tex.xy);
        #endif


        #if XNORMAL_OCCLUSION
            occlusion = LerpOneTo (tex.z, _OcclusionStrength);
        #else
            occlusion = OcclusionCustom(i_tex.xy);
        #endif
        half3 normalTangent = UnpackScaleNormal(tex, _BumpScale);

        //half3 normalTangent = NormalInTangentSpace(i_tex);
        //half3 normalTangent = tex2D (_BumpMap, i_tex.xy).xyz;
        //normalTangent.xy = (normalTangent.xy * 2 - 1) ;
        //normalTangent.z = sqrt(1.0 - saturate(dot(normalTangent.xy, normalTangent.xy)));
        #if defined(_NORMAL_TYPE_XNORMAL)  && !defined(PASS_EYEOFFSET)
                half3 normalWorld = NormalizePerPixelNormal(
                normalTangent.x * tangent * _eyeoffsetX + 
                normalTangent.y * binormal * _eyeoffsetY + 
                normalTangent.z * normal); // @TODO: see if we can squeeze this normalize on SM2.0 as well
        #else
            half3 normalWorld = NormalizePerPixelNormal(
                tangent * normalTangent.x + 
                binormal * normalTangent.y + 
                normal * normalTangent.z); // @TODO: see if we can squeeze this normalize on SM2.0 as well
        #endif

        outNormalWorldBase = normal;
        outNormal = normalWorld;
        outBinormal = binormal;
        outTangent = tangent;

    #else
        outNormalWorldBase = 0;
        outNormal = 0;
        outBinormal = 0;
        outTangent = 0;
        half3 normalWorld = normalize(tangentToWorld[2].xyz);
    #endif

    return normalWorld;
}

inline FragmentCommonDataCustom FragmentSetupCustom (inout float4 i_tex, half3 i_eyeVec, half3 i_viewDirForParallax, half4 tangentToWorld[3], half3 i_posWorld)
{
    i_tex = Parallax(i_tex, i_viewDirForParallax);

    half alpha = Alpha(i_tex.xy);
    #if defined(_ALPHATEST_ON)
        clip (alpha - _Cutoff);
    #endif
    float occlusion;
    //FragmentCommonDataCustom o = UNITY_SETUP_BRDF_INPUT_CUSTOM (i_tex);
    FragmentCommonDataCustom o = MetallicSetupCustom (i_tex);
    PerPixelWorldNormalCustom(i_tex, tangentToWorld,/* out*/ o.normalWorldBase,/* out */o.normalWorld, /* out */o.tangentWorld, /* out */o.binormalWorld, /* out */ occlusion);
    //PerPixelWorldNormal2017(i_tex, tangentToWorld,/* out */o.normalWorld, /* out */o.tangentWorld, /* out */o.binormalWorld);
    
    o.eyeVec = NormalizePerPixelNormal(i_eyeVec);
    o.posWorld = i_posWorld;

    // NOTE: shader relies on pre-multiply alpha-blend (_SrcBlend = One, _DstBlend = OneMinusSrcAlpha)
    o.diffColor = PreMultiplyAlpha (o.diffColor, alpha, o.oneMinusReflectivity, /*out*/ o.alpha)  ;
    o.occlusion = occlusion;
    return o;
}

inline UnityGI FragmentGICustom (FragmentCommonDataCustom s, half occlusion, half4 i_ambientOrLightmapUV, half atten, UnityLight light, bool reflections)
{
    UnityGIInput d;
    d.light = light;
    d.worldPos = s.posWorld;
    d.worldViewDir = -s.eyeVec;
    d.atten = atten;
    #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
        d.ambient = 0;
        d.lightmapUV = i_ambientOrLightmapUV;
    #else
        d.ambient = i_ambientOrLightmapUV.rgb;
        d.lightmapUV = 0;
    #endif

    d.probeHDR[0] = unity_SpecCube0_HDR;
    d.probeHDR[1] = unity_SpecCube1_HDR;
    #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
      d.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
    #endif
    #ifdef UNITY_SPECCUBE_BOX_PROJECTION
      d.boxMax[0] = unity_SpecCube0_BoxMax;
      d.probePosition[0] = unity_SpecCube0_ProbePosition;
      d.boxMax[1] = unity_SpecCube1_BoxMax;
      d.boxMin[1] = unity_SpecCube1_BoxMin;
      d.probePosition[1] = unity_SpecCube1_ProbePosition;
    #endif

    if(reflections)
    {
        Unity_GlossyEnvironmentData g = UnityGlossyEnvironmentSetup(s.smoothness, -s.eyeVec, s.normalWorld, s.specColor);
        // Replace the reflUVW if it has been compute in Vertex shader. Note: the compiler will optimize the calcul in UnityGlossyEnvironmentSetup itself
        #if UNITY_STANDARD_SIMPLE
            
            g.reflUVW = s.reflUVW;
        #endif

        return UnityGlobalIllumination (d, occlusion, s.normalWorld, g);
    }
    else
    {
        return UnityGlobalIllumination (d, occlusion, s.normalWorld);
    }
}

inline UnityGI FragmentGICustom (FragmentCommonDataCustom s, half occlusion, half4 i_ambientOrLightmapUV, half atten, UnityLight light)
{
    return FragmentGICustom(s, occlusion, i_ambientOrLightmapUV, atten, light, true);
}

// ------------------------------------------------------------------
//  Base forward pass (directional light, emission, lightmaps, ...)

struct VertexOutputForwardBaseCustom
{
    UNITY_POSITION(pos);
    float4 tex                          : TEXCOORD0;
    half3 eyeVec                        : TEXCOORD1;
    half4 tangentToWorldAndPackedData[3]    : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:viewDirForParallax or worldPos]
    half4 ambientOrLightmapUV           : TEXCOORD5;    // SH or Lightmap UV
    UNITY_SHADOW_COORDS(6)
    UNITY_FOG_COORDS(7)

    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
    #if UNITY_REQUIRE_FRAG_WORLDPOS && !UNITY_PACK_WORLDPOS_WITH_TANGENT
        float3 posWorld                 : TEXCOORD8;
    #endif

    UNITY_VERTEX_INPUT_INSTANCE_ID
    UNITY_VERTEX_OUTPUT_STEREO
};

float4 TexCoordsCustom(VertexInput v)
{
    float4 texcoord;
    texcoord.xy = TRANSFORM_TEX(v.uv0, _MainTex); // Always source from uv0  
    #if defined(_EYE_ENABLE_ON)
        float2 uv = texcoord.xy - .5;
        uv *= _Eye_IrisScale;
        texcoord.xy = uv + .5;
    #endif
    texcoord.zw = TRANSFORM_TEX(((_UVSec == 0) ? v.uv0 : v.uv1), _DetailAlbedoMap);
    return texcoord;
}

VertexOutputForwardBaseCustom vertForwardBaseCustom (VertexInput v)
{
    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardBaseCustom o = (VertexOutputForwardBaseCustom)0;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardBaseCustom, o);
    UNITY_TRANSFER_INSTANCE_ID(v, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
    #if UNITY_REQUIRE_FRAG_WORLDPOS
        #if UNITY_PACK_WORLDPOS_WITH_TANGENT
            o.tangentToWorldAndPackedData[0].w = posWorld.x;
            o.tangentToWorldAndPackedData[1].w = posWorld.y;
            o.tangentToWorldAndPackedData[2].w = posWorld.z;
        #else
            o.posWorld = posWorld.xyz;
        #endif
    #endif
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoordsCustom(v);
    o.eyeVec = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);

    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        half3 normal = normalWorld; 
        half3 tangent = tangentWorld.xyz;
        float tangentw = 1.0 - 2.0 * step(1.5, length(v.tangent.xyz));

        #if defined(_NORMAL_DIR_BACK) || defined(_NORMAL_DIR_NONE)
            // Unity
            half3 binormal = cross(normal, tangent) * v.tangent.w * tangentw;
        #else 
            half3 binormal = cross(tangent, normal) * v.tangent.w * tangentw;
        #endif
        // 轴向相反
        tangent = normalize(tangent);
        binormal = normalize(binormal);
        normal = normalize(normal);

        o.tangentToWorldAndPackedData[0].xyz = tangent;
        o.tangentToWorldAndPackedData[1].xyz = binormal;
        o.tangentToWorldAndPackedData[2].xyz = normal;
    #else
        o.tangentToWorldAndPackedData[0].xyz = 0;
        o.tangentToWorldAndPackedData[1].xyz = 0;
        o.tangentToWorldAndPackedData[2].xyz = normalWorld;
    #endif
    
    //We need this for shadow receving
    UNITY_TRANSFER_SHADOW(o, v.uv1);

    o.ambientOrLightmapUV = VertexGIForward(v, posWorld, normalWorld);

    #ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        half3 viewDirForParallax = mul (rotation, ObjSpaceViewDir(v.vertex));
        o.tangentToWorldAndPackedData[0].w = viewDirForParallax.x;
        o.tangentToWorldAndPackedData[1].w = viewDirForParallax.y;
        o.tangentToWorldAndPackedData[2].w = viewDirForParallax.z;
    #endif

    UNITY_TRANSFER_FOG(o,o.pos);
    return o;
}

half4 fragForwardBaseCustom (VertexOutputForwardBaseCustom i) : SV_Target 
{
    UNITY_APPLY_DITHER_CROSSFADE(i.pos.xy);
	
    //Correct TBN frame and texcoords before calling fragment setup.
#if defined(_DOUBLE_SIDED_FABRIC) && SHADER_STAGE_FRAGMENT
    bool isFrontFace = IS_FRONT_VFACE(i.cullFace, true, false);
    DoubleSided(isFrontFace, i.tangentToWorldAndPackedData, i.tex);
#endif

#if defined(_EYE_ENABLE_ON)
    half2 uv = i.tex.xy - .5;
    half Pupil = saturate(length(uv)/ 0.14);
    #if defined(_EYE_RANDOMSCALE_ON)
        uv *= lerp(1.0, Pupil, _Eye_Dilation);
    #else
        uv *= lerp(1.0, Pupil, sin(_Eye_Dilation* _Time.y));
    #endif
    uv += .5;
    i.tex.xy = uv;
#endif

    FragmentCommonDataCustom s = FragmentSetupCustom(i.tex, i.eyeVec, IN_VIEWDIR4PARALLAX(i), i.tangentToWorldAndPackedData, IN_WORLDPOS(i));
#if defined(_D_TEX_ALBEDO)
    Print(s.albedo)
#endif
#if defined(_D_TEX_METALLIC)
    Print(s.metallic)
#endif
#if defined(_D_TEX_SMOOTHNESS)
    Print(s.smoothness)
#endif
#if defined(_D_TEX_DIFFUSE)
    Print(s.diffColor)
#endif
#if defined(_D_TEX_SPECULAR)
    Print(s.specColor)
#endif
#if defined(_D_TEX_SKINMASK)
    Print(s.skinMask)
#endif

// ---------- Debug Normal
#if defined(_DEBUG_NORMAL_NORMALTEXTURE)
    half3 normal = tex2D (_BumpMap, i.tex.xy);
    Print(normal)
#endif
#if defined(_DEBUG_NORMAL_NORMALWORLD)
    return half4(s.normalWorld,1);
#endif
#if defined(_DEBUG_NORMAL_TANGENTWORLD)
    return half4(s.tangentWorld,1);
#endif
#if defined(_DEBUG_NORMAL_BINORMALWORLD)
    return half4(s.binormalWorld,1);
#endif
// end
 
    UNITY_SETUP_INSTANCE_ID(i);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    UnityLight mainLight = MainLight ();

    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld);

	half occlusion = Occlusion(i.tex.xy);
#if defined(_JUST_ONLY_ANSIO)
    UnityGI gi = FragmentGICustom(s, s.occlusion, i.ambientOrLightmapUV, atten, mainLight, false);
#else
    UnityGI gi = FragmentGICustom(s, s.occlusion, i.ambientOrLightmapUV, atten, mainLight, true);
#endif

	SilkData sd;
    UNITY_INITIALIZE_OUTPUT(SilkData, sd);
//#if defined(SUBSURFACE_MATERIAL_FABRIC) && defined(_FABRIC_SILK)
//    FillSilkData(sd, s.normalWorld, i.tangentToWorldAndPackedData[0].xyz, s.smoothness);
//#endif

    BRDFInput bi ;
    bi.uv = s.uv;
    bi.occlusion = s.occlusion;
    bi.skinMask = s.skinMask;
    bi.diffColor = s.diffColor; 
    bi.specColor = s.specColor;
    bi.oneMinusReflectivity = s.oneMinusReflectivity; 
    bi.metallic = s.metallic;
    bi.smoothness = s.smoothness; 
    bi.normalBase = s.normalWorldBase;
    bi.normal = s.normalWorld;
    bi.tangent = s.tangentWorld;
    bi.binormal = s.binormalWorld; 
    bi.viewDir = -s.eyeVec; 
    bi.light = gi.light; 
    bi.gi = gi.indirect;
    bi.atten = atten;
    bi.posWorld = s.posWorld;
	fixed4 c;
#if defined(_USESILK_ON)
	if(bi.metallic > 0.9 || bi.metallic <0.03)
    {
		c = UNITY_BRDF_PBS_CUSTOM(bi);
	}
    else
    {
    	SilkData sd;
        UNITY_INITIALIZE_OUTPUT(SilkData, sd);
    	FillSilkData(sd, s.normalWorld, i.tangentToWorldAndPackedData[0].xyz, s.smoothness);
        //#if defined(SUBSURFACE_MATERIAL_FABRIC) && defined(_FABRIC_SILK)
        //    FillSilkData(sd, s.normalWorld, i.tangentToWorldAndPackedData[0].xyz, s.smoothness);
        //#endif
    	c = SilkBRDF (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect, sd);
	}
#else
	c = UNITY_BRDF_PBS_CUSTOM(bi);
#endif
    //#if defined(_BRDF_TYPE_UNITY)
    //half4 c = BRDF1_Unity_PBS (s.diffColor, s.specColor, s.oneMinusReflectivity, s.smoothness, s.normalWorld, -s.eyeVec, gi.light, gi.indirect);
    //#endif
	 
    c.rgb += EmissionCustom(i.tex.xy);
    UNITY_APPLY_FOG(i.fogCoord, c.rgb);
	
    return half4 (c.rgb, _BloomFactor);
}

// ------------------------------------------------------------------
//  Additive forward pass (one light per pass)

struct VertexOutputForwardAddCustom
{
    float4 pos                          : SV_POSITION;
    float4 tex                          : TEXCOORD0;
    half3 eyeVec                        : TEXCOORD1;
    half4 tangentToWorldAndLightDir[3]  : TEXCOORD2;    // [3x3:tangentToWorld | 1x3:lightDir]
    float3 posWorld                     : TEXCOORD5;
    UNITY_SHADOW_COORDS(6)
    UNITY_FOG_COORDS(7)

    // next ones would not fit into SM2.0 limits, but they are always for SM3.0+
#if defined(_PARALLAXMAP)
    half3 viewDirForParallax            : TEXCOORD8;
#endif

    UNITY_VERTEX_OUTPUT_STEREO
};


VertexOutputForwardAddCustom vertForwardAddCustom (VertexInput v)
{
    UNITY_SETUP_INSTANCE_ID(v);
    VertexOutputForwardAddCustom o;
    UNITY_INITIALIZE_OUTPUT(VertexOutputForwardAddCustom, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float4 posWorld = mul(unity_ObjectToWorld, v.vertex);
    o.pos = UnityObjectToClipPos(v.vertex);

    o.tex = TexCoords(v);
    o.eyeVec = NormalizePerVertexNormal(posWorld.xyz - _WorldSpaceCameraPos);
    o.posWorld = posWorld.xyz;
    float3 normalWorld = UnityObjectToWorldNormal(v.normal);
    #ifdef _TANGENT_TO_WORLD
        float4 tangentWorld = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);

        float3x3 tangentToWorld = CreateTangentToWorldPerVertex(normalWorld, tangentWorld.xyz, tangentWorld.w);
        o.tangentToWorldAndLightDir[0].xyz = tangentToWorld[0];
        o.tangentToWorldAndLightDir[1].xyz = tangentToWorld[1];
        o.tangentToWorldAndLightDir[2].xyz = tangentToWorld[2];
    #else
        o.tangentToWorldAndLightDir[0].xyz = 0;
        o.tangentToWorldAndLightDir[1].xyz = 0;
        o.tangentToWorldAndLightDir[2].xyz = normalWorld;
    #endif
    //We need this for shadow receiving
    UNITY_TRANSFER_SHADOW(o, v.uv1);

    float3 lightDir = _WorldSpaceLightPos0.xyz - posWorld.xyz * _WorldSpaceLightPos0.w;
    #ifndef USING_DIRECTIONAL_LIGHT
        lightDir = NormalizePerVertexNormal(lightDir);
    #endif
    o.tangentToWorldAndLightDir[0].w = lightDir.x;
    o.tangentToWorldAndLightDir[1].w = lightDir.y;
    o.tangentToWorldAndLightDir[2].w = lightDir.z;

    #ifdef _PARALLAXMAP
        TANGENT_SPACE_ROTATION;
        o.viewDirForParallax = mul (rotation, ObjSpaceViewDir(v.vertex));
    #endif

    UNITY_TRANSFER_FOG(o,o.pos);
    return o;
}

half4 fragForwardAddInternalCustom (VertexOutputForwardAddCustom i)
{
    FragmentCommonDataCustom s = FragmentSetupCustom(i.tex, i.eyeVec, IN_VIEWDIR4PARALLAX_FWDADD(i), i.tangentToWorldAndLightDir, IN_WORLDPOS_FWDADD(i));
    UNITY_LIGHT_ATTENUATION(atten, i, s.posWorld)
    UnityLight light = AdditiveLight (IN_LIGHTDIR_FWDADD(i), atten);
    UnityIndirect noIndirect = ZeroIndirect ();
    
    BRDFInput bi;
    bi.uv = s.uv;
    bi.occlusion = s.occlusion;
    bi.skinMask = s.skinMask;
    bi.diffColor = s.diffColor; 
    bi.specColor = s.specColor;
    bi.oneMinusReflectivity = s.oneMinusReflectivity; 
    bi.metallic = s.metallic;
    bi.smoothness = s.smoothness; 
    bi.normalBase = s.normalWorldBase;
    bi.normal = s.normalWorld;
    bi.tangent = s.tangentWorld;
    bi.binormal = s.binormalWorld; 
    bi.viewDir = -s.eyeVec; 
    bi.light = light; 
    bi.gi = noIndirect;
    bi.atten = atten;
    bi.posWorld = s.posWorld;

    half4 c = UNITY_BRDF_PBS_CUSTOM(bi);

    UNITY_APPLY_FOG_COLOR(i.fogCoord, c.rgb, half4(0,0,0,0)); // fog towards black in additive pass
    return half4 (c.rgb, _BloomFactor);
}

half4 fragForwardAddCustom (VertexOutputForwardAddCustom i) : SV_Target     // backward compatibility (this used to be the fragment entry function)
{
    return fragForwardAddInternalCustom(i);
}

#endif // UNITY_STANDARD_CORE_INCLUDED
