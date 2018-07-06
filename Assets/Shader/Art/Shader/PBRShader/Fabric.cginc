#ifndef FABRIC
#define FABRIC

float3 _FuzzTint;

struct SilkData{
    float3 tangentWS;
    float3 bitangentWS;
    float roughnessT;
    float roughnessB;
};

void DoubleSided(bool isFrontFace, inout half4 tbn[3], inout float4 texcoords){
    if(isFrontFace){
#ifdef _HAS_BACKFACE_TEXTURE_SET
        texcoords.x *= 0.5; //Scale and shift UVs to properly sample packed textures
#endif
    } else {
#ifdef _HAS_BACKFACE_TEXTURE_SET
        texcoords.x *= 0.5;
        texcoords.x += 0.5; 
        //TODO: texcoords.zw
#endif

        //Flip the TBN in case of a backface, for proper lighting.
        tbn[1] *= -1;
        tbn[2] *= -1;
    }
}

// Ref: http://blog.selfshadow.com/publications/s2012-shading-course/burley/s2012_pbs_disney_brdf_notes_v3.pdf (in addenda)
// Convert anisotropic ratio (0->no isotropic; 1->full anisotropy in tangent direction) to roughness
void ConvertAnisotropyToRoughness(float roughness, float anisotropy, out float roughnessT, out float roughnessB)
{
    // (0 <= anisotropy <= 1), therefore (0 <= anisoAspect <= 1)
    // The 0.9 factor limits the aspect ratio to 10:1.
    float anisoAspect = sqrt(1.0 - 0.9 * anisotropy);

    roughnessT = roughness / anisoAspect; // Distort along tangent (rougher)
    roughnessB = roughness * anisoAspect; // Straighten along bitangent (smoother)
}

void FillSilkData(inout SilkData o_sd, half3 normal, half3 vertexTangent, float smoothness){
    //Orthonormalize the basis vectors using Gram-Schmidt process
    o_sd.tangentWS   = normalize(vertexTangent - dot(vertexTangent, normal) * normal);
    o_sd.bitangentWS = cross(normal, o_sd.tangentWS);

    float perceptualRoughness = SmoothnessToPerceptualRoughness(smoothness);
    float roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

    ConvertAnisotropyToRoughness(roughness, 0.9, o_sd.roughnessT, o_sd.roughnessB);
}

#ifndef FABRIC_BRDF
    #ifdef _FABRIC_SILK
        #define FABRIC_BRDF SilkBRDF
    #else
        #define FABRIC_BRDF CottonWoolBRDF
    #endif
#endif

// Ref: https://cedec.cesa.or.jp/2015/session/ENG/14698.html The Rendering Materials of Far Cry 4
float V_SmithJointGGXAniso(float TdotV, float BdotV, float NdotV, float TdotL, float BdotL, float NdotL, float roughnessT, float roughnessB)
{
    float aT = roughnessT;
    float aT2 = aT * aT;
    float aB = roughnessB;
    float aB2 = aB * aB;

    float lambdaV = NdotL * sqrt(aT2 * TdotV * TdotV + aB2 * BdotV * BdotV + NdotV * NdotV);
    float lambdaL = NdotV * sqrt(aT2 * TdotL * TdotL + aB2 * BdotL * BdotL + NdotL * NdotL);

    return 0.5 / (lambdaV + lambdaL);
}

// roughnessT -> roughness in tangent direction
// roughnessB -> roughness in bitangent direction
float D_GGXAnisoNoPI(float TdotH, float BdotH, float NdotH, float roughnessT, float roughnessB)
{
    float f = TdotH * TdotH / (roughnessT * roughnessT) + BdotH * BdotH / (roughnessB * roughnessB) + NdotH * NdotH;
    return 1.0 / (roughnessT * roughnessB * f * f);
}

float D_GGXAniso(float TdotH, float BdotH, float NdotH, float roughnessT, float roughnessB)
{
    return UNITY_INV_PI * D_GGXAnisoNoPI(TdotH, BdotH, NdotH, roughnessT, roughnessB);
}

//Silk Fabric BRDF
//------------------------------------------------------------------------------------------
half4 SilkBRDF (half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness,
                half3 normal, half3 viewDir,
                UnityLight light, UnityIndirect gi,
                SilkData sd)
{
    float NdotL = saturate(dot(normal, light.dir));
    float NdotV = abs(dot(normal, viewDir));
    float LdotV = dot(light.dir, viewDir);
    float invLenLV = rsqrt(abs(2 * LdotV + 2));
    float NdotH = saturate((NdotL + NdotV) * invLenLV);
    float LdotH = saturate(invLenLV * LdotV + invLenLV);

    float3 F = FresnelTerm (diffColor, LdotH);

    float Vis;
    float D;

    float3 H = (light.dir + viewDir) * invLenLV;
    float TdotH = dot(sd.tangentWS,   H);
    float TdotL = dot(sd.tangentWS,   light.dir);
    float TdotV = dot(sd.tangentWS,   viewDir);
    float BdotH = dot(sd.bitangentWS, H);
    float BdotL = dot(sd.bitangentWS, light.dir);
    float BdotV = dot(sd.bitangentWS, viewDir);

    Vis = V_SmithJointGGXAniso(TdotV, BdotV, NdotV, TdotL, BdotL, NdotL, 
                               sd.roughnessT, sd.roughnessB);

    D = D_GGXAniso(TdotH, BdotH, NdotH, sd.roughnessT, sd.roughnessB);
    
    half perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    half roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

    // surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(roughness^2+1)
    half surfaceReduction;
#   ifdef UNITY_COLORSPACE_GAMMA
        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#   else
        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
#   endif

    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    
    half specularTerm = F * (Vis * D);
    // specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
    specularTerm = max(0, specularTerm * NdotL);
#if defined(_SPECULARHIGHLIGHTS_OFF)
    specularTerm = 0.0;
#endif

    float diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
    half3 color = diffColor * (gi.diffuse + light.color * diffuseTerm)
                + ((2.25 * specularTerm * light.color)
                + surfaceReduction * gi.specular * FresnelLerp(specColor, grazingTerm, NdotV)) * _FuzzTint; ;
    
    return half4(color, 1);
}

//Cotton BRDF
//-----------------------------------------------------------------------------------------
half4 CottonWoolBRDF(half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness,
               half3 normal, half3 viewDir,
               UnityLight light, UnityIndirect gi,
               SilkData unused)
{
    float NdotL = saturate(dot(normal, light.dir));
    float NdotV = abs(dot(normal, viewDir));
    float LdotV = dot(light.dir, viewDir);
    float invLenLV = rsqrt(abs(2 * LdotV + 2));
    float NdotH = saturate((NdotL + NdotV) * invLenLV);
    float LdotH = saturate(invLenLV * LdotV + invLenLV);

    //TODO: NdotV

    float3 F = FresnelTerm (0.2, LdotH);

    float Vis;
    float D;
    float3 H = (light.dir + viewDir) * invLenLV;
    half perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    half roughness = PerceptualRoughnessToRoughness(perceptualRoughness);
    float cnorm = 1.0 / (UNITY_PI * (4.0 * roughness + 1.0));

    float NdotH2 = NdotH*NdotH;
    float cot2 = NdotH2 / (1.0 - NdotH2);
    float sin2 = 1.0 - NdotH2;
    float sin4 = sin2 * sin2;
    float amp = 4.0;

    D = cnorm * (1.0 + (amp * exp(-cot2 / roughness) / sin4));
    Vis = SmithJointGGXVisibilityTerm (NdotL, NdotV, roughness);

    float NdotLwrap = sqrt(NdotL);

    // surfaceReduction = Int D(NdotH) * NdotH * Id(NdotL>0) dH = 1/(roughness^2+1)
    half surfaceReduction;
#   ifdef UNITY_COLORSPACE_GAMMA
        surfaceReduction = 1.0-0.28*roughness*perceptualRoughness;      // 1-0.28*x^3 as approximation for (1/(x^4+1))^(1/2.2) on the domain [0;1]
#   else
        surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
#   endif

    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    
    half specularTerm = NdotLwrap * F * (Vis * D);
    // specularTerm * nl can be NaN on Metal in some cases, use max() to make sure it's a sane value
    specularTerm = max(0, specularTerm);
#if defined(_SPECULARHIGHLIGHTS_OFF)
    specularTerm = 0.0;
#endif

    float diffuseTerm = DisneyDiffuse(NdotV, NdotL, LdotH, perceptualRoughness) * NdotL;
    
    half3 color = diffColor * (gi.diffuse + light.color * diffuseTerm)
                + ((specularTerm * light.color)
                + surfaceReduction * gi.specular * FresnelLerp(specColor, grazingTerm, NdotV)) * _FuzzTint;
    
    return half4(color, 1);
}

#endif