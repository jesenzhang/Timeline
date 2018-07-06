// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// MatCap Shader, (c) 2015-2017 Jean Moreno

Shader "Custom/UIMask"
{
	Properties
	{ 
	}

		Subshader
	{
		Tags{ "Queue" = "Transparent+120" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		Lighting Off
		//ZWrite On
		//ZTest On
		Pass
	{

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		struct v2f
	{
		float4 pos	: SV_POSITION;
	};

	v2f vert(appdata_base v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}
	 
	float4 frag(v2f i) : COLOR
	{
		float4 mc = float4(1,1,1,0);
		return mc;
	}
		ENDCG
	}
	}

	Fallback "VertexLit"
}
