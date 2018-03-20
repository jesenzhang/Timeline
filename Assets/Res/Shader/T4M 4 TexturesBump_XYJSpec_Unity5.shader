Shader "TAShaders/T4M 4 Textures Bump_XYJSpec" {
Properties {
	_CustomLightDir("自定义灯光方向", Vector) = (0.5,0.8,-0.25,0)
	_SpecColor ("Specular Color", Color) = (1,1,1,1)		
	_SpecLevel ("Specular Level", range (0,10)) = 2.0
	_SpecPower ("Specular Glossness", range (0.1, 10.0)) = 0.5
	_Splat0 ("Layer 1 (R)", 2D) = "white" {}
	_Splat1 ("Layer 2 (G)", 2D) = "white" {}
	_Splat2 ("Layer 3 (B)", 2D) = "white" {}
	_Splat3 ("Layer 4 (A)", 2D) = "white" {}
	_Tiling3("Layer 4_Tiling4 (XY)", Vector)=(1,1,0,0)
	_BumpSplat0 ("Layer1Normalmap", 2D) = "bump" {}
	_BumpSplat1 ("Layer2Normalmap", 2D) = "bump" {}
	_BumpSplat2 ("Layer3Normalmap", 2D) = "bump" {}
	_BumpSplat3 ("Layer4Normalmap", 2D) = "bump" {}
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
} 

SubShader {
	Tags {
		"SplatCount" = "4"
		"Queue" = "Geometry-100"
		"RenderType" = "Opaque"
	}
CGPROGRAM
#pragma surface surf Lambert noforwardadd 
//vertex:vert
#pragma target 3.0
//#pragma exclude_renderers gles xbox360 ps3
#include "UnityCG.cginc"

struct Input {
	float3 worldPos;
	float2 uv_Control : TEXCOORD0;
	float2 uv_Splat0 : TEXCOORD1;
	float2 uv_Splat1 : TEXCOORD2;
	float2 uv_Splat2 : TEXCOORD3;
	//float2 uv_Splat3 : TEXCOORD4;
	half3 viewDir;
};
/*
void vert (inout appdata_full v) {

	float3 T1 = float3(1, 0, 1);
	float3 Bi = cross(T1, v.normal);
	float3 newTangent = cross(v.normal, Bi);
	
	normalize(newTangent);

	v.tangent.xyz = newTangent.xyz;
	
	if (dot(cross(v.normal,newTangent),Bi) < 0)
		v.tangent.w = -1.0f;
	else
		v.tangent.w = 1.0f;
}
*/
sampler2D _Control;
sampler2D _BumpSplat0, _BumpSplat1, _BumpSplat2, _BumpSplat3;
sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
half4 _CustomLightDir;
half _SpecPower;
half _SpecLevel;
float4 _Tiling3;

void surf (Input IN, inout SurfaceOutput o) {

	half4 splat_control = tex2D (_Control, IN.uv_Control);
	half4 col;
	half4 splat0 = tex2D (_Splat0, IN.uv_Splat0);
	half4 splat1 = tex2D (_Splat1, IN.uv_Splat1);
	half4 splat2 = tex2D (_Splat2, IN.uv_Splat2);
	half4 splat3 = tex2D (_Splat3, IN.uv_Control*_Tiling3.xy);
	
	col  = splat_control.r * splat0;
	o.Normal = splat_control.r * UnpackNormal(tex2D(_BumpSplat0, IN.uv_Splat0));
	
	col += splat_control.g * splat1;
	o.Normal += splat_control.g * UnpackNormal(tex2D(_BumpSplat1, IN.uv_Splat1));
	
	col += splat_control.b * splat2;
	o.Normal += splat_control.b * UnpackNormal(tex2D(_BumpSplat2, IN.uv_Splat2));
	
	col += splat_control.a * splat3;
	o.Normal += splat_control.a * UnpackNormal(tex2D(_BumpSplat3, IN.uv_Control*_Tiling3.xy));

	fixed3 h = normalize (_CustomLightDir.xyz + IN.viewDir);
	fixed nh = max (0.001f, dot (o.Normal, h));
	fixed4 SpecCol = pow(nh * col.a * _SpecLevel, _SpecPower) * _SpecColor;

	o.Albedo = col.rgb + SpecCol.rgb;
	o.Alpha = 0.0;
}
ENDCG  
}
FallBack "Diffuse"
}
