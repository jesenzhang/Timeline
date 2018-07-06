//2017_03_07//
//CYED_TAShader_BumpedCameraSpecularTest By KK//
//2017_03_20//
//Mixed Rimlight and make normal specular alternative//
//2017_03_31//
//Add Vertex Animation//
//2017_05_04//
//Substitute Multicompile for Shaderfeature// 

Shader "Weather/BumpedCameraSpecular"
{
	Properties
	{
		_Color ("基础颜色", Color) = (1,1,1,1)
		_MainTex ("固有色(RGB)", 2D) = "white" { }		
		
		[KeywordEnum(Disable,Enable)]_UseNormal("是否使用法线", Float) = 0
		_BumpMap ("法线贴图", 2D) = "bump" {}
		
		[KeywordEnum(Disable,Enable)]_UseSpec("是否使用高光", Float) = 0	
		_SpecularTex ("高光(R) 透贴(G) ", 2D) = "white" { }	
		_SpecColor ("高光颜色", Color) = (1,1,1,1)	
		_CustomLightDir("高光灯光方向", Vector) = (0.5,0.8,-0.25,0)	
		_SpecLevel ("高光强度", range (0,10)) = 2.0
		_SpecPower ("高光光泽度", range (0.05, 10.0)) = 2.0
		
		[KeywordEnum(Disable,Enable)]_UseRimlight("是否使用边缘光", Float) = 0
		_RimColor ("边缘光颜色", Color) = (1, 1, 1, 1)
		_RimLevel ("边缘光强度",Range(0,3)) = 0.5
		_RimPower ("边缘光范围",Range(0,6)) = 3

		[KeywordEnum(Disable,Enable)]_UseVertexAnim("是否使用顶点动画", Float) = 0
		_VertAnimParam ("顶点动画参数 位移(XYZ) 频率(W)", Vector) = (0,0,0,0)

        _Cutoff ("透明范围",float) = 0.5

        [KeywordEnum(Disable,Enable)]_Rain("Enable Rain Effect",float) = 1 
        [KeywordEnum(Disable,Enable)]_Bolt("Enable Bolt Effect",float) = 1 

        _SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1
        _WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
        _SnowPower ("Snow Power", Range(8,20)) = 11
        _Distort("Rain Wave Distort",Range(0,40)) = 1 
        _RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
        _BoltMulitplier("Bolt Multiplier",Range(0,1)) = 0.1

	}
	
	CGINCLUDE		 

		#ifndef BUMP_CAMERA_SPEC_CGINC
		#define BUMP_CAMERA_SPEC_CGINC

		fixed4 _Color;
		sampler2D _MainTex;
		#ifdef _USEVERTEXANIM_ENABLE
		fixed4 _VertAnimParam;
		#endif
		#ifdef _USERIMLIGHT_ENABLE
			fixed4 _RimColor;
			float _RimLevel;
			float _RimPower;
		#endif

		#endif
	ENDCG

	Category
	{
		Tags{"RenderType"="Opaque" "Queue"="Geometry"}

		CGINCLUDE
			#include "../Common/weather.cginc"
						
			#ifdef _USENORMAL_ENABLE
			sampler2D _BumpMap;
			#endif
			
			#ifdef _USESPEC_ENABLE
			sampler2D _SpecularTex;
			float _SpecPower;
			float _SpecLevel;
			float4 _CustomLightDir;
			#endif

			struct Input {
				float2 uv_MainTex; 
				#ifdef _USENORMAL_ENABLE 
					float3 worldNormal;INTERNAL_DATA 
				#else
					float3 worldNormal;
				#endif
				float3 worldPos;  
				float3 viewDir;
				float4 bumpCoords ;  
				#if (SHADER_TARGET >= 30)
					fixed temperature;
				#endif 
			};

			DECLARE_WEATHER_VERTEX_FUNC(snow)
			 
	
			void surf (Input IN, inout SurfaceOutput o)
			{				
				fixed4 texCol = tex2D(_MainTex,IN.uv_MainTex);	
				texCol.xyz *= _Color.xyz;
				fixed3 FinalColor = texCol.xyz; 

				#ifdef _USENORMAL_ENABLE
					o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex)); 
				#endif

				APPLY_WEATHER_SURFACE_EFFECT(IN,FinalColor);

				#ifdef _USESPEC_ENABLE
					fixed4 SpecTex = tex2D(_SpecularTex,IN.uv_MainTex);
					float3 h = normalize (_CustomLightDir + IN.viewDir);
					float nh = max (0.001f, dot (o.Normal, h));
					fixed4 SpecCol =  pow(nh * SpecTex.r * _SpecLevel, _SpecPower) * _SpecColor;
					FinalColor += SpecCol.xyz;
				#endif

				#ifdef _USERIMLIGHT_ENABLE
				// Fresnel 
				fixed rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
				o.Emission = pow(rim,_RimPower) * _RimLevel * _RimColor.xyz;
				#endif	

				o.Albedo = FinalColor;
                o.Alpha = 1.0;
			}			
		ENDCG
		
        SubShader
		{
			LOD 400		
			CGPROGRAM
			#pragma surface surf Lambert vertex:snow nodynlightmap interpolateview exclude_path:deferred exclude_path:prepass noforwardadd  
			#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE
            #pragma multi_compile _USENORMAL_ENABLE _USENORMAL_DISABLE
			#pragma multi_compile _USESPEC_ENABLE _USESPEC_DISABLE	

			#pragma target 2.0 

			ENDCG
		}   
	}

FallBack "Mobile/Diffuse"
}