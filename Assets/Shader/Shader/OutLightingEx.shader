// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Custom/OutLightingEx"
{
	Properties {
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
			_Outline ("Outline width", Range (.002, 0.03)) = .005
			_MainTex ("Base (RGB)", 2D) = "white" { }


		_DiffuseStep("_DiffuseStep 0.1-3",Range(0.1,3)) = 0.5
			_SpecFacStep("_SpecFacStep 0.1-3",Range(0.1,3)) = 1
	}
	SubShader
	{
		pass
		{
			Name "OUTLINE"
				Tags { "LightMode" = "Always"}
			Cull front

				CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
				sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform float _Outline;
			uniform float4 _OutlineColor;

			struct v2f {
				float4 pos : POSITION;
				float4 color : COLOR;
			};
			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 offset = TransformViewToProjection(norm.xy);

				o.pos.xy += offset * o.pos.z * _Outline;
				o.color = _OutlineColor;
				return o;
			}
			float4 frag (v2f i) : COLOR
			{
				return i.color;
			}
			ENDCG
		}

		pass
		{
			tags{"LightMode"="Vertex"}
			CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"
				sampler2D _MainTex;
			float4 _MainTex_ST;
			float _DiffuseStep;
			float _SpecFacStep;
			struct v2f {
				float4  pos : SV_POSITION;
				float2  uv : TEXCOORD0;
				float3 normal:TEXCOORD1;
				float3 lightDir:TEXCOORD2;
				float atten:TEXCOORD3;
				float3 viewDir:TEXCOORD4;
			} ;


			float4x4 inverse(float4x4 input)
			{
#define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
				//determinant(float3x3(input._22_23_23, input._32_33_34, input._42_43_44))

				float4x4 cofactors = float4x4(
						minor(_22_23_24, _32_33_34, _42_43_44), 
						-minor(_21_23_24, _31_33_34, _41_43_44),
						minor(_21_22_24, _31_32_34, _41_42_44),
						-minor(_21_22_23, _31_32_33, _41_42_43),

						-minor(_12_13_14, _32_33_34, _42_43_44),
						minor(_11_13_14, _31_33_34, _41_43_44),
						-minor(_11_12_14, _31_32_34, _41_42_44),
						minor(_11_12_13, _31_32_33, _41_42_43),

						minor(_12_13_14, _22_23_24, _42_43_44),
						-minor(_11_13_14, _21_23_24, _41_43_44),
						minor(_11_12_14, _21_22_24, _41_42_44),
						-minor(_11_12_13, _21_22_23, _41_42_43),

						-minor(_12_13_14, _22_23_24, _32_33_34),
						minor(_11_13_14, _21_23_24, _31_33_34),
						-minor(_11_12_14, _21_22_24, _31_32_34),
						minor(_11_12_13, _21_22_23, _31_32_33)
						);
#undef minor
				return transpose(cofactors) / determinant(input);
			}

			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.normal = v.normal;
/*
#ifndef USING_DIRECTIONAL_LIGHT
				float3 lightPos = mul( inverse(UNITY_MATRIX_MV),unity_LightPosition[0]).xyz;
				o.lightDir = lightPos;
#else
				o.lightDir = mul( inverse(UNITY_MATRIX_MV),unity_LightPosition[0]).xyz;
#endif
*/
				o.lightDir = mul( inverse(UNITY_MATRIX_MV),unity_LightPosition[0]).xyz;

				float3 viewpos = mul (UNITY_MATRIX_MV, v.vertex).xyz;
				float3 toLight = unity_LightPosition[0].xyz - viewpos.xyz * unity_LightPosition[0].w;
				float lengthSq = dot(toLight, toLight);
				o.atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[0.5].z);

				o.viewDir = mul ((float3x3)inverse(UNITY_MATRIX_MV), float3(0,0,1)).xyz;
				return o;
			}
			float4 frag (v2f i) : COLOR
			{
				float4 texCol = tex2D(_MainTex,i.uv);
				i.normal = normalize(i.normal);
				i.lightDir = normalize(i.lightDir);
				i.viewDir = normalize(i.viewDir);
				//(1)漫反射强度
				float diffuseF = max(0,dot(i.normal,i.lightDir));

				//*** 漫反射光离散化 ***
				diffuseF = floor(diffuseF* _DiffuseStep)/_DiffuseStep;
				//(2)镜面反射强度
				float specF;
				float3 H = normalize(i.lightDir + i.viewDir);
				float specBase = max(0,dot(i.normal,H));
				// shininess 镜面强度系数
				specF = pow(specBase,35);

				//*** 镜面反射光离散化 ***
				specF = floor(specF* _SpecFacStep)/_SpecFacStep;

				//(3)结合漫反射光与镜面反射光
				float4 outp = texCol*unity_LightColor[0]*(0.9 + 0.5* diffuseF*i.atten )+ unity_LightColor[0]*specF *1;
				return outp;
			}
			ENDCG
		}
	}
}
