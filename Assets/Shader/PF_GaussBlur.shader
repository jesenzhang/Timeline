// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PF/ImageEffect/GaussBlur" 
{
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	sampler2D _MainTex;
	half4 _MainTex_TexelSize;
	half _DownSampleValue;

	static const half4 GaussWeight[7] = 
	{
		half4(0.0205,0.0205,0.0205,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.232,0.232,0.232,0),
		half4(0.324,0.324,0.324,0),
		half4(0.232,0.232,0.232,0),
		half4(0.0855,0.0855,0.0855,0),
		half4(0.0205,0.0205,0.0205,0),
	};

	struct v2f
	{
		half4 pos : POSITION;
		half2 uv  : TEXCOORD0;
		half2 offset : TEXCOORD1;
	};

	v2f vert_gaussblurH(appdata_base v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		o.offset = _MainTex_TexelSize.xy * half2(1,0) * _DownSampleValue;

		return o;
	}

	v2f vert_gaussblurV(appdata_base v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		o.offset = _MainTex_TexelSize.xy * half2(0,1) * _DownSampleValue;

		return o;
	}

	half4 frag_gaussblur(v2f v) : COLOR
	{
		half2 offset = v.offset;
		half2 finalUV = v.uv - offset * 3.0;
		half4 c = 0;

        c += tex2D(_MainTex, finalUV) * GaussWeight[0];  
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[1];  
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[2]; 
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[3]; 
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[4]; 
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[5];  
        finalUV += offset;

        c += tex2D(_MainTex, finalUV) * GaussWeight[6]; 
        finalUV += offset;

		return c;
	}
	ENDCG

	SubShader
	{
		ZTest Always
		Cull Off
		ZWrite Off
		Fog{Mode Off}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_gaussblurV
			#pragma fragment frag_gaussblur
			ENDCG
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_gaussblurH
			#pragma fragment frag_gaussblur
			ENDCG
		}
	}
}
