// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CF/Transparent/RimInvertM"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MaskTex ("Texture", 2D) = "white" {}

		//common
		_Color ("Main Color", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src Factor", float) = 5  //SrcAlpha
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst Factor", float) = 10 //OneMinusSrcAlpha
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", float) = 2 //Back
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("Z Test", float) = 4 //LessEqual

		// uv animation
		_Main_USpeed ("USpeed", float) = 0
		_Main_VSpeed ("VSpeed", float) = 0
		_Main_RSpeed ("RSpeed", float) = 0
		_Main_Orient ("Orient", float) = 0
		//mask animation
		_Mask_USpeed ("Mask_USpeed", float) = 0
		_Mask_VSpeed ("Mask_VSpeed", float) = 0
		_Mask_RSpeed ("Mask_RSpeed", float) = 0
		_Mask_Orient ("Mask_Orient", float) = 0

		//rim parmeter
		_RimColor ("Rim Color", Color) = (0.5,0.5,0.5,0.5)
		_InnerColor ("Inner Color", Color) = (0.5,0.5,0.5,0.5)
		_InnerColorPower ("Inner Color Power", Range(0.0,1.0)) = 0.5
		_RimPower ("Rim Power", Range(0.0,5.0)) = 2.5
		_AlphaPower ("Alpha Rim Power", Range(0.0,8.0)) = 4.0
		_AllPower ("All Power", Range(0.0, 10.0)) = 1.0
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
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float3 normal : TEXCOORD0;
				half3 viewDir : TEXCOORD1;
				float2 uv[2] : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MaskTex;
			float4 _MaskTex_ST;

			//common
			float4 _Color;
			float _Intensity;
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

			//rim parameter
			float4 _RimColor;
			float _RimPower;
			float _AlphaPower;
			float _InnerColorPower;
			float _AllPower;
			float4 _InnerColor;

			v2f vert (appdata v)
			{
				v2f o;
				o.color = v.color * _Color;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv[1] = TRANSFORM_TEX(v.uv, _MaskTex);

				o.uv[0] = uv_orient_to(o.uv[0], _Main_Orient);
				o.uv[0] = uv_translate(o.uv[0], _Main_USpeed, _Main_VSpeed);
				o.uv[0] = uv_rotate(o.uv[0], _Main_RSpeed);

				o.uv[1] = uv_orient_to(o.uv[1], _Mask_Orient);
				o.uv[1] = uv_translate(o.uv[1], _Mask_USpeed, _Mask_VSpeed);
				o.uv[1] = uv_rotate(o.uv[1], _Mask_RSpeed);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
				o.normal = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0)).xyz);

				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 ret = i.color * _Intensity;
				fixed4 mainColor = tex2D(_MainTex, i.uv[0]);
				fixed4 maskColor = tex2D(_MaskTex, i.uv[1]);
				ret *= mainColor;
				ret.rgb *= maskColor.rgb;
				ret.a *= maskColor.r;

				half rim = saturate(dot(i.viewDir, i.normal));
				half3 rimColor = _RimColor.rgb * pow(rim, _RimPower) * _AllPower
							   + (_InnerColor.rgb * 2 * _InnerColorPower); 
				half rimA = pow(rim, _AlphaPower) * _AllPower;
				ret *= fixed4(rimColor, rimA);
				return ret;
			}
			ENDCG
		}
	}
}
