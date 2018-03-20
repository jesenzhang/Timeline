// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "Weather/Simple/Diffuse" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}  
	[KeywordEnum(Disable,Enable)]_Rain("Enable Rain Effect",float) = 1 
    [KeywordEnum(Disable,Enable)]_Bolt("Enable Bolt Effect",float) = 1 
	_WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
	_SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1 
	_SnowPower ("Snow Power", Range(3,20)) = 10 
	_Distort("Rain Wave Distort",Range(0,40)) = 1 
	_RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
	_BoltMulitplier("Bolt Multiplier",Range(0,1)) = 0.1
}

	CGINCLUDE
		#include "../Common/weather-simple.cginc"

		sampler2D _MainTex;  

		struct Input {
			float2 uv_MainTex; 
			float3 worldNormal; 
			float weatherAmount;
			float temperature;
		};

		DECLARE_WEATHER_VERTEX_FUNC(snow)

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 col = tex2D(_MainTex, IN.uv_MainTex);  
			APPLY_SIMPLE_WEATHER_SURFACE_EFFECT(IN,col);
			o.Albedo = col.rgb;
			o.Alpha = col.a; 
			//o.Smoothness = 0.5;

		}

	ENDCG 

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 150

		CGPROGRAM
			#pragma surface surf Lambert vertex:snow  
			#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE 
			#pragma target 2.0 
			 
		ENDCG
	}
 

Fallback "Mobile/Diffuse"
}
