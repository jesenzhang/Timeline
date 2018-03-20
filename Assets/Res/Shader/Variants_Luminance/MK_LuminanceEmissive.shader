// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "MK/Glow/Luminance/Emissive" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_MKGlowColor ("Glow Color", Color) = (1,1,1,1)
		_MKGlowPower ("Glow Power", Float) = 1.0
		_MKGlowTex ("Glow Texture", 2D) = "black" {}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 2.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_MKGlowTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		sampler2D _MKGlowTex;
		half _MKGlowPower;
		fixed4 _MKGlowColor;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 g = tex2D (_MKGlowTex, IN.uv_MKGlowTex) * _MKGlowColor * _MKGlowPower;
			c.rgb += g.rgb;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
