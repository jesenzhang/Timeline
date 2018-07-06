// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/SimpleR3UV"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}

		//common
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src Factor", float) = 5  //SrcAlpha
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst Factor", float) = 10 //OneMinusSrcAlpha
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", float) = 2 //Back
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", float) = 4 //LessEqual

		// uv animation
		_USpeed ("USpeed", float) = 0
		_VSpeed ("VSpeed", float) = 0
		_RSpeed ("RSpeed", float) = 0
		_Orient ("Orient", float) = 0
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
				float2 uv : TEXCOORD0;
				fixed4 color : COLOR;
			};

			float4 _Color;
			float _Intensity;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			//main uv
			float _USpeed;
			float _VSpeed;
			float _RSpeed;
			float _Orient;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv = uv_orient_to(o.uv, _Orient);
				o.uv = uv_translate(o.uv, _USpeed, _VSpeed);
				o.uv = uv_rotate(o.uv, _RSpeed);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 ret = i.color * _Intensity;
				fixed4 col = tex2D(_MainTex, i.uv);
				ret.a *= col.r;
				return ret;
			}
			ENDCG
		}
	}
}
