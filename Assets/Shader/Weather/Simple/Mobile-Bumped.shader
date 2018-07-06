// Simplified Bumped shader. Differences from regular Bumped one:
// - no Main Color
// - Normalmap uses Tiling/Offset of the Base texture
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.
Shader "Weather/Simple/Bumped Diffuse" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_BumpMap ("Bump Map (RGB)", 2D) = "bump" {}
	[KeywordEnum(Disable,Enable)]_Rain("Eanble Rain Effect",float) = 1 
	_WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
	_SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1 
    _SnowPower ("Snow Power", Range(8,20)) = 10
    _RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
    _Distort("Rain Wave Distort",Range(0,40)) = 1 
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

	CGPROGRAM
	#pragma surface surf Lambert noforwardadd vertex:snow
	#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE 
	#pragma target 2.0 
	#include "../Common/weather-simple.cginc"

	sampler2D _MainTex;
	sampler2D _BumpMap;
	 

	struct Input {
		float2 uv_MainTex;  
		float3 worldNormal;INTERNAL_DATA 
		float weatherAmount;
		float temperature;
	};

	DECLARE_WEATHER_VERTEX_FUNC(snow)

	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 col = tex2D(_MainTex, IN.uv_MainTex); 
		o.Alpha = col.a;
		o.Normal = UnpackNormal(tex2D(_BumpMap,IN.uv_MainTex));
		APPLY_SIMPLE_WEATHER_SURFACE_NORMAL_EFFECT(IN,col);
		o.Albedo = col.rgb;

	}
	ENDCG
}

Fallback "Mobile/Bumped Diffuse"
}
