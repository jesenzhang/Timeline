//2017_03_07//
//CYED_TAShader_BumpedCameraSpecularTest By KK//
//2017_03_20//
//Mixed Rimlight and make normal specular alternative//
//2017_03_31//
//Add Vertex Animation//
//2017_05_04//
//Substitute Multicompile for Shaderfeature// 

Shader "TAShaders/BumpedCameraSpecular"
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

	}
	
	CGINCLUDE		
		#pragma multi_compile _USERIMLIGHT_ENABLE _USERIMLIGHT_DISABLE
		#pragma multi_compile _USEVERTEXANIM_ENABLE _USEVERTEXANIM_DISABLE
		fixed4 _Color;
		sampler2D _MainTex;
		#ifdef _USEVERTEXANIM_ENABLE
		fixed4 _VertAnimParam;
		#endif
		#ifdef _USERIMLIGHT_ENABLE
			fixed4 _RimColor;
			half _RimLevel;
			half _RimPower;
		#endif
	ENDCG

	Category
	{
		Tags{"RenderType"="Opaque" "Queue"="Geometry"}
		
        SubShader
		{
			LOD 800		
			CGPROGRAM
			#pragma surface surf Lambert vertex:Vertex nodynlightmap interpolateview exclude_path:deferred exclude_path:prepass noforwardadd
			#pragma target 3.0
            #pragma multi_compile _USENORMAL_ENABLE _USENORMAL_DISABLE
			#pragma multi_compile _USESPEC_ENABLE _USESPEC_DISABLE	
						
			#ifdef _USENORMAL_ENABLE
			sampler2D _BumpMap;
			#endif
			
			#ifdef _USESPEC_ENABLE
			sampler2D _SpecularTex;
			half _SpecPower;
			half _SpecLevel;
			half4 _CustomLightDir;
			#endif

			struct Input 
			{
				float2 uv_MainTex;
				
				#ifdef _USESPEC_ENABLE
					half3 viewDir;
				#elif _USERIMLIGHT_ENABLE
					half3 viewDir;
				#endif
			};

			void Vertex (inout appdata_full v, out Input o)
			{
    			UNITY_INITIALIZE_OUTPUT(Input,o);
    			
    			#ifdef _USEVERTEXANIM_ENABLE
    			v.vertex.xyz += sin(_Time.g * _VertAnimParam.w) * _VertAnimParam.xyz * 0.1 * v.color.a;
    			#endif
    		}
	
			void surf (Input IN, inout SurfaceOutput o)
			{				
				fixed4 texCol = tex2D(_MainTex,IN.uv_MainTex);	
				texCol.xyz *= _Color.xyz;
				fixed3 FinalColor = texCol.xyz;

				#ifdef _USENORMAL_ENABLE
					o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
				#endif

				#ifdef _USESPEC_ENABLE
					fixed4 SpecTex = tex2D(_SpecularTex,IN.uv_MainTex);
					half3 h = normalize (_CustomLightDir + IN.viewDir);
					half nh = max (0.001f, dot (o.Normal, h));
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
		}

		SubShader
		{	 
			LOD 600		
			CGPROGRAM
			#pragma surface surf Lambert vertex:Vertex nodynlightmap nodirlightmap interpolateview noforwardadd exclude_path:deferred exclude_path:prepass

			struct Input 
			{
				half2 uv_MainTex;
				#ifdef _USERIMLIGHT_ENABLE
					half3 viewDir;
				#endif
			};

			void Vertex (inout appdata_full v, out Input o)
			{
    			UNITY_INITIALIZE_OUTPUT(Input,o);
    			#ifdef _USEVERTEXANIM_ENABLE
    			v.vertex.xyz += sin(_Time.g * _VertAnimParam.w) * _VertAnimParam.xyz * 0.1 * v.color.a;
    			#endif
    		}
	
			void surf (Input IN, inout SurfaceOutput o)
			{				
				fixed4 texCol = tex2D(_MainTex,IN.uv_MainTex);						
				o.Albedo = texCol.xyz * _Color.xyz;

				#ifdef _USERIMLIGHT_ENABLE
				// Fresnel 
				fixed rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
				o.Emission = pow(rim,_RimPower) * _RimLevel * _RimColor.xyz;
				#endif	

				o.Alpha = 1.0;
			}			
			ENDCG
		}
	}
FallBack "Legacy Shaders/Diffuse"
}