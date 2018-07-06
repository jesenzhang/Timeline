Shader "Billboard/BillboardParticl_S_1" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}

		_Alpha_Acce("Alpha Acce", float) = -0.5
			_Alpha_Value("Alpha Start Value", float) = 0
			_Alpha_Time("Alpha Time", float) = 1
			_Alpha_Limit("Alpha Limit", float) = 1
			_Alpha_Start("Alpha Start", float) = 1

			_Scale_Acce("Scale Acce", float) = -100
			_Scale_Value("Scale Start Value", float) = 50
			_Scale_Time("Scale Time", float) = 1.5
			_Scale_Limit("Scale Limit", float) = 5
			_Scale_Start("Scale Start", float) = 3

			_Up_Acce("Up Acce", float) = 0
			_Up_Value("Up Start Value", float) = 0
			_Up_Time("Up Time", float) = 1.5
			_Up_Limit("Up Limit", float) = 3
			_Up_Start("Up Start", float) = 3
	}

	Subshader 
	{
		Tags { "Queue"="Transparent+1000" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Fog { Mode Off }
		Cull Off
			Blend SrcAlpha  OneMinusSrcAlpha
			ZWrite Off
			Lighting Off
			Pass 
			{
				CGPROGRAM
#pragma noambient
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma glsl_no_auto_normalization
#include "UnityCG.cginc"                



					struct appdata_t
					{
						float4 vertex : POSITION;
						float2 texcoord : TEXCOORD0;
						float2 texcoord1 : TEXCOORD1;
						float4 color : COLOR;
						float4 tangent : TANGENT;
					};

				struct v2f 
				{ 
					fixed4   pos : SV_POSITION;
					fixed2   uv : TEXCOORD0;
					fixed4   clr : COLOR;
				};

				fixed4 _MainTex_ST;

				float _Alpha_Acce;
				float _Alpha_Value;
				float _Alpha_Time;
				float _Alpha_Limit;
				float _Alpha_Start;

				float _Scale_Acce;
				float _Scale_Value;
				float _Scale_Time;
				float _Scale_Limit;
				float _Scale_Start;

				float _Up_Acce;
				float _Up_Value;
				float _Up_Time;
				float _Up_Limit;
				float _Up_Start;

				v2f vert (appdata_t v)
				{
					v2f o;

					o.clr = v.color;
					float time = _Time.y - v.tangent.z;
					if(time < _Alpha_Time)
					{
						o.clr.a = _Alpha_Start + _Alpha_Value * time + _Alpha_Acce * time * time;

						o.clr.a = min(o.clr.a, _Alpha_Limit);
					}
					else
						o.clr.a = 0;

					if(time < _Scale_Time)
					{
						float scale = _Scale_Start + _Scale_Value * time + _Scale_Acce * time * time;
						scale = min(scale, _Scale_Limit);
						//scale = max(scale, 0);
						scale = max(scale, 0) * v.tangent.w;
						//v.tangent.xy *= scale;
						v.tangent.xy += v.tangent.xy * scale;
					}

					if(time < _Up_Time)
					{
						float4 camspacePos = mul(UNITY_MATRIX_V, v.vertex);
						camspacePos.y += _Up_Start + _Up_Value * time + _Up_Acce * time * time;
						camspacePos.x += v.texcoord1.x * time * time;
						camspacePos = float4( v.tangent.xy + camspacePos.xy, camspacePos.z, 1);
						o.pos = mul (UNITY_MATRIX_P, camspacePos);
						o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					}
					else
					{
						//float4 camspacePos = mul(UNITY_MATRIX_V, v.vertex);
						//o.pos = mul(UNITY_MATRIX_P, camspacePos);
						o.pos = float4( 0,0,0,0 );
					}

					return o;
				}

				sampler2D _MainTex;

				fixed4 frag (v2f i) : COLOR
				{
					fixed4 c = tex2D(_MainTex,i.uv);
					c *= i.clr;
					return c;
				}
				ENDCG
			}
	}
	fallback "Mobile/Unlit (Supports Lightmap)"
}
