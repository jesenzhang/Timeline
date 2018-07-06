// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "CF/Transparent/ScreeDist"
{
	Properties
	{
		_DistTex ("DistTex", 2D) = "white" {}
		_MaskTex ("MaskTex", 2D) = "white" {}

		//common
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src Factor", float) = 5  //SrcAlpha
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst Factor", float) = 10 //OneMinusSrcAlpha
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", float) = 2 //Back
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", float) = 4 //LessEqual

		// uv animation
		_Dist_USpeed ("Dist_USpeed", float) = 0
		_Dist_VSpeed ("Dist_VSpeed", float) = 0
		_Dist_RSpeed ("Dist_RSpeed", float) = 0
		_Dist_Orient ("Dist_Orient", float) = 0

		_Mask_USpeed ("Mask_USpeed", float) = 0
		_Mask_VSpeed ("Mask_VSpeed", float) = 0
		_Mask_RSpeed ("Mask_RSpeed", float) = 0
		_Mask_Orient ("Mask_Orient", float) = 0

		_StrengthX ("StrengthX", float) = 1
		_StrengthY ("StrengthY", float) = 1
		_HeatTime ("Heat Time", Range(0, 1.5)) = 1
	}//Properties

	Category
	{
		Tags { "Queue" = "Transparent+1" "RenderType" = "Transparent"}

		SubShader
		{
			GrabPass
			{
				Name "BASE"
				Tags { "LightMode" = "Always" }
			}//GrapPass

			Pass
			{
				Name "BASE"
				Tags { "LightMode" = "Always" }

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

				struct appdata_t
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 uv : TEXCOORD0;
					float2 uv2 : TEXCOORD1;
				};//appdata_t
				struct v2f
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 uv_grab : TEXCOORD0;
					float2 uv_dist : TEXCOORD1;
					float2 uv_mask : TEXCOORD2;
					float2 uv2 : TEXCOORD3;
				};//v2f

				sampler2D _GrabTexture;
				sampler2D _DistTex;
				float4 _DistTex_ST;
				sampler2D _MaskTex;
				float4 _MaskTex_ST;

				//common
				float4 _Color;
				float _Intensity;
				//main uv
				float _Dist_USpeed;
				float _Dist_VSpeed;
				float _Dist_RSpeed;
				float _Dist_Orient;
				//Mask uv
				float _Mask_USpeed;
				float _Mask_VSpeed;
				float _Mask_RSpeed;
				float _Mask_Orient;
				//distort param
				float _StrengthX;
				float _StrengthY;
				float _HeatTime;

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0f;
					#else
					float scale = 1.0f;
					#endif//UNITY_UV_STARTS_AT_TOP
					o.uv_grab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
					o.uv_grab.zw = o.vertex.zw;

					o.uv_dist = TRANSFORM_TEX(v.uv, _DistTex);
					o.uv_mask = TRANSFORM_TEX(v.uv, _MaskTex);

					o.uv_dist = uv_orient_to(o.uv_dist, _Dist_Orient);
					o.uv_dist = uv_translate(o.uv_dist, _Dist_USpeed, _Dist_VSpeed);
					o.uv_dist = uv_rotate(o.uv_dist, _Dist_RSpeed);

					o.uv_mask = uv_orient_to(o.uv_mask, _Mask_Orient);
					o.uv_mask = uv_translate(o.uv_mask, _Mask_USpeed, _Mask_VSpeed);
					o.uv_mask = uv_rotate(o.uv_mask, _Mask_RSpeed);

					o.color = v.color * _Color;
					o.uv2  = v.uv2;
					return o;
				}

				fixed4 frag(v2f i) : COLOR
				{
					fixed4 offset1 = tex2D(_DistTex, i.uv_dist + _Time.xz * _HeatTime);
					fixed4 offset2 = tex2D(_DistTex, i.uv_dist + _Time.yx * _HeatTime);
					i.uv_grab.x += (offset1.r + offset1.r - 1) * _StrengthX * _Color.a * i.uv2.x;
					i.uv_grab.y += (offset2.g + offset2.g - 1) * _StrengthY * _Color.a * i.uv2.y;
					fixed4 mainColor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uv_grab));
					fixed4 maskColor = tex2D(_MaskTex, i.uv_mask);

					fixed4 ret = mainColor * _Intensity;
					ret.a *= i.color.a * maskColor.r;
					return ret;
				}
				ENDCG
			}
		}//SubShader

		SubShader
		{
			Tags { "Queue" = "Transparent+1" "RenderType" = "Transparent"}
			Blend SrcAlpha OneMinusSrcAlpha

			Pass
			{
				SetTexture [_MainTex] { combine texture * primary double, texture * primary }
			}
		}//SubShader
	}//Categort
}//Shader