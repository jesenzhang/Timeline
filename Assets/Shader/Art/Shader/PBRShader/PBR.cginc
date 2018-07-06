#ifndef PBR_CGINC
#define PBR_CGINC

#include "UnityStandardCoreForward.cginc"
#include "PBRInput.cginc"


#ifndef UNITY_BRDF_PBS_CUSTOM

#include "PBRBRDF_CARTON.cginc"
#define UNITY_BRDF_PBS_CUSTOM BRDF_MOBA
#else
#endif

/*
#if defined(_BRDF_TYPE_SHENDU)
#include "PBRBRDF_SD.cginc"
#define UNITY_BRDF_PBS_CUSTOM BRDF_SD
#elif defined(_BRDF_TYPE_MOBA)
#include "PBRBRDF_MOBA.cginc"
#define UNITY_BRDF_PBS_CUSTOM BRDF_MOBA
#elif defined(_BRDF_TYPE_UNITY)
#include "PBRBRDF_UNITY.cginc"
#define UNITY_BRDF_PBS_CUSTOM BRDF_UNITY
#endif
#endif
*/

#include "PBRBRDF.cginc"
#include "PBRCore.cginc"

#define _DETAIL_ADD 1

#ifndef CHANCE_METALLIC
#define CHANCE_METALLIC X
#endif

#ifndef CHANCE_GLOSS
#define CHANCE_GLOSS Z
#endif

#define CORE_CUSTOM 1


//#if CORE_CUSTOM
VertexOutputForwardBaseCustom vertCustom (VertexInput v) { return vertForwardBaseCustom(v); }
fixed4 fragCustom (VertexOutputForwardBaseCustom i) : SV_Target { return fragForwardBaseCustom(i); }
VertexOutputForwardAddCustom vertAddCustom (VertexInput v) { return vertForwardAddCustom(v); }
fixed4 fragAddCustom (VertexOutputForwardAddCustom i) : SV_Target { return fragForwardAddCustom(i);}

#endif
