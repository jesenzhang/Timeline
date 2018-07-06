// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/MultiplyM"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("MaskTex", 2D) = "white" {}

		//common
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 1
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", float) = 2 //Back
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", float) = 4 //LessEqual

		// uv animation
		_Main_USpeed ("Main_USpeed", float) = 0
		_Main_VSpeed ("Main_VSpeed", float) = 0
		_Main_RSpeed ("Main_RSpeed", float) = 0
		_Main_Orient ("Main_Orient", float) = 0
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }
		Pass
		{
			Tags { "LIGHTMODE"="Always" }
			Lighting Off
			Fog { Mode Off }
			Blend DstColor Zero
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
				float2 uv_mask : TEXCOORD1;
				fixed4 color : COLOR;
			};

			float4 _Color;
			float _Intensity;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			//main uv
			float _Main_USpeed;
			float _Main_VSpeed;
			float _Main_RSpeed;
			float _Main_Orient;
			//mask uv
			float _Mask_USpeed;
			float _Mask_VSpeed;
			float _Mask_RSpeed;
			float _Mask_Orient;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv_mask = TRANSFORM_TEX(v.uv, _MaskTex);

				o.uv = uv_orient_to(o.uv, _Main_Orient);
				o.uv = uv_translate(o.uv, _Main_USpeed, _Main_VSpeed);
				o.uv = uv_rotate(o.uv, _Main_RSpeed);

				o.uv_mask = uv_orient_to(o.uv_mask, _Mask_Orient);
				o.uv_mask = uv_translate(o.uv_mask, _Mask_USpeed, _Mask_VSpeed);
				o.uv_mask = uv_rotate(o.uv_mask, _Mask_RSpeed);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col = col * i.color * _Intensity;
				fixed4 maskColor = tex2D(_MaskTex, i.uv_mask);
				col.rgb *= maskColor.rgb;
				col.a *= maskColor.r;

				return fixed4(1, 1, 1, 1) - col;
			}
			ENDCG
		}
	}
}
