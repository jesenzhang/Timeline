Shader "Weather/Bumped Specular" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	[KeywordEnum(Disable,Enable)]_UseNormal("是否使用法线", Float) = 0
	_BumpMap ("Normalmap", 2D) = "bump" {}
	[KeywordEnum(Disable,Enable)]_Rain("Enable Rain Effect",float) = 1 
    [KeywordEnum(Disable,Enable)]_Bolt("Enable Bolt Effect",float) = 1 
	_WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
	_SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1 
    _SnowPower ("Snow Power", Range(8,20)) = 10
    _Distort("Rain Wave Distort",Range(0,40)) = 1 
    _RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
    _BoltMulitplier("Bolt Multiplier",Range(0,1)) = 0.1
}

	CGINCLUDE
	#include "../Common/weather.cginc"

	sampler2D _MainTex;
	sampler2D _BumpMap;
	fixed4 _Color;
	float _Shininess;

	struct Input {
		float2 uv_MainTex;  
		float3 worldNormal;INTERNAL_DATA 
		float3 viewDir;
		float4 bumpCoords ;  
		float3 worldPos;  
	#if (SHADER_TARGET >= 30)
		fixed temperature;
	#endif
	};

	DECLARE_WEATHER_VERTEX_FUNC(snow)

	void surf (Input IN, inout SurfaceOutput o) {
		fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);  
		o.Alpha = tex.a * _Color.a;
		 
		o.Gloss = tex.a;
		#if defined (SHADER_API_MOBILE)
		o.Specular = _Shininess / 2;
		#else
		o.Specular = _Shininess;
		#endif
		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));   

		fixed3 col = tex.rgb * _Color.rgb;

		APPLY_WEATHER_SURFACE_EFFECT(IN,col);

		o.Albedo = col;
	}
	ENDCG

SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
	CGPROGRAM
	#pragma surface surf BlinnPhong vertex:snow  
	#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE 
	#pragma target 2.0  
	ENDCG
} 

FallBack "Mobile/Diffuse"
}
