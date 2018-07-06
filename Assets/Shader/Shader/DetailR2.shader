// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/DetailR2"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_AddTex ("AddTex", 2D) = "white" {}

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

		_Add_USpeed ("Add_USpeed", float) = 0
		_Add_VSpeed ("Add_VSpeed", float) = 0
		_Add_RSpeed ("Add_RSpeed", float) = 0
		_Add_Orient ("Add_Orient", float) = 0
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
				float2 uv[2] : TEXCOORD0;
				fixed4 color : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _AddTex;
			float4 _AddTex_ST;

			//common
			float4 _Color;
			float _Intensity;
			//main uv
			float _Main_USpeed;
			float _Main_VSpeed;
			float _Main_RSpeed;
			float _Main_Orient;
			//add uv
			float _Add_USpeed;
			float _Add_VSpeed;
			float _Add_RSpeed;
			float _Add_Orient;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv[1] = TRANSFORM_TEX(v.uv, _AddTex);

				o.uv[0] = uv_orient_to(o.uv[0], _Main_Orient);
				o.uv[0] = uv_translate(o.uv[0], _Main_USpeed, _Main_VSpeed);
				o.uv[0] = uv_rotate(o.uv[0], _Main_RSpeed);

				o.uv[1] = uv_orient_to(o.uv[1], _Add_Orient);
				o.uv[1] = uv_translate(o.uv[1], _Add_USpeed, _Add_VSpeed);
				o.uv[1] = uv_rotate(o.uv[1], _Add_RSpeed);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 ret = i.color * _Intensity;
				fixed4 mainColor = tex2D(_MainTex, i.uv[0]);
				fixed4 addColor = tex2D(_AddTex, i.uv[1]);
				ret.rgb *= (mainColor.rgb + addColor.rgb) * mainColor.rgb * addColor.rgb;
				ret.a *= (mainColor.r + addColor.r) * mainColor.r * addColor.r;
				return ret;
			}
			ENDCG
		}
	}
}