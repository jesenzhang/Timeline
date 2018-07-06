// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "CF/Transparent/RimS"
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
				float2 uv : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			//common
			float4 _Color;
			float _Intensity;
			float _USpeed;
			float _VSpeed;
			float _RSpeed;
			float _Orient;
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
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.uv = uv_orient_to(o.uv, _Orient);
				o.uv = uv_translate(o.uv, _USpeed, _VSpeed);
				o.uv = uv_rotate(o.uv, _RSpeed);

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
				o.normal = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0)).xyz);

				return o;
			}
			
			fixed4 frag (v2f i) : COLOR0
			{
				fixed4 ret = i.color * _Intensity;
				fixed4 mainColor = tex2D(_MainTex, i.uv);

				half rim = 1.0f - saturate(dot(i.viewDir, i.normal));
				half3 rimColor = _RimColor.rgb * pow(rim, _RimPower) * _AllPower
							   + (_InnerColor.rgb * 2 * _InnerColorPower); 
				half rimA = pow(rim, _AlphaPower) * _AllPower;
				ret *= mainColor * fixed4(rimColor, rimA);
				return ret;
			}
			ENDCG
		}
	}
}
