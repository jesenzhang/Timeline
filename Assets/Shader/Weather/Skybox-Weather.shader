// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Weather/Skybox-Texture" {
Properties {
	_Color("Main Color", Color) = (0, 0, 0, 0)
	_DayTex ("Day Base layer (RGB)", 2D) = "white" {} 
	_DayDetailTex ("Day Detail layer (RGB)", 2D) = "white" {}
	_NightTex ("Night Base layer (RGB)", 2D) = "white" {}
	_NightDetailTex ("Night Detail layer (RGB)", 2D) = "white" {}
	_CloudyTex ("Cloudy layer (RGB)", 2D) = "grey" {}
	_ScrollX ("Base layer Scroll speed X", Float) = 0.0
	_ScrollY ("Base layer Scroll speed Y", Float) = 0.0
	_Scroll2X ("2nd layer Scroll speed X", Float) = 0.1
	_Scroll2Y ("2nd layer Scroll speed Y", Float) = 0.0
	_NightMultiplier ("Night Multiplier", Range(0.1,2)) = 1
	_AMultiplier ("Layer Multiplier", Range(0.1,1.2)) = 0.5
	_DayIntensity ("Day Intensity", Range(-1,1)) = 1
	_CloudyIntensity ("Cloudy Intensity", Range(0,1)) = 0
}

SubShader {
	Tags { "Queue"="Geometry+10" "RenderType"="Background" }
	
	Lighting Off
	Fog { Mode Off }
	
	ZWrite Off
	LOD 100
		
	CGINCLUDE
	#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
	#include "UnityCG.cginc"
	sampler2D _DayTex;
	sampler2D _NightTex; 
	sampler2D _DayDetailTex;
	sampler2D _NightDetailTex;
	sampler2D _CloudyTex;

	float4 _DayTex_ST; 
	float4 _NightTex_ST;
	float4 _DayDetailTex_ST;
	float4 _NightDetailTex_ST;
	float4 _CloudyTex_ST;

	fixed4 _Color;
	
	float _ScrollX;
	float _ScrollY; 
	float _Scroll2X;
	float _Scroll2Y; 

	float _NightMultiplier;
	float _AMultiplier;
	float _DayIntensity;
	float _CloudyIntensity;
	
	struct v2f {
		float4 pos : SV_POSITION;
		float2 uvDay : TEXCOORD0; 
		float2 uvNight : TEXCOORD1;
		float2 uvDayDetail : TEXCOORD2; 
		float2 uvNightDetail : TEXCOORD3; 
		float2 uvCloudy : TEXCOORD4; 
		fixed4 color : TEXCOORD5;		
	};

	
	v2f vert (appdata_full v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uvDay = TRANSFORM_TEX(v.texcoord.xy,_DayTex) + frac(float2(_ScrollX, _ScrollY) * _Time); 
		o.uvNight = TRANSFORM_TEX(v.texcoord.xy,_NightTex) + frac(float2(_ScrollX, _ScrollY) * _Time);
		o.uvDayDetail = TRANSFORM_TEX(v.texcoord.xy,_DayDetailTex) + frac(float2(_Scroll2X, _Scroll2Y) * _Time);
		o.uvNightDetail = TRANSFORM_TEX(v.texcoord.xy,_NightDetailTex) + frac(float2(_Scroll2X, _Scroll2Y) * _Time);
		o.uvCloudy = TRANSFORM_TEX(v.texcoord.xy,_CloudyTex) + frac(float2(_Scroll2X, _Scroll2Y) * _Time); 

		o.color = fixed4(_AMultiplier, _AMultiplier, _AMultiplier, _AMultiplier);

		return o;
	}
	ENDCG


	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest		
		fixed4 frag (v2f i) : COLOR{
			fixed4 o;

			fixed4 texDay = tex2D (_DayTex, i.uvDay); 
			fixed4 texNight = tex2D (_NightTex, i.uvNight) * _NightMultiplier;
			fixed4 texDayDetail = tex2D (_DayDetailTex, i.uvDayDetail);
			fixed4 texNightDetail = tex2D (_NightDetailTex, i.uvNightDetail) * _NightMultiplier;
			fixed4 cloudyDetail = tex2D (_CloudyTex, i.uvCloudy); 

			//if(IsGammaSpace()){
			//	texDay.rgb = LinearToGammaSpace(texDay.rgb);
			//	texNight.rgb = GammaToLinearSpace(texNight.rgb);
			//	texDayDetail.rgb = GammaToLinearSpace(texDayDetail.rgb);
			//	texNightDetail.rgb = GammaToLinearSpace(texNightDetail.rgb);
			//	cloudyDetail.rgb = GammaToLinearSpace(cloudyDetail.rgb);
			//}

			float dayIntensity = clamp(_DayIntensity,0,1);
			float cloudyIntensity = clamp(_CloudyIntensity,0,1);

			fixed4 baseColor = lerp(texNight,texDay,dayIntensity);
			fixed4 detailColor = lerp(texNightDetail,texDayDetail,dayIntensity);
			detailColor = lerp(detailColor,cloudyDetail,cloudyIntensity); 
			
			o =  baseColor * detailColor * i.color * _Color * 2 ;  

			//if(IsGammaSpace()){
			//	o.rgb = LinearToGammaSpace(o.rgb);
			//} 

			return o;
		}
		ENDCG 
	}	
}
}
