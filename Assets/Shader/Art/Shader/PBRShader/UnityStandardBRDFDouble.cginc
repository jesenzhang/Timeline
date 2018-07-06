#ifndef UNITY_STANDARD_BRDF_DOUBLE_INCLUDED
#define UNITY_STANDARD_BRDF_DOUBLE_INCLUDED

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityLightingCommon.cginc"

half SpecularTerm(float nl, float nv, float nh, float roughness, float perceptualRoughness)
{
#if UNITY_BRDF_GGX
    // GGX with roughtness to 0 would mean no specular at all, using max(roughness, 0.002) here to match HDrenderloop roughtness remapping.
    roughness = max(roughness, 0.002);
    half V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
    float D = GGXTerm (nh, roughness);
#else
    // Legacy
    half V = SmithBeckmannVisibilityTerm (nl, nv, roughness);
    half D = NDFBlinnPhongNormalizedTerm (nh, PerceptualRoughnessToSpecPower(perceptualRoughness));
#endif

    half specularTerm = V*D * UNITY_PI; // Torrance-Sparrow model, Fresnel is applied later

#   ifdef UNITY_COLORSPACE_GAMMA
        specularTerm = sqrt(max(1e-4h, specularTerm));
#   endif

    // specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
    specularTerm = max(0, specularTerm * nl);
#if defined(_SPECULARHIGHLIGHTS_OFF)
    specularTerm = 0.0;
#endif
    return specularTerm;
}
half4 _SecondLightVector;

half4 BRDF1_Unity_PBS_Double (half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness,
    float3 normal, float3 viewDir, half occlusion,
    UnityLight light, UnityIndirect gi)
{
    float perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    float3 halfDir = Unity_SafeNormalize (float3(light.dir) + viewDir);

// NdotV should not be negative for visible pixels, but it can happen due to perspective projection and normal mapping
// In this case normal should be modified to become valid (i.e facing camera) and not cause weird artifacts.
// but this operation adds few ALU and users may not want it. Alternative is to simply take the abs of NdotV (less correct but works too).
// Following define allow to control this. Set it to 0 if ALU is critical on your platform.
// This correction is interesting for GGX with SmithJoint visibility function because artifacts are more visible in this case due to highlight edge of rough surface
// Edit: Disable this code by default for now as it is not compatible with two sided lighting used in SpeedTree.
//#define UNITY_HANDLE_CORRECTLY_NEGATIVE_NDOTV 0

#if UNITY_HANDLE_CORRECTLY_NEGATIVE_NDOTV
    // The amount we shift the normal toward the view vector is defined by the dot product.
    half shiftAmount = dot(normal, viewDir);
    normal = shiftAmount < 0.0f ? normal + viewDir * (-shiftAmount + 1e-5f) : normal;
    // A re-normalization should be applied here but as the shift is small we don't do it to save ALU.
    //normal = normalize(normal);

    half nv = saturate(dot(normal, viewDir)); // TODO: this saturate should no be necessary here
#else
    half nv = abs(dot(normal, viewDir));    // This abs allow to limit artifact
#endif

    half nl = saturate(dot(normal, light.dir));
    float nh = saturate(dot(normal, halfDir));

    half lv = saturate(dot(light.dir, viewDir));
    half lh = saturate(dot(light.dir, halfDir));

    // Diffuse term
    half diffuseTerm = DisneyDiffuse(nv, nl, lh, perceptualRoughness) * nl;

    // Specular term
    // HACK: theoretically we should divide diffuseTerm by Pi and not multiply specularTerm!
    // BUT 1) that will make shader look significantly darker than Legacy ones
    // and 2) on engine side "Non-important" lights have to be divided by Pi too in cases when they are injected into ambient SH
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
    half specularTerm = SpecularTerm(nl, nv, nh, roughness, perceptualRoughness);
    

    half3 fresnelTerm = FresnelTerm (specColor, lh);

    // To provide true Lambert lighting, we need to be able to kill specular completely.
    specularTerm *= any(specColor) ? 1.0 : 0.0;

    half3 specular = specularTerm * light.color * fresnelTerm;
#if defined(_SECONDLIGHTENABLE_ON)
    half3 lightDir = normalize(_SecondLightVector.xyz);
    half3 halfDir2 = Unity_SafeNormalize (lightDir + viewDir);
    half nl2 = saturate(dot(normal, lightDir));
    float nh2 = saturate(dot(normal, halfDir2));

    half lv2 = saturate(dot(lightDir, viewDir));
    half lh2 = saturate(dot(lightDir, halfDir2));
    half3 fresnelTerm2 = FresnelTerm (specColor, lh2);
    half specularTerm2 = SpecularTerm(nl2, nv, nh2, roughness, perceptualRoughness);
    specularTerm2 *= any(specColor) ? 1.0 : 0.0;
    half3 specular2 = specularTerm2 * light.color * fresnelTerm2;

    //specular = lerp(specular, specular2, _SecondLightVector.w);
    specular += specular2*_SecondLightVector.w;
    //return half4(specular,1);
#endif

    // surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(roughness^2+1)
    half surfaceReduction;
#   ifdef UNITY_COLORSPACE_GAMMA
        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#   else
        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
#   endif

    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));


    /*#if defined(_CUBEMAPENABLE_ON)
        {
            half3 refDir = reflect(-viewDir, normal);
            float3 refColor = texCUBE(_CubeMap, refDir).rgb;
            gi.specular = (refColor * occlusion);
        }
    #endif
    */

    half3 color =    0 
                    + diffColor * (gi.diffuse + light.color * diffuseTerm)
                    + specular
                    + surfaceReduction * gi.specular * FresnelLerp (specColor, grazingTerm, nv)
                    ;
#if defined(_DEBUGTIERLEVEL_ON)
    return half4(1,0,0, 1);
#endif
    return half4(color, 1);
}

float SpecularTerm2(float nl, float nv, float nh, float lh, half roughness, half perceptualRoughness)
{
    #if UNITY_BRDF_GGX

    // GGX Distribution multiplied by combined approximation of Visibility and Fresnel
    // See "Optimizing PBR for Mobile" from Siggraph 2015 moving mobile graphics course
    // https://community.arm.com/events/1155
    half a = roughness;
    float a2 = a*a;

    float d = nh * nh * (a2 - 1.f) + 1.00001f;
#ifdef UNITY_COLORSPACE_GAMMA
    // Tighter approximation for Gamma only rendering mode!
    // DVF = sqrt(DVF);
    // DVF = (a * sqrt(.25)) / (max(sqrt(0.1), lh)*sqrt(roughness + .5) * d);
    float specularTerm = a / (max(0.32f, lh) * (1.5f + roughness) * d);
#else
    float specularTerm = a2 / (max(0.1f, lh*lh) * (roughness + 0.5f) * (d * d) * 4);
#endif

    // on mobiles (where half actually means something) denominator have risk of overflow
    // clamp below was added specifically to "fix" that, but dx compiler (we convert bytecode to metal/gles)
    // sees that specularTerm have only non-negative terms, so it skips max(0,..) in clamp (leaving only min(100,...))
#if defined (SHADER_API_MOBILE)
    specularTerm = specularTerm - 1e-4f;
#endif

#else

    // Legacy
    half specularPower = PerceptualRoughnessToSpecPower(perceptualRoughness);
    // Modified with approximate Visibility function that takes roughness into account
    // Original ((n+1)*N.H^n) / (8*Pi * L.H^3) didn't take into account roughness
    // and produced extremely bright specular at grazing angles

    half invV = lh * lh * smoothness + perceptualRoughness * perceptualRoughness; // approx ModifiedKelemenVisibilityTerm(lh, perceptualRoughness);
    half invF = lh;

    float specularTerm = ((specularPower + 1) * pow (nh, specularPower)) / (8 * invV * invF + 1e-4h);

#ifdef UNITY_COLORSPACE_GAMMA
    specularTerm = sqrt(max(1e-4f, specularTerm));
#endif

#endif

#if defined (SHADER_API_MOBILE)
    specularTerm = clamp(specularTerm, 0.0, 100.0); // Prevent FP16 overflow on mobiles
#endif
#if defined(_SPECULARHIGHLIGHTS_OFF)
    specularTerm = 0.0;
#endif
    return specularTerm;
}
// Based on Minimalist CookTorrance BRDF
// Implementation is slightly different from original derivation: http://www.thetenthplanet.de/archives/255
//
// * NDF (depending on UNITY_BRDF_GGX):
//  a) BlinnPhong
//  b) [Modified] GGX
// * Modified Kelemen and Szirmay-​Kalos for Visibility term
// * Fresnel approximated with 1/LdotH
half4 BRDF2_Unity_PBS_Double (half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness,
    float3 normal, float3 viewDir, half occlusion,
    UnityLight light, UnityIndirect gi)
{
    float3 halfDir = Unity_SafeNormalize (float3(light.dir) + viewDir);

    half nl = saturate(dot(normal, light.dir));
    float nh = saturate(dot(normal, halfDir));
    half nv = saturate(dot(normal, viewDir));
    float lh = saturate(dot(light.dir, halfDir));

    // Specular term
    half perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    half roughness = PerceptualRoughnessToRoughness(perceptualRoughness);


    half specularTerm = SpecularTerm2(nl, nv, nh, lh, roughness, perceptualRoughness);
    // surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(realRoughness^2+1)

    // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
    // 1-x^3*(0.6-0.08*x)   approximation for 1/(x^4+1)
#ifdef UNITY_COLORSPACE_GAMMA
    half surfaceReduction = 0.28;
#else
    half surfaceReduction = (0.6-0.08*perceptualRoughness);
#endif

    surfaceReduction = 1.0 - roughness*perceptualRoughness*surfaceReduction;

/*#if defined(_CUBEMAPENABLE_ON)
    {
        half3 refDir = reflect(-viewDir, normal);
        float3 refColor = texCUBE(_CubeMap, refDir).rgb;
        gi.specular = (refColor * occlusion);
    }
#endif*/
    half3 specular = (diffColor + specularTerm * specColor) * light.color * nl;
#if defined(_SECONDLIGHTENABLE_ON)
    {
        half3 lightDir = normalize(_SecondLightVector.xyz);
        half3 halfDir2 = Unity_SafeNormalize (lightDir + viewDir);
        half nl2 = saturate(dot(normal, lightDir));
        half nh2 = saturate(dot(normal, halfDir2));
        half nv2 = saturate(dot(normal, viewDir));
        half lh2 = saturate(dot(lightDir, halfDir2));

        half specularTerm2 = SpecularTerm2(nl2, nv2, nh2, lh2, roughness, perceptualRoughness);
        half3 specular2 = (diffColor + specularTerm2 * specColor) * light.color * nl2;
        specular += specular2 * _SecondLightVector.w;
        return half4(specular, 1);
    }
#endif
    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    half3 color =   specular
                    + gi.diffuse * diffColor
                    + surfaceReduction * gi.specular * FresnelLerpFast (specColor, grazingTerm, nv);

#if defined(_DEBUGTIERLEVEL_ON)
    return half4(0,1,0, 1);
#endif
    return half4(color, 1);
}


// Old school, not microfacet based Modified Normalized Blinn-Phong BRDF
// Implementation uses Lookup texture for performance
//
// * Normalized BlinnPhong in RDF form
// * Implicit Visibility term
// * No Fresnel term
//
// TODO: specular is too weak in Linear rendering mode
half4 BRDF3_Unity_PBS_Double (half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness,
    float3 normal, float3 viewDir, half occlusion,
    UnityLight light, UnityIndirect gi)
{
    float3 reflDir = reflect (viewDir, normal);

    half nl = saturate(dot(normal, light.dir));
    half nv = saturate(dot(normal, viewDir));

    // Vectorize Pow4 to save instructions
    half2 rlPow4AndFresnelTerm = Pow4 (float2(dot(reflDir, light.dir), 1-nv));  // use R.L instead of N.H to save couple of instructions
    half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
    half fresnelTerm = rlPow4AndFresnelTerm.y;

    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));

    half3 color = BRDF3_Direct(diffColor, specColor, rlPow4, smoothness);
    color *= light.color * nl;
    color += BRDF3_Indirect(diffColor, specColor, gi, grazingTerm, fresnelTerm);

#if defined(_DEBUGTIERLEVEL_ON)
    //return half4(0,0,1, 1);
#endif
    return half4(color, 1);
}

#endif