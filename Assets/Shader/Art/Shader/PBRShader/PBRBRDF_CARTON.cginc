#ifndef PBRBRDF_MOBA_CGINC
#define PBRBRDF_MOBA_CGINC

#include "UnityCG.cginc"
#include "UnityStandardConfig.cginc"
#include "UnityLightingCommon.cginc"

#include "PBRInput.cginc"
#include "PBRBRDF.cginc"
#include "UnityStandardCoreForward.cginc"

 
half SpecularTerm(out float D, out half V, half3 specColor, float nl, float nv, float nh, float roughness, float perceptualRoughness)
{
    /*#if defined(_SECONDLIGHTENABLE_ON)

        roughness = max(roughness, 0.002);
        //float3 f = float3(1,0,0);
        V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
        D = GGXTerm (nh, roughness);

    #elif defined(_BRDF_TYPE_LEGACY)
        // Legacy
        V = SmithBeckmannVisibilityTerm (nl, nv, roughness);
        D = NDFBlinnPhongNormalizedTerm (nh, PerceptualRoughnessToSpecPower(perceptualRoughness));

    #else
        // GGX with roughtness to 0 would mean no specular at all, using max(roughness, 0.002) here to match HDrenderloop roughtness remapping.
        roughness = max(roughness, 0.002);
        //float3 f = float3(1,0,0);
        //nl = dot(normal, reflect(lightDir, f));
        V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
        D = GGXTerm (nh, roughness);
    #endif
    */
    roughness = max(roughness, 0.002);
    //float3 f = float3(1,0,0);
    V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
    D = GGXTerm (nh, roughness);
    half specularTerm = V * D * UNITY_PI;
    specularTerm = max(0, specularTerm * nl);
    specularTerm *= any(specColor) ? 1.0 : 0.0;
    return specularTerm;
}

half4 BRDF_MOBA(BRDFInput i)
{
    half2 uv = i.uv;
    half occlusion = i.occlusion;
    float skinMask = i.skinMask;
    half3 diffColor = i.diffColor;
    half3 specColor = i.specColor;
    half oneMinusReflectivity = i.oneMinusReflectivity; 
    half metallic = i.metallic;
    half smoothness = i.smoothness;
    half3 normalBase = i.normalBase;
    float3 normal = i.normal;
    half3 worldNormal = i.normal;
    half3 tangent = i.tangent;
    half3 binormal = i.binormal;
    float3 viewDir = normalize(i.viewDir);
    UnityLight light = i.light;
    UnityIndirect gi = i.gi;
    float atten = i.atten;
    fixed3 posWorld = i.posWorld;

// GI BRDF
    half3 Diffuse = 0;
    half3 Specular = 0;
    half3 GI = 0;
    float D = 0;
    half3 F = 0;
    half V = 0; 
    half3 GIDiffuse = 0;

// Final 
    float3 final_Color = 0; 
    float3 final_Diffuse = 0;
    float3 final_Specular = 0;
    float3 final_GI = 0;

    half3 lightDir = light.dir;
    //#if defined(_SECONDLIGHTENABLE_ON)
    //    lightDir = _SecondLight.xyz;
   //#endif

    //lightDir = reflect(-viewDir, worldNormal);
    float3 halfDir = Unity_SafeNormalize (lightDir + viewDir);
    
    float3 light_color = light.color;

// Unity Pbr1
    half nv = abs(dot(normal, viewDir));   
    float nh = saturate(dot(normal, halfDir));

    half nl = saturate(dot(normal, lightDir));
    half lv = saturate(dot(lightDir, viewDir));
    half lh = saturate(dot(lightDir, halfDir));

   
    float3 giDiffuse = gi.diffuse;
    float perceptualRoughness = 0;
    float roughness = 0;

// *************************************************************** Hair Start ***************************************************************
//{ 

// Normal-and Directionality map for a cartonhair
// Warp nh for hair
#if defined(_BRDF_TYPE_CARTON) || defined(_BRDF_TYPE_CARTON_ONLY)
    float ndl_without_clamp = dot(normal, lightDir);
    float ndl = max(0.001,ndl_without_clamp);                   
    //float ndl_shadow = ndl;

    //float ndv = max(0.001,dot(normal, viewDir));          
    //float dotVNlocal_279 = saturate(dot(viewDir, normal));
    
    //float ndh = max(0.001,dot(normal, halfDir));
    float vdh = clamp(dot(viewDir, halfDir), 0.62, 1.0);      

    perceptualRoughness = 1 - smoothness;//SmoothnessToPerceptualRoughness (smoothness);
    perceptualRoughness = clamp(perceptualRoughness, 0.0, 1.0);
    perceptualRoughness  = lerp(0.04, 1, perceptualRoughness);
    roughness = perceptualRoughness * perceptualRoughness;// PerceptualRoughnessToRoughness(perceptualRoughness);

    // { shift hair start 
    
    #if defined(PBR_HAIR_SHIT) 
        float4 shiftTex = tex2D (_tSpecShift, uv);
        float3 t1 = ShiftTangent (tangent, normal, shiftTex.g - 0.5 +  _primaryShift);
        
        nh = StrandSpecular(t1, viewDir, lightDir, _SpecularGloss1);

    #else
        half aniso = GetAnisoMOBA(halfDir, normal, binormal, tangent, uv);

        #if defined(_BRDF_TYPE_CARTON)
            float outNormalCameraDirSubShadowLight3Norlocal_277 = max(0,  dot(normal, normalize(halfDir)));
            float nhlerp = step(skinMask, pow(0.25, 2.2)); 
            nh = lerp(outNormalCameraDirSubShadowLight3Norlocal_277, aniso, nhlerp);
        #elif defined(_BRDF_TYPE_CARTON_ONLY)
            nh = aniso;
        #endif
    #endif
    
    // }

    //float smoothness = lerp(0.04, 1, smoothness);

    specColor = lerp(specColor, specColor * _ansioColor * _ansioColor.a, 1);

    // 更平滑一些, 不会出现过曝的情况
    //V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
    D = GGXTermMoba (nh, roughness);
    F = F_SchlickMoba (specColor, vdh);
    //V = G_Schlick_Disney_MOBA(NoL_local_282, dotVNlocal_279, smoothness);
    V = G_Schlick_Disney_MOBA(ndl, vdh, smoothness);

    half specularTerm = V * D * UNITY_PI;
    specularTerm = max(0, specularTerm * ndl_without_clamp);
    specularTerm *= any(specColor) ? 1.0 : 0.0;

    final_Specular = specularTerm * light.color * F;
    //Print(final_Specular)
    //Print(specColor)

    half surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));


    float3 gicolor = gi.specular;
    final_GI = gicolor * FresnelLerp (specColor, grazingTerm, nv);

#elif defined(_BRDF_TYPE_REAL)

    float rough = 1 - smoothness;
    float3 aniso_ctrl = float3(_anisoControlX * rough, _anisoControlY * rough, _anisoControlZ);
    V = Vis_Schlick(rough, ndv, ndl,vdh);
    D = D_GGXanisoSD(aniso_ctrl.x, aniso_ctrl.y, ndh, halfDir, tangent, binormal);
    F = FresnelTerm(specColor,vdh);
    final_Specular = V * D * F * aniso_ctrl.z;

#elif defined(_BRDF_TYPE_GGX) || defined(_BRDF_TYPE_LEGACY)

    perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

    #if defined(_DEBUG_FORCE_NV_LIGHT_ON)
        nv = sin(dot(normal, viewDir) * 3.141593);
    #endif
    #if defined(_DEBUG_FORCE_NL_LIGHT_ON)
        nl = sin(dot(normal, lightDir) * 3.141593);
    #endif

    #if defined(_DEBUG_NOV_ON)
        nv = _debug_nv_value;
    #endif
    #if defined(_DEBUG_NOL_ON)
        nl = _debug_nl_value;
    #endif
   
    half specularTerm = SpecularTerm(/*out half3 */D, /*out half */V, /*half3 */specColor, nl, nv, nh, roughness, perceptualRoughness);

    /*perceptualRoughness = SmoothnessToPerceptualRoughness (smoothness);
    // Diffuse term
     //diffuseTerm = DisneyDiffuse(nv, nl, lh, perceptualRoughness) * nl;

    // Specular term
    // HACK: theoretically we should divide diffuseTerm by Pi and not multiply specularTerm!
    // BUT 1) that will make shader look significantly darker than Legacy ones
    // and 2) on engine side "Non-important" lights have to be divided by Pi too in cases when they are injected into ambient SH
    roughness = PerceptualRoughnessToRoughness(perceptualRoughness);

     roughness = max(roughness, 0.002);
    V = SmithJointGGXVisibilityTerm (nl, nv, roughness);
    D = GGXTerm (nh, roughness);
*/

    
    F = FresnelTerm (specColor, lh);
    

    half3 lightColor = light.color;
    #if defined(_EYE_ENABLE_ON)
        #if defined(_EYE_SPECULAR_ENABLE_ON)
        {
            float3 refDir = reflect(-viewDir, worldNormal);
            #if defined(_EYEREFROTAION_ON)
                refDir = mul(_Eye_RotationMVP,  float4(refDir, 1.0)).rgb;
            #endif
            
            #if defined(_CUBEMAPDIR_ENABLE_ON)
                refDir = mul(_CubeMapDirMvp,  float4(refDir, 1.0)).rgb;
            #endif
            float3 refColor = texCUBE(_Eye_CubeMap, refDir).rgb;

            //Print(refColor)
            //fixed4 refColor = texCUBE(_Eye_CubeMap, refDir);
            //refColor = Luminance(refColor);
            float3 spec = pow(refColor, _Eye_SpecPower) * _Eye_SpecStr;
            #if defined(_EYELUMINANCECOLOR_ON)
                //spec = Luminance(spec);
            #endif
            //spec *= refColor;
            //Print(spec)
            //final_Specular = spec;
            lightColor += (spec);
            //Print(spec)
        }
        #endif
    #endif

    final_Specular = specularTerm * lightColor * F;

    #if defined(_SECONDLIGHTENABLE_ON)
        {
            half3 lightDir = normalize(_SecondLightVector.xyz);
            half3 halfDir2 = Unity_SafeNormalize (lightDir + viewDir);
            half nl2 = saturate(dot(normal, lightDir));
            half nh2 = saturate(dot(normal, halfDir2));

            half lv2 = saturate(dot(lightDir, viewDir));
            half lh2 = saturate(dot(lightDir, halfDir2));
            half3 fresnelTerm2 = FresnelTerm (specColor, lh2);
            half specularTerm2 = SpecularTerm(/*out half3 */D, /*out half */V, /*half3 */specColor, nl2, nv, nh2, roughness, perceptualRoughness);
            specularTerm2 *= any(specColor) ? 1.0 : 0.0;
            half3 specular2 = specularTerm2 * lightColor * fresnelTerm2;

            //specular = lerp(specular, specular2, _SecondLightVector.w);
            final_Specular += specular2 * _SecondLightVector.w;
        }

        //return half4(specular,1);
    #endif

    #if defined(_ENABLE_CUBEMAP_ON)
        {
            //Print(gi.specular)
            //Print(1)
            //Print(gi.specular)
            //half3 refDir = normalize(reflect(-viewDir, worldNormal));
            //float3 refColor = texCUBE(_GI_CubeMap, refDir).rgb;
            //gi.specular = (refColor * occlusion*step(0.9, i.metallic));
            gi.specular *= step(0.8, i.metallic);
            //Print(i.metallic)
            //Print(gi.specular)
        }
    #endif
           

    half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
    half surfaceReduction = 1.0 / (roughness*roughness + 1.0);           // fade \in [0.5;1]
    final_GI = surfaceReduction;
    final_GI *= gi.specular;
    final_GI *= FresnelLerp (specColor, grazingTerm, nv);
#endif
//} 

// *************************************************************** Eye End ***************************************************************
/*#if defined(_EYE_ENABLE_ON)
{
    half3 refDir = reflect(-viewDir, worldNormal);
    float3 refColor = texCUBElod(_Eye_CubeMap, float4(refDir, 0.5 - 0.5*0.5)).rgb;
    //fixed4 refColor = texCUBE(_Eye_CubeMap, refDir);
    //refColor = Luminance(refColor);
    final_Specular = refColor;
}
#endif*/
// *************************************************************** Eye End ***************************************************************

// *************************************************************** Hair End ***************************************************************

    half3 diffuseTerm = DisneyDiffuse(nv, nl, lh, perceptualRoughness) * nl; 
    float3 skincolor = 0;
    float3 fesnelColor = 0;
    float3 ssscolor = 1;
    float3 finalSSSColor = 0;
    float fresnel;

// *************************************************************** SSS Start ***************************************************************
{ 

#if defined(_SSSTYPE_FRESNEL)

    float4 sssmask = tex2D(_FresnelSSSMask, uv);
    finalSSSColor = GetFresnelColor(normal, viewDir, sssmask.r);
    diffColor -= finalSSSColor;
        
    final_Diffuse = diffColor * (giDiffuse + light_color * diffuseTerm);

#elif defined(_SSSTYPE_CLOSESTPOINT)

    float _Wrap_Amount = _sssLerp;
    float3 _Wrap_Color = _ClosePointColor; 
    float3 Lighting;
    //Spherical lights implementation modified from http://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf - thanks guys! :D
    float3 L = lightDir;
    float3 closestPoint = L + normal * _Light_Size;
    float3 gi_lightDir = normalize(closestPoint);

    float sss_ndl = dot (normal, gi_lightDir);
    // nl
    half3 Surf1 = saturate(sss_ndl);//Calculate lighting the standard way (See Diffuse lighting mode's comments).
    half3 Surf2 = saturate(_Wrap_Amount + sss_ndl) * ( _Wrap_Amount - abs( sss_ndl) ) * _Wrap_Amount;//Calculate diffuse lighting while taking the Wrap Amount into consideration.
    Lighting =  Surf1 + Surf2*( _Wrap_Amount - abs( dot(normal, gi_lightDir)) ) * _Wrap_Amount * _Wrap_Color.rgb;//Combine the two lightings together, by adding the standard one with the wrapped one.
    //Lighting =  Surf1 ;
    Lighting *= light.color;
    diffuseTerm = Lighting;
//float fresnel2 = CalcFresnel(viewDir, halfDir, _Fresnel);
//Print(fresnel2)

//half3 rim = 1.0 - saturate(dot (normalize(viewDir), normal));
//Print(rim)
    final_Diffuse = diffColor * (giDiffuse + light.color * diffuseTerm);
    //finalSSSColor =  ssscolor;
#elif defined(_SSSTYPE_MOBA)

    skincolor = GetSkinColorMOBA(0, nl, 1, _sssMobaColor, _sssTransmittance, _sssIntensity, _sssFrontintensity, _sssBackintensity);
    diffColor = diffColor+skincolor;//CalcFresnel(normal, viewDir, _FresnelValue);
    final_Diffuse = diffColor * (giDiffuse  + light.color * diffuseTerm);

#elif defined(_SSSTYPE_LUT) || defined(_SSSTYPE_LUT_FRESNEL)

    fixed3 diffuseLight = 0;
           
    #if defined(_SSSCALTYPE_OFF)
         
        diffuseLight = diffuseTerm;
    #else

        fixed3 worldShapeBump = normal;

        worldShapeBump = normalize(worldShapeBump);
        //fixed3 worldShapeBump = normalize(float3(i.T2W0.z,i.T2W1.z,i.T2W2.z));

        #if defined(_SSSCALTYPE_CALU)
            float cuv = saturate(_SSSCurveFactor * (length(fwidth(worldShapeBump)) / length(fwidth(posWorld))));
        #elif defined(_SSSCALTYPE_TEX)
            float cuv = tex2D(_CurveTex, uv);
        #else
            float cuv = _SSSCurveFactor;
        #endif
        
        //return float4(cuv,cuv,cuv,1);
        fixed NoL = dot(worldShapeBump, lightDir);
        fixed3 diffuse = tex2D(_SSSLUT, float2(NoL * 0.5 + 0.5, cuv)) * _LUTScale;
         //return fixed4(NoL,NoL,NoL,1);
        //diffuseTerm = diffuse;
       
        //float3 ambient = giDiffuse; // UNITY_LIGHTMODEL_AMBIENT

        //fresnel = saturate(pow(1-dot(viewDir, normal), 6.0));
        //fresnel += _LUTFresnelPow * (1 - fresnel);
        
        #if defined(_SKINCHANNEL_ONE)
            diffuseLight = diffuse * atten;
        #elif defined(_SKINCHANNEL_ZERO)
            diffuseLight = diffuseTerm;
        #else
            diffuseLight = lerp(diffuseTerm, diffuse * atten, skinMask);
        #endif

        //Print(diffuse)
        
        //diffuse+=fresnel * float3(0.5,0,0);

        #if defined(_SSSTYPE_LUT_FRESNEL) && defined(_ENABLE_SSSFRESNEL_ON)
            float4 sssmask = tex2D(_FresnelSSSMask, uv);
            finalSSSColor = GetFresnelColor(normal, viewDir, sssmask.r);
            #if defined(_SKINCHANNEL_ONE)
                diffColor = diffColor - finalSSSColor;
            #elif defined(_SKINCHANNEL_ZERO)
                diffColor = diffColor;
            #else
                diffColor = lerp(diffColor, diffColor - finalSSSColor, skinMask);
            #endif
        #endif
    #endif
    

    
    final_Diffuse = diffColor * (giDiffuse + light_color * diffuseLight);
    //Print(final_Diffuse)
//Print(saturate(CalcFresnel(normal, viewDir, _LUTFresnelPow,5.0)))
    //final_Diffuse = diffColor * (q + light_color * diffuseTerm );
   
    //final_Diffuse +=fresnel;
    //Print(fresnel)
    //float rim = saturate(pow(1-dot(viewDir, s.BlurredNormals),_RimPower)) * fresnel;
    #if defined(_D_SSS_LUTDIFF)
        Print(diffuse)
    #endif
#elif defined(_SSSTYPE_NONE)
    final_Diffuse = diffColor * (giDiffuse + light_color * diffuseTerm);

#endif
    //final_Diffuse = diffColor * (giDiffuse + light_color * diffuseTerm);
// *************************************************************** SSS End ***************************************************************
}

// print NV NoL

#if defined(_DEBUG_PRINT_NV_ON)
    Print(nv);
#endif
#if defined(_DEBUG_PRINT_NL_ON)
    Print(nl);
#endif

// SSS
#if defined(_D_SSS_COLOR)
    Print(skincolor);
#endif
#if defined(_D_SSS_FESNELCOLOR)
    Print(fesnelColor);
#endif
#if defined(_D_SSS_FESNEL)
    Print(fresnel);
#endif
#if defined(_D_SSS_FINAL)
    Print(finalSSSColor);
#endif

//
// Debug SSS
// _CHECK_SSS_NONE _CHECK_SSS_DIFF  _CHECK_SSS_ONLYSKIN _CHECK_SSS_MASK _CHECK_SSS_FINAL
//
#if defined(_CHECK_SSS_MASK)
    Print(skinMask);
#endif

// Debug BRDF
#if defined(_D_BRDF_D)
    Print(D);
#endif
#if defined(_D_BRDF_F)
    Print(F);
#endif
#if defined(_D_BRDF_V)
    Print(V);
#endif

// Diffuse
#if defined(_D_BRDF_DIFFUSE_COLOR)
    Print(diffColor);
#endif
#if defined(_D_BRDF_DIFFUSE_TERM)
    Print(diffuseTerm);
#endif

#if defined(_D_BRDF_DIFFUSE_FINAL)
    Print(final_Diffuse);
#endif

//Specular
#if defined(_D_BRDF_SPECULAR_COLOR)
    Print(specColor);
#endif
#if defined(_D_BRDF_SPECULAR_FINAL)
    Print(final_Specular);
#endif

//GI
#if defined(_D_BRDF_GI_DIFFUSE)
    Print(gi.diffuse);
#endif
#if defined(_D_BRDF_GI_SPECULAR)
    Print(gi.specular);
#endif
#if defined(_D_BRDF_GI_FINAL)
    Print(final_GI);
#endif
    /*
        half grazingTerm = saturate(smoothness + (1-oneMinusReflectivity));
        half3 color = diffColor * (gi.diffuse + light.color * diffuseTerm)
                    + specularTerm * light.color * FresnelTerm (specColor, lh)
                    + surfaceReduction * gi.specular * FresnelLerp (specColor, grazingTerm, nv);
    */
    //final_Color += finalSSSColor;
    //final_Color += final_Diffuse;
    //final_Color += final_Specular;
    //final_Color += final_GI;
    //final_Color *= aoEnvirlocal_334;
     
    //final_Color += finalSSSColor;
    final_Color += final_Diffuse;
    final_Color += final_Specular;
    final_Color += final_GI;

#if defined(_DEBUG_ENABLE_FINAL_DIFFUSE_ON) || defined(_DEBUG_ENABLE_FINAL_DIFFUSE_ON) || defined(_DEBUG_ENABLE_FINAL_GI_ON)
    final_Color = 0;
#endif

#if defined(_DEBUG_ENABLE_FINAL_DIFFUSE_ON)
    final_Color += final_Diffuse;
#endif

#if defined(_DEBUG_ENABLE_FINAL_SPECULAR_ON)
    final_Color += final_Specular;
#endif

#if defined(_DEBUG_ENABLE_FINAL_GI_ON)
    final_Color += final_GI;
#endif
//#if UNITY_PASS_FORWARDADD
//     half3 color =   (diffColor * diffuseTerm + specularTerm * FresnelTerm (specColor, lh)) * light.color;
//    #else
return float4(final_Color, 1);
//#endif // UNITY_STANDARD_BRDF_INCLUDED

    //return half4(final_Color, 1);
}

#endif // UNITY_STANDARD_BRDF_INCLUDED


