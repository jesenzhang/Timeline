//////////////////////////////////////////////////////
// MK Glow Extract Luminance Shader    				//
//					                                //
// Created by Michael Kremmel                       //
// www.michaelkremmel.de | www.michaelkremmel.store //
// Copyright © 2017 All rights reserved.            //
//////////////////////////////////////////////////////
Shader "Hidden/MK/Glow/ExtractLuminance"
{
	Properties{_MainTex("", 2D) = "Black" {}}

	Subshader
	{
		ZTest Off
		Fog{ Mode Off }
		Cull Off
		Lighting Off
		ZWrite Off

		Pass
		{
			Blend One Zero
			Name "ExtractLuminance"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 2.0

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform fixed4 _MainTex_TexelSize;
			uniform float4 _MainTex_ST;
			uniform float _Threshold;

			struct Input
			{
				float4 texcoord : TEXCOORD0;
				float4 vertex : POSITION;
			};

			struct Output
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			Output vert(Input i)
			{
				Output o;
				UNITY_INITIALIZE_OUTPUT(Output,o);
				o.pos = UnityObjectToClipPos(i.vertex);
				o.uv = i.texcoord.xy;
				#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
						o.uv.y = 1-o.uv.y;
				#endif
				return o;
			}

			fixed4 frag(Output i) : SV_TARGET
			{
				fixed4 c = tex2D(_MainTex,  UnityStereoScreenSpaceUVAdjust(i.uv.xy, _MainTex_ST));
				c = c * c * c;
				//c.rgb = (c.r + c.g + c.b < _Threshold) ? 0 : c.rgb;
				if(c.r + c.g + c.b < _Threshold)
					c.rgb = 0;
				//c.rgb = max(0.0, c.rgb - _Threshold);
				return c;
			}

		ENDCG
		}
	}
}