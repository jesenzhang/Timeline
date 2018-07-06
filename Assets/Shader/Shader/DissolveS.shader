// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/DissolveS"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DissTex ("DissTex", 2D) = "white" {}

		//common
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src Factor", float) = 5  //SrcAlpha
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst Factor", float) = 10 //OneMinusSrcAlpha
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", float) = 2 //Back
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", float) = 4 //LessEqual

		// uv animation
		_Main_USpeed ("Main_USpeed", float) = 0
		_Main_VSpeed ("Main_VSpeed", float) = 0
		_Main_RSpeed ("Main_RSpeed", float) = 0
		_Main_Orient ("Main_Orient", float) = 0
		// diss animation
		_Diss_USpeed ("Diss_USpeed", float) = 0
		_Diss_VSpeed ("Diss_VSpeed", float) = 0
		_Diss_RSpeed ("Diss_RSpeed", float) = 0
		_Diss_Orient ("Diss_Orient", float) = 0

		_FireColor ("Fire Color", Color) = (1, 1, 0, 1)
		_ColorAnimate ("ColorAnimate", vector) = (0,1,0,0)
		_StartAmount("amount", Range(0.0, 1)) = 0.2
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		Pass
		{
			Tags { "LIGHTMODE"="Always" }
			Lighting Off
			Fog { Mode Off }
			Blend [_BlendSrc] [_BlendDst]
			Cull [_CullMode]
			ZTest [_ZTest]
			ZWrite off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"
			#include "CFIncludes/UVAnim.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 uv : TEXCOORD0;
				float2 uv_diss : TEXCOORD1;
			};

			float4 _Color;
			float _Intensity;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DissTex;
			float4 _DissTex_ST;

			//main uv
			float _Main_USpeed;
			float _Main_VSpeed;
			float _Main_RSpeed;
			float _Main_Orient;
			//diss uv
			float _Diss_USpeed;
			float _Diss_VSpeed;
			float _Diss_RSpeed;
			float _Diss_Orient;

			//dissovle parameter
			fixed4 _FireColor;
			half4 _ColorAnimate;
			float _StartAmount;

			static float3 Color = float3(1, 1, 1);

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv_diss = TRANSFORM_TEX(v.uv, _DissTex);

				o.uv = uv_orient_to(o.uv, _Main_Orient);
				o.uv = uv_translate(o.uv, _Main_USpeed, _Main_VSpeed);
				o.uv = uv_rotate(o.uv, _Main_RSpeed);

				o.uv_diss = uv_orient_to(o.uv_diss, _Diss_Orient);
				o.uv_diss = uv_translate(o.uv_diss, _Diss_USpeed, _Diss_VSpeed);
				o.uv_diss = uv_rotate(o.uv_diss, _Diss_RSpeed);

				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 mainColor = tex2D(_MainTex, i.uv);
				fixed4 ret = mainColor * _Intensity;
				ret.rgb *= i.color.rgb;

				fixed4 dissColor = tex2D(_DissTex, i.uv_diss);
				half clipAmount = dissColor.r - (1 - i.color.a);
				clip(clipAmount);
				if(clipAmount < _StartAmount)
				{
					half lit = clipAmount / _StartAmount;
					Color.x = lerp(_FireColor.r, lit, _ColorAnimate.x);
					Color.y = lerp(_FireColor.g, lit, _ColorAnimate.y);
					Color.z = lerp(_FireColor.b, lit, _ColorAnimate.z);
					half mulFactor = Color.x + Color.y + Color.z;
					ret.rgb *= Color.xyz * mulFactor * mulFactor;
				}
				ret.a = mainColor.a;
				return ret;
			}
			ENDCG
		}
	}
}
