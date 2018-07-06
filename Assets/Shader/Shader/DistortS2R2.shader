// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/DistortS2R2"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_DistortTex ("DistortTex", 2D) = "white" {}

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
		// distort animation
		_Distort_USpeed ("Distort_USpeed", float) = 0
		_Distort_VSpeed ("Distort_VSpeed", float) = 0
		_Distort_RSpeed ("Distort_RSpeed", float) = 0
		_Distort_Orient ("Distort_Orient", float) = 0

		//distort parameter
		_ForceX  ("Strength X", range(0,1)) = 0
		_ForceY  ("Strength Y", range(0,1)) = 0.2
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
				fixed4 color : COLOR;
				float2 uv : TEXCOORD0;
	            float2 param : TEXCOORD1;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 uv[2] : TEXCOORD0;
	            float2 param : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _DistortTex;
			float4 _DistortTex_ST;

			//common
			float4 _Color;
			float _Intensity;
			//main uv
			float _Main_USpeed;
			float _Main_VSpeed;
			float _Main_RSpeed;
			float _Main_Orient;
			//distort uv
			float _Distort_USpeed;
			float _Distort_VSpeed;
			float _Distort_RSpeed;
			float _Distort_Orient;

			//distort parameter
			uniform half _ForceX;
	        uniform half _ForceY;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv[1] = TRANSFORM_TEX(v.uv, _DistortTex);

				o.uv[0] = uv_orient_to(o.uv[0], _Main_Orient);
				o.uv[0] = uv_translate(o.uv[0], _Main_USpeed, _Main_VSpeed);
				o.uv[0] = uv_rotate(o.uv[0], _Main_RSpeed);

				o.uv[1] = uv_orient_to(o.uv[1], _Distort_Orient);
				o.uv[1] = uv_translate(o.uv[1], _Distort_USpeed, _Distort_VSpeed);
				o.uv[1] = uv_rotate(o.uv[1], _Distort_RSpeed);

				o.param = v.param;
				
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 ret = i.color * _Intensity;

				float2 distortCoord = i.uv[1];
				fixed4 distortColor = tex2D(_DistortTex, distortCoord);

				float2 texCoord = i.uv[0];
				texCoord.x += distortColor.r * _ForceX * i.param.x;
				texCoord.y += distortColor.g * _ForceY * i.param.x;

				fixed4 mainColor = tex2D(_MainTex, texCoord);
				ret.a = mainColor.r * _Color.a * i.color.a;
				
				return ret;
			}
			ENDCG
		}
	}
}