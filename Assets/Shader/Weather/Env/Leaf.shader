//2016_01_13//
//CYED_TAShader_VegetationBend_Leaf_Surface By KK//

Shader "Weather/Leaf" {
	Properties {
		_Color("主色调", Color) = (0,0,0,0)
		_MainTex ("固有色(RGB) 透明(A)", 2D) = "white" {}
		_Cutoff ("透明范围", float) = 0.5

		[KeywordEnum(Disable,Enable)]_CustomWind("Override Wind",float) = 1
		_CustomWindDir("风向(XYZ) 风力(W)", Vector) = (0.1,0.0,0.05,0.3)
		_Frequency("摇摆频率", Range (0, 20)) = 1.2

		[KeywordEnum(Disable,Enable)]_Rain("Enable Rain Effect",float) = 1 
    	[KeywordEnum(Disable,Enable)]_Bolt("Enable Bolt Effect",float) = 1 
		_WeatherTextureScale("Weather Texture Scale",Range(0.1,100)) = 1
		_SnowMultiplier ("Snow Multiplier", Range(0,2)) = 1 
		_SnowPower ("Snow Power", Range(3,20)) = 10
		_RainMultiplier ("Rain Multiplier", Range(0,2)) = 1  
		_BoltMulitplier("Bolt Multiplier",Range(0,1)) = 0.1
	}

	CGINCLUDE
		#include "../Common/weather.cginc"

		sampler2D _MainTex;
		#ifdef _CUSTOM_WIND_ENABLE
		float4 _CustomWindDir;
		#endif
		float4 _WindDir; 
		float  _Frequency;
		float _Offset;
		float4 _Color;
		 

		struct Input
        {
            float2 uv_MainTex; 
			float3 worldPos;  
			float3 viewDir;
			float3 worldNormal; 
			float4 bumpCoords ;  
		#if (SHADER_TARGET >= 30)
			fixed temperature;
		#endif
        };

		
		
		void vert (inout appdata_full v,out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			float4 windir = _WindDir;
			#ifdef _CUSTOM_WIND_ENABLE 
				windir = _CustomWindDir;
			#endif 
			float power = windir.w; 
			//worldPos.xyz += _WindDir.xyz * (sin(worldPos.x + _Frequency * _Time.z) + sin(worldPos.z + _Frequency * 0.43 * _Time.z) + 1) * power * v.color.x;
			v.vertex.xyz += (float3(1.0,0.5,0.5) + v.normal) * windir.xyz * (cos(v.vertex.x + _Frequency * _Time.z) + sin(v.vertex.z + _Frequency * 0.4 * _Time.z)) * power * v.color.x;

			o.uv_MainTex = v.texcoord.xy;
			APPLY_WEATHER_VERTEX_EFFECT(v,o);
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			float4 col = tex2D (_MainTex, IN.uv_MainTex) * _Color; 
			APPLY_WEATHER_SURFACE_DIFFUSE_EFFECT(IN,col);
			o.Albedo = col.rgb;
		 	o.Alpha = col.a;
		}
	ENDCG

	SubShader {
		Tags {"RenderType"="TransparentCutout" "IgnoreProjector"="True" "Queue"="AlphaTest"}
		Cull Off
		LOD 400
		
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:vert floatasview noforwardadd  
		#pragma multi_compile _RAIN_ENABLE _RAIN_DISABLE 
		#pragma target 2.0 

		ENDCG
	}
	 

	FallBack "Mobile/Diffuse"
}
