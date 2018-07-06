#ifndef PBRBRDF_CGINC
#define PBRBRDF_CGINC

#include "UnityCG.cginc"
#include "UnityStandardBRDF.cginc"
#include "UnityStandardBRDFDouble.cginc"
#include "PBRInput.cginc"

#define PI        0.31830988618f

float4 ReturnFloat(float f)
{
    return float4(f,f,f,1);
}
float4 ReturnFloat(float f1,float f2,float f3)
{
    return float4(f1,f2,f3,1);
}
float4 ReturnFloat(float3 f)
{
    return float4(f,1);
}
float4 ReturnFloat(float4 f)
{
    return float4(f);
}

#if defined (_DEBUG_RETURN_ON)
#define Print(a)  return ReturnFloat(a);
#else
#define Print(a) return ReturnFloat(a);
#endif

#define DebugKeyword(key, printValue) \n#if defined(key) \n Print(printValue); \n #endif

/*
#if defined (_DEBUG_ALAPHA_ON)

float _Debug_Alapha_Float;
float _DebugAlapha(float f)
{
    if(f*100 > _Debug_Alapha_Float){
        return 0;
    } else{
        return 1;
    }
}
    #define DebugAlapha(f)  Print(_DebugAlapha(f));
#else
float _DebugAlapha(float f)
{
    return f;
}
#define DebugAlapha(f);

#endif
*/

//#define Print(a)  return ReturnFloat(a);

////////////////////////////////////////////// 
///
///        Vis 遮蔽函数
///
//////////////////////////////////////////////

// Unreal
/*float Vis_SmithJointApprox( float Roughness, float NoV, float NoL )
{
    float a = Roughness*Roughness;//Square( Roughness );
    float Vis_SmithV = NoL * ( NoV * ( 1 - a ) + a );
    float Vis_SmithL = NoV * ( NoL * ( 1 - a ) + a );
    // Note: will generate NaNs with Roughness = 0.  MinRoughness is used to prevent this
    return 0.5 * rcp( Vis_SmithV + Vis_SmithL );
}
*/
// Vis_Schlick
float Vis_Schlick(float Roughness, float NoV,float NoL , float NoH)
{
    float k = ( Roughness * Roughness ) * 0.5;
    float Vis_SchlickV = NoV * (1.0 - k) + k;
    float Vis_SchlickL = NoL * (1.0 - k) + k;
    return 0.25 / ( Vis_SchlickV * Vis_SchlickL );
}

// Ref: http://jcgt.org/published/0003/02/03/paper.pdf
// moba
inline half Vis_Unity/*SmithJointGGXVisibilityTermCustom*/ (half NdotL, half NdotV, half roughness)
{
#if 0
    // Original formulation:
    //  lambda_v    = (-1 + sqrt(a2 * (1 - NdotL2) / NdotL2 + 1)) * 0.5f;
    //  lambda_l    = (-1 + sqrt(a2 * (1 - NdotV2) / NdotV2 + 1)) * 0.5f;
    //  G           = 1 / (1 + lambda_v + lambda_l);
    // Reorder code to be more optimal
    half a          = roughness * roughness;

    half Vis_SmithV    = NdotL * sqrt((-NdotV * a + NdotV) * NdotV + a);
    half Vis_SmithL    = NdotV * sqrt((-NdotL * a + NdotL) * NdotL + a);

    // Simplify visibility term: (2.0f * NdotL * NdotV) /  ((4.0f * NdotL * NdotV) * (lambda_v + lambda_l + 1e-5f));
    return 0.5f / (Vis_SmithV + Vis_SmithL + 1e-5f);  // This function is not intended to be running on Mobile,
                                                // therefore epsilon is smaller than can be represented by half
#else
    // Approximation of the above formulation (simplify the sqrt, not mathematically correct but close enough)
    half a = roughness;
    half lambdaV = NdotL * (NdotV * (1 - a) + a);
    half lambdaL = NdotV * (NdotL * (1 - a) + a);

    return 0.5f / (lambdaV + lambdaL + 1e-5f);
#endif
}

////////////////////////////////////////////// 
///
///        D 微表面分布函数
///
//////////////////////////////////////////////

// GGXTerm
inline half Get_GGX_D(half nh, half rough)
{
    half a2 = rough * rough;
    half d = nh * nh * (a2 - 1.h) + 1.00001h;
    half d2 = a2 / (d * d );
    return UNITY_INV_PI * d2;
}

inline half GGXTermCustom (half NdotH, half roughness)
{
    half a2 = roughness * roughness;
    half d = (NdotH * a2 - NdotH) * NdotH + 1.0f; // 2 mad
    return UNITY_INV_PI * a2 / (d * d + 1e-7f); // This function is not intended to be running on Mobile,
                                            // therefore epsilon is smaller than what can be represented by half
}

// unreal 
// [Burley 2012, "Physically-Based Shading at Disney"]
float D_GGXanisoUnreal( float RoughnessX, float RoughnessY, float NoH, float3 H, float3 X, float3 Y )
{
    float ax = RoughnessX * RoughnessX;
    float ay = RoughnessY * RoughnessY;
    float XoH = dot( X, H );
    float YoH = dot( Y, H );
    float d = XoH*XoH / (ax*ax) + YoH*YoH / (ay*ay) + NoH*NoH;
    return 1 / ( PI * ax*ay * d*d );
}

// sd D_GGXaniso(anisoCtrl.x,anisoCtrl.y,NoH,H,T,B) 
// Anisotropic GGX
// [Burley 2012, "Physically-Based Shading at Disney"]
float D_GGXanisoSD(float RoughnessX, float RoughnessY, float NoH, float3 H, float3 t_x, float3 b_y)
{
    float mx = RoughnessX * RoughnessX;
    float my = RoughnessY * RoughnessY;
    float XoH = dot( t_x, H );
    float YoH = dot( b_y, H );
    float d = XoH*XoH / (mx*mx) + YoH*YoH / (my*my) + NoH*NoH;
    return 1.0 / ( mx*my * d*d );
}

inline half3 GetFresnel (half3 F0/*speColor*/, half cosA/*VoH*/)
{
    half t = Pow5 (1 - cosA);   // ala Schlick interpoliation
    return F0 + (1-F0) * t;
}

//Linear Space Lighting
float Luminance2(float3 color)
{
    return dot(color,float3(0.2526,0.7152,0.07222));
}
/*
// Unity
// Converts color to luminance (grayscale)
float Luminance( vec3 c )
{
    // Legacy: alpha is set to 0.0 to specify gamma mode
    23: #define unity_ColorSpaceLuminance half4(0.22, 0.707, 0.071, 0.0) 
    // Legacy: alpha is set to 1.0 to specify linear mode
    28: #define unity_ColorSpaceLuminance half4(0.0396819152, 0.458021790, 0.00609653955, 1.0)
    return dot(rgb, unity_ColorSpaceLuminance.rgb);
}
// Converts color to luminance (grayscale)
inline half Luminance(half3 rgb)
{
    return dot(rgb, unity_ColorSpaceLuminance.rgb);
}
// Unity
half LinearRgbToLuminance(half3 linearRgb)
{
    return dot(linearRgb, half3(0.2126729f,  0.7151522f, 0.0721750f));
}


FTwoBandSHVector GetLuminance(FTwoBandSHVectorRGB InRGBVector)
{
    FTwoBandSHVector Out;
    Out.V = InRGBVector.R.V * 0.3f + InRGBVector.G.V * 0.59f + InRGBVector.B.V * 0.11f;
    return Out;
}
MaterialFloat Luminance( MaterialFloat3 LinearColor )
{
    return dot( LinearColor, MaterialFloat3( 0.3, 0.59, 0.11 ) );
}
*/

////////////////////////////////////////////// 
///
///        F 
///
//////////////////////////////////////////////


half3 F_Schlick( half3 SpecularColor, float VoH )
{
    float Fc = 1.0 - VoH;
    Fc *= Fc;
    Fc *= Fc;
    return SpecularColor + (1.0 - SpecularColor) * Fc;
}

float Get_GGX_D_Aniso(float RoughnessX, float RoughnessY, float NoH, float3 H, float3 T, float3 B)
{
    float a2x = RoughnessX * RoughnessX;
    float a2y = RoughnessY * RoughnessY;

    float XoH = dot( T, H );
    float YoH = dot( B, H );

    float d = XoH*XoH / (a2x*a2x) + YoH*YoH / (a2y*a2y) + NoH*NoH;
    return 1.0 / ( a2x*a2y * d*d );
}
////////////////////////////////////////////// 
///
///        F 
///
//////////////////////////////////////////////
/// Unity
half DisneyDiffuseCustom(half NdotV, half NdotL, half LdotH, half perceptualRoughness)
{
    half fd90 = 0.5 + 2 * LdotH * LdotH * perceptualRoughness;
    // Two schlick fresnel term
    half lightScatter   = (1 + (fd90 - 1) * Pow5(1 - NdotL));
    half viewScatter    = (1 + (fd90 - 1) * Pow5(1 - NdotV));

    return lightScatter * viewScatter;
}



float3 GetSkinColor(float nl, float ndl_without_clamp, float mask, float3 sss_diffuse, float sss_transmittance, float sss_intensity, float sss_frontintensity, float sss_backintensity)
{
    float ndl_wrap = (ndl_without_clamp + sss_transmittance) / sss_transmittance;

    // GPU Gems Chapter 16
    // float scatter = mix(0.0, sss_intensity, ndl_wrap) * mix(sss_intensity * 2.0, sss_intensity, ndl_wrap);
    float2 scatter_args = lerp(float2(0.0, sss_intensity * 2.0), float2(sss_intensity, sss_intensity), ndl_wrap);

    float3 args = float3(nl, scatter_args.x, step(ndl_without_clamp, 0.0) * ndl_without_clamp);
    args *= float3(sss_frontintensity, scatter_args.y, sss_backintensity);

    float tmp = args.y - args.z;
    return lerp(float3(nl, nl, nl), tmp * sss_diffuse + args.x, mask);
}

/*float3 GetSkinColor(float nl, float nl_without_clamp, float mask)
{
    return GetSkinColor(nl, nl_without_clamp, mask, _sssMobaColor, _sssTransmittance, _sssIntensity, _sssFrontintensity, _sssBackintensity);
}*/

float4 AnisotropicSpecular(float3 normal, float3 tangent, float3 lightvec, float3 eyevec, float4 glossiness)
{
    normal = normalize(normal); // Actually the tangent!
    tangent = normalize(tangent);   // Actually the tangent!
    lightvec = normalize(lightvec);
    eyevec = normalize(eyevec);
    
    float3 halfvector = normalize(eyevec+lightvec); //add eye and light together for half vector (Blinn)
    
    float4 specular;
    specular = sqrt( 1 - pow(dot(halfvector, tangent),2) ); // root(1 - (half dot tangent)^2) is anisotropic specular
    
    specular = float4( pow(specular.r, glossiness.r),pow(specular.g, glossiness.g), pow(specular.b, glossiness.b), pow(specular.a, glossiness.a)); //power specular to glossiness to sharpen highlight
    
    specular *= dot(normal, lightvec); // Bias the anisotropic spec using lambert term so it's only directly lit faces that get it
    
    return saturate(specular);
    
}

float3 Speuclar(float3 specularColor, float roughness, float NoH, float NoV, float NoL, float VoH,float3 H,float3 T, float3 B,float3 anisoCtrl)
{
    return D_GGXanisoSD(anisoCtrl.x,anisoCtrl.y,NoH,H,T,B) * F_Schlick(specularColor,VoH) * anisoCtrl.z;
}

float3 GetBRDFSpecular(float3 specularColor, float roughness, float NoH, float NoV, float NoL, float VoH,float3 H,float3 T,float3 B,float3 anisoCtrl)
{
    return Speuclar(specularColor,roughness,NoH,NoV,NoL,VoH,H,T,B,anisoCtrl) ;
}

float3 GetDiffuseColor(float3 baseColor, float metallic)
{
    return lerp(baseColor, 0, metallic);
}

float3 GetSpecularColor(float3 baseColor, float metallic)
{
    //#define unity_ColorSpaceDielectricSpec half4(0.220916301, 0.220916301, 0.220916301, 1.0 - 0.220916301) liner space
    return lerp(unity_ColorSpaceDielectricSpec, baseColor, metallic);
}

inline float CalcFresnel(float3 normal, float3 v, float fresnelValue, float fresnelPow)
{
    float fresnel = pow(1.0 - dot(normal, v), fresnelPow);
    fresnel += fresnelValue * (1.0 - fresnel);
    return fresnel;
}
float3 ShiftTangent (float3 T, float3 N, float shift)
{
    float3 shiftedT = T + shift * N;
    return normalize (shiftedT);
}

float StrandSpecular (float3 T, float3 V,float3 L, float exponent)
{
    float3 H = normalize(L + V);
    float dotTH = dot(T, H);
    float sinTH = sqrt(1.0 - dotTH*dotTH);
    float dirAtten = smoothstep(-1.0, 0.0,dotTH);
    return dirAtten * pow(sinTH, exponent);
}

#if defined(_ENABLEDEBUGCOLOR_ON)
#define MakeDebugColorParm(X)  float3 debugColor##X; float debugColorR##X; float debugColorG##X;
MakeDebugColorParm(1)
MakeDebugColorParm(2)
MakeDebugColorParm(3)
MakeDebugColorParm(4)
MakeDebugColorParm(5)
MakeDebugColorParm(6)
MakeDebugColorParm(7)
MakeDebugColorParm(8)
MakeDebugColorParm(9)
MakeDebugColorParm(10)

int Eq(float3 a, float3 b)
{
    //if(abs(a.x - (b.x))<= 1/255.0)
    if((abs(a.x - b.x)<= 0.2)
        &&(abs(a.y - b.y)<= 0.2)
        &&(abs(a.z - b.z)<= 0.2)
        )
    {  
        //printf("a 等于 b\n");  
        return 1;
    } 
    return 0;
}

#define DebugColorEq(X) if (Eq(debugColorTex,debugColor##X)>0) {dirtionMapX = debugColorR##X; dirtionMapY = debugColorG##X;}


sampler2D _debugColorTex;
#endif


inline float GetAnisoMOBA(half3 halfDir, half3 N, half3 B, half3 T, half2 uv)
{
#if defined(_ENABLEDEBUGCOLOR_ON)
    float3 normalTex = tex2D(_ansioMask, uv).xyz;

    float dirtionMapX = normalTex.x;
    float dirtionMapY = normalTex.y;


    float3 debugColorTex = tex2D(_debugColorTex, uv).xyz;
    
DebugColorEq(1)
DebugColorEq(2)
DebugColorEq(3)
DebugColorEq(4)
DebugColorEq(5)
DebugColorEq(6)
DebugColorEq(7)
DebugColorEq(8)
DebugColorEq(9)
DebugColorEq(10)
 
   
    dirtionMapX= (dirtionMapX - 0.5) * 2;
    dirtionMapY= (dirtionMapY - 0.5) * 2;

    float3 X = T * dirtionMapX;
    float3 Y = B * dirtionMapY;
    float3 Z = N * ((normalTex.z - 0.5) *_ansioNoiseOffset + _ansioNormalOffset);
    float3 newNormal = normalize(X + Y + Z); 

    float HdotA = clamp(dot(newNormal, halfDir), 0, 1); 
    // [0pi~1pi = 0-1-0] 也就是说 HdotA为0.5时最亮
    float nh = sin(HdotA * 3.141593); // 

    return nh;

#else
    //viewDir = half3(0,0,1);
    //“切空间下的x轴和y轴就是顶点所在uv坐标系下的u轴和v轴” tangent（对应x）, binormal(对应y)和normal(对应z)
    float4 normalTex = tex2D(_ansioMask, uv);
    //normalTex = pow(normalTex, 1/2.2);
    float4 normalTexlocal_458 = (normalTex - 0.5) * 2; // 转到 [0,1] to [-1,1]
    float3 X = T * normalTexlocal_458.x;
    float3 Y = B * normalTexlocal_458.y;
    float3 Z = N * ((normalTex.z - 0.5) * _ansioNoiseOffset + _ansioNormalOffset);
    float3 newNormal = normalize(X + Y + Z); //local_466
    float HdotA = clamp(dot(newNormal, halfDir),0,1); //T3Dotlocal_267
    float nh = max(0, sin(HdotA * 3.141593)); // local_482
    return nh;
#endif
}

half3 GetSSSShadow(float3 diffuse)
{
    float m1 = max(diffuse.x, diffuse.y);
    float m = max(m1, diffuse.z - 0.39f);// ;
    //return m;
    //return diffuse - max(m, 0.1);
    return clamp(diffuse - max(m, 0.1), 0.0, 1.0);
}

/*float3 GetSkinColorMOBA(float nl, float ndl_without_clamp, float mask, float3 sss_diffuse, float sss_transmittance, float sss_intensity, float sss_frontintensity, float sss_backintensity)
{
    float ndl_wrap = (ndl_without_clamp + sss_transmittance) / sss_transmittance;

    // GPU Gems Chapter 16
    // float scatter = mix(0.0, sss_intensity, ndl_wrap) * mix(sss_intensity * 2.0, sss_intensity, ndl_wrap);
    float2 scatter_args = lerp(float2(0.0, sss_intensity * 2.0), float2(sss_intensity, sss_intensity), ndl_wrap);

    float3 args = float3(nl, scatter_args.x, step(ndl_without_clamp, 0.0) * ndl_without_clamp);
    args *= float3(sss_frontintensity, scatter_args.y, sss_backintensity);

    float tmp = args.y - args.z;
    return lerp(float3(nl, nl, nl), tmp * sss_diffuse + args.x, mask);
}
*/
/*
float3 GetSkinColorMOBA2(float nl, float ndl_without_clamp)
{
    float ndl_wrap = (ndl_without_clamp + _sssTransmittance) / _sssTransmittance;
    // GPU Gems Chapter 16
    // float scatter = mix(0.0, sss_intensity, ndl_wrap) * mix(sss_intensity * 2.0, sss_intensity, ndl_wrap);
    float2 scatter = lerp(float2(0.0, _sssIntensity * 2.0), _sssIntensity, ndl_wrap);

    float3 args = float3(nl, scatter.x, step(ndl_without_clamp, 0.0) * ndl_without_clamp);
    args *= float3(_sssFrontintensity, scatter.y, _sssBackintensity);

    float tmp = args.y - args.z;
    return tmp * _sssColor + args.x;
}*/

float3 GetSkinColorMOBA(float nl, float ndl_without_clamp, float mask, float3 sss_diffuse, float sss_transmittance, float sss_intensity, float sss_frontintensity, float sss_backintensity)
{
    float ndl_wrap = (ndl_without_clamp + sss_transmittance) / sss_transmittance;

    // GPU Gems Chapter 16
    // float scatter = mix(0.0, sss_intensity, ndl_wrap) * mix(sss_intensity * 2.0, sss_intensity, ndl_wrap);
    float2 scatter_args = lerp(float2(0.0, sss_intensity * 2.0), float2(sss_intensity, sss_intensity), ndl_wrap);

    float3 args = float3(nl, scatter_args.x, step(ndl_without_clamp, 0.0) * ndl_without_clamp);
    args *= float3(sss_frontintensity, scatter_args.y, sss_backintensity);

    float tmp = args.y - args.z;
    return lerp(float3(nl, nl, nl), tmp * sss_diffuse + args.x, 1);
}

#if defined(_SSSTYPE_MOBA)
float3 GetSkinColorMOBA(float ndl, float ndl_without_clamp)
{
    //return GetSkinColorMOBA(ndl, ndl_without_clamp, 1, _sssColor, _sssTransmittance, _sssIntensity, _sssFrontintensity, _sssBackintensity);
    //([0,0.5,1],1)/1 = [3/1, 1.5/1, 2/1] [1,1.5,2]
    //([0,0.5,1],2)/2 = [3/1, 2.5/2, 3/2] [1,2.5,1.5]
    //([0,0.5,1],3)/3 = [3/1, 3.5/3, 4/3] [1,3.5,1.3]

    float ndl_wrap = (ndl_without_clamp + _sssTransmittance) / _sssTransmittance;
    // GPU Gems Chapter 16
    // float scatter = mix(0.0, sss_intensity, ndl_wrap) * mix(sss_intensity * 2.0, sss_intensity, ndl_wrap);
  
    float x = ndl * _sssFrontintensity;
    float y = lerp(0.0, _sssIntensity, ndl_wrap) * lerp(_sssIntensity * 2.0, _sssIntensity, ndl_wrap);
    float z = step(ndl_without_clamp, 0.0) * ndl_without_clamp * _sssBackintensity;

    float tmp = y - z;
    return tmp * _sssMobaColor + x;
}
#endif
half4 GetEnvirmentColor_panorama(half3 viewDir, half3 normal, half smoothness)
{
    #if defined(_ENABLE_ENVIRONMENT_ON) 
        float lod = smoothness / 0.14;
        half3 ref = reflect(-(normalize(viewDir)), normal);//normalize(reflect(viewDir, normal));
        float at2 = atan2(ref.z, ref.x) + 3.141593;
        half2 refUV = half2(at2 * 0.1591549, acos(ref.y) * 0.3183099);
        float3 R = reflect(-viewDir, normal);
        half4 tex = tex2Dlod(_EnvironmentTex, half4(refUV, 0,lod));
        return tex * _max_brightness;
    #else
        return UNITY_LIGHTMODEL_AMBIENT;
    #endif
}

// Function G_Schlick_Disney Begin
float G_Schlick_Disney_MOBA(float NoLlocal_282 , float NoVlocal_279, float rough_local_437) 
{
    float local_534 = 0.5 + 0.5 * rough_local_437;
    float local_536 = 0.5 + 0.5 * rough_local_437;
    float k = local_534 * local_536;
    float Vis_SchlickV = NoVlocal_279 * (1.0 - k) + k;
    float Vis_SchlickL = NoLlocal_282 * (1.0 - k) + k;
    float local_530 = 0.25 / (Vis_SchlickV * Vis_SchlickL);
    return local_530;
}

// moba
float MOBA_D_GGX(half NH, half roughness) 
{
    half a = roughness * roughness;
    half a2 = a * a;
    half d = (NH * a2 - NH) * NH + 1.00001h;
    return min(a2 / ( d * d ), 10000.0);
}

// moba
float GGXTermMoba(half NH, half roughness) 
{
    half a2 = roughness * roughness;
    half d = (NH * a2 - NH) * NH + 1.00001h;
    return min(a2 / ( d * d ), 10000.0) * UNITY_INV_PI;
}

// same Pow5
float SG(float cosA, float p)
{
    float e = p * 1.442695 + 1.089235;
    // exp2(x): 2的x次方， log2(x):
    float  T = exp2(e * cosA - e);
    return T;
}

// moba
inline half3 F_SchlickMoba(half3 F0, half cosA) 
{
    float T = SG(1 - cosA, 5);
    return F0 + (1.0 - F0) * T;
}
float3 EnvBRDFApprox(float3 SpecularColor, float Roughness, float NoV)
{
    float envir_fresnel_brightness = 0;//0.3;
    // [ Lazarov 2013, "Getting More Physical in Call of Duty: Black Ops II" ]
    // Adaptation to fit our G term.
    float4 c0 = float4(-1.0, -0.0275, -0.572, 0.022);
    float4 c1 = float4(1.0, 0.0425, 1.04, -0.04);
    float4 r = c0 * Roughness + c1;
    float a004 = min( r.x * r.x, exp2( -9.28 * NoV ) ) * r.x + r.y;
    float2 AB = float2( -1.04, 1.04 ) * a004 + r.zw;

    return max(SpecularColor * AB.x + float3(AB.yyy+envir_fresnel_brightness), 0.0001);
}

#if defined(_SSSTYPE_FRESNEL) || defined(_SSSTYPE_LUT_FRESNEL)
half3 GetFresnelDiffuseColor(half3 normal, half3 viewDir, half2 uv, half3 diffColor)
{
    float _fresnel_Scale = _FresnelScale;

    float4 sssmask = tex2D(_FresnelSSSMask, uv);
    //float fresnel = CalcFresnel(normal, viewDir, 1, _FresnelPow);
    float3 _fresnel_color = _FresnelColor1.rgb;

    //float3 finalSSSColor = _FresnelColor1 * fresnel * _fresnel_Scale;
    
    float fresnelNDotV158 = dot(normal, viewDir);
    float fresnelNode158 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNDotV158, _FresnelPow ) );
    fresnelNode158 += _FresnelValue * (1.0 - fresnelNode158);

    //return float3(fresnelNode158,fresnelNode158,fresnelNode158);
    float2 uv_face_mask = uv;
    float3 lerpResult170 = lerp(float3(0,0,0), (_fresnel_color * fresnelNode158 * _fresnel_Scale), tex2D( _FresnelSSSMask, uv ).r);
    float3 ret = max((lerpResult170 ), float3(0,0,0)).rgb;
    return ret;
}

half3 GetFresnelColor(half3 normal, half3 viewDir, float sssmask)
{
    float _fresnel_Scale = _FresnelScale;

    float fresnel = clamp(CalcFresnel(normal, viewDir, _FresnelValue, _FresnelPow), 0, 0.8) ;
    float3 fresnelColorLerp = lerp(1 -_FresnelColor1, 1 - _FresnelColor2, fresnel);
    //Print(fresnelColorLerp)
    float3 finalSSSColor = lerp(0, fresnelColorLerp * fresnel * _fresnel_Scale, sssmask);
    return finalSSSColor;
}
#endif 


half3 EmissionCustom(float2 uv)
{
#if defined(_ENABLE_EMISSION_ON)
    return tex2D(_EmissionMap, uv).rgb * _EmissionColor.rgb;
#else
    return 0;
#endif
}

#endif // UNITY_STANDARD_BRDF_INCLUDED


