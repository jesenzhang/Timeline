Shader "LDJ/Scene/AlphaReflection" {
	Properties {
        _MainTex ("Diffuse(RGB)", 2D) = "white" {}
		_LightCtrl ("Reflection(R) Alpha(B)", 2D) = "white" {}
		_EnvReflection ("EnvMap(Cube)", Cube) = "" {}
        _EnvReflectionColorR ("ReflectionColor", Color) = (0.0,0.0,0.0,1)
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0	
	}
	SubShader {
	Tags {"Queue"="AlphaTest"  "RenderType"="TransparentCutout"}
	LOD 230
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff

		sampler2D _MainTex;
		sampler2D _LightCtrl; 
		samplerCUBE _EnvReflection;
        float4 _EnvReflectionColorR;
		
		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			half4 l = tex2D (_LightCtrl, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = l.b;
			o.Emission = (l.r*(texCUBE(_EnvReflection,IN.viewDir).rgb*_EnvReflectionColorR.rgb));
			}
		ENDCG
		}

	SubShader {
	Tags {"Queue"="AlphaTest"  "RenderType"="TransparentCutout"}
		LOD 220
	
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff

		sampler2D _MainTex;
		sampler2D _LightCtrl; 
		
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			half4 l = tex2D (_LightCtrl, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = l.b;			
			}
		ENDCG
		}

Fallback "Transparent/Cutout/Diffuse"
}