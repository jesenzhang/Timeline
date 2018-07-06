Shader "Weather/Terrain Bump" {
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
	_BumpDefault ("Layer4Normalmap", 2D) = "bump" {} 
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "bump" {}
	[KeywordEnum(Disable,Enable)]_Rain("Eanble Rain Effect",float) = 1  
	_WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
	_SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1
	_SnowPower ("Snow Power", Range(3,20)) = 9.08
	_Distort("Rain Wave Distort",Range(0,40)) = 1 
	_RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
	_BoltMulitplier("Bolt Multiplier",Range(0,1)) = 0.1
}

	CGINCLUDE
		#include "UnityCG.cginc" 
		#include "../Common/weather.cginc"

		struct Input { 
			float2 uv_Control : TEXCOORD0;
			float2 uv_Splat0 : TEXCOORD1;
			float2 uv_Splat1 : TEXCOORD2;
			float2 uv_Splat2 : TEXCOORD3;
			//float2 uv_Splat3 : TEXCOORD4;
			float3 worldNormal;INTERNAL_DATA 
			float3 viewDir;
			float4 bumpCoords ; 
			float3 worldPos;  
		};
		 
		void vert (inout appdata_full v,out Input o) { 
			UNITY_INITIALIZE_OUTPUT(Input,o);
			APPLY_WEATHER_VERTEX_EFFECT(v,o); 
		} 

		sampler2D _Control;
		sampler2D _BumpSplat0, _BumpSplat1, _BumpSplat2, _BumpSplat3,_BumpSplatSnow;
		sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
		half4 _CustomLightDir;
		half _SpecPower;
		half _SpecLevel;
		float4 _Tiling3; 

		void surf (Input IN, inout SurfaceOutput o) {

			half4 splat_control = tex2D (_Control, IN.uv_Control);
			fixed4 col;
			half4 splat0 = tex2D (_Splat0, IN.uv_Splat0);
			half4 splat1 = tex2D (_Splat1, IN.uv_Splat1);
			half4 splat2 = tex2D (_Splat2, IN.uv_Splat2);
			half4 splat3 = tex2D (_Splat3, IN.uv_Control*_Tiling3.xy);
			
			col  = splat_control.r * splat0;	
			col += splat_control.g * splat1;	
			col += splat_control.b * splat2;	
			col += splat_control.a * splat3;


			fixed3 normal0 =  UnpackNormal(tex2D(_BumpSplat0, IN.uv_Splat0)); 
			fixed3 normal1 =  UnpackNormal(tex2D(_BumpSplat1, IN.uv_Splat1));
			fixed3 normal2 = UnpackNormal(tex2D(_BumpSplat2, IN.uv_Splat2));
			fixed3 normal3 =  UnpackNormal(tex2D(_BumpSplat3, IN.uv_Control*_Tiling3.xy));
			o.Normal = splat_control.r * normal0 + splat_control.g * normal1 + splat_control.b * normal2 + splat_control.a * normal3; 

			fixed3 h = normalize (_CustomLightDir.xyz + IN.viewDir);
			fixed nh = max (0.001f, dot (o.Normal, h));
			fixed4 SpecCol = pow(nh * col.a * _SpecLevel, _SpecPower) * _SpecColor; 
		 	
			if(isWeatherEnabled(IN)){
				APPLY_WEATHER_SURFACE_TERRAIN_EFFECT(IN,col); 
			}

			o.Albedo = col.rgb + SpecCol.rgb;
			o.Alpha = 0.0;
		}
	ENDCG

 	SubShader {
		Tags {
			"SplatCount" = "4"
			"Queue" = "Geometry-100"
			"RenderType" = "Opaque"
		}

		LOD 400 

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert    
		#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE
		#pragma target 3.0 
		//#pragma exclude_renderers gles xbox360 ps3

		ENDCG  
	}
	 
	FallBack "Weather/Simple/Terrain Bump"
}
