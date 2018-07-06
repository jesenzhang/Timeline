//2015_10_22//
//CYED_TAShader_XYJCharacter_3.0 By KK//
//2016/4/6 RZ//

Shader "TLStudio/Character/FlowingLight" 
{
	Properties 
	{
	  	_Color ("基础颜色", Color) = (1,1,1,1)
	  	_MainTex ("固有色(RGB) 透贴(A)", 2D) = "white" {}	  	
		
		_SpecColor ("高光颜色", Color) = (1,1,1,1)
		_SpecLevel ("高光强度",Range( 0.0 , 10.0 )) = 2
		_SpecPower ("高光范围",Range( 0.1 , 1.0 )) = 0.5

		_RimColor ("边缘光颜色", Color) = (1,1,1,1)
		_RimLevel ("边缘光强度",Range( 0.0 , 1.0 )) = 0.5
		_RimPower ("边缘光范围",Range( 0.0 , 5.0 )) = 0.5

		_AdditionalTex ("高光(R) 光泽(G) 流光(B)", 2D) = "white" {}

		[KeywordEnum(Disable,Enable)]_IsUseMC("是否使用流光", Float) = 0
		
		_MatCapMulti ("流光强度",Range(0,10.0)) = 2.0

		_Cutoff ("透明范围",float) = 0.5
	}

	SubShader 
	{
	    Tags {"Queue" = "Transparent-500" "IgnoreProjector"="False" "RenderType" = "TransparentCutout" }
        LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong2D vertex:vert alphatest:_Cutoff
		#pragma multi_compile _ISUSEMC_DISABLE _ISUSEMC_ENABLE

		fixed4 _Color;
		fixed _SpecLevel;
		fixed _SpecPower;
		fixed4 _RimColor;
		fixed _RimLevel;
		fixed _RimPower;

		sampler2D _MainTex;
		sampler2D _AdditionalTex;

		fixed _MatCapMulti;

		struct Input 
		{
			  float2 uv_MainTex;
			  float3 viewDir;

			  #ifdef _ISUSEMC_ENABLE
			  	float2 matcapUV;
			  #endif
		};

		inline fixed4 LightingBlinnPhong2D (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize (lightDir + viewDir);
				
			//Make less volume shading
			fixed diff = max (0.45, dot (s.Normal, lightDir));
	
			float nh = max (0, dot (s.Normal, h));
			float spec = 0;
	
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) * (atten * 0.9) + (_LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 3);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
			return c;
		}


		
		void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			#ifdef _ISUSEMC_ENABLE
				o.matcapUV = float2(dot(UNITY_MATRIX_IT_MV[0].xyz,v.normal),dot(UNITY_MATRIX_IT_MV[1].xyz,v.normal)) * 0.5 + 0.5;
			#endif
		}
		
		void surf (Input IN, inout SurfaceOutput o)
		{
            // Diffuse
			fixed4 diff = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = diff.rgb;
			// Cutoff
		  	o.Alpha = diff.a;

		 	// Specular
		 	fixed4 addtex = tex2D(_AdditionalTex, IN.uv_MainTex);
		 	o.Specular = addtex.g * _SpecPower;
		 	o.Gloss = addtex.r * _SpecLevel;

		  	// Fresnel 
		  	fixed rim = 1 - saturate(dot (normalize(IN.viewDir), o.Normal));
		  	o.Emission = pow(rim, _RimPower)  * _RimLevel * ((addtex.g + addtex.r) * 0.5) * _RimColor; 

		  	#ifdef _ISUSEMC_ENABLE
		  		fixed4 mc = tex2D(_AdditionalTex, IN.matcapUV).b * _MatCapMulti * _SpecColor; 
            	fixed4 mc2 = saturate(pow(tex2D(_AdditionalTex, IN.matcapUV).b , _MatCapMulti));
		  		o.Albedo += mc2 * mc * addtex.r;
		  	#endif
	}
	ENDCG
	}
Fallback "Transparent/Cutout/Diffuse"
}