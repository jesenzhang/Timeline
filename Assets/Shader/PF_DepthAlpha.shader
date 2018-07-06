// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PF/DepthAlpha"
{
	Properties {
		_Color("Color (RGBA)", Color) = (0, 0, 0, 1)
	}
	SubShader {
		pass
		{
 			Tags{ "Queue" = "Transparent + 120"  "IgnoreProjector" = "True" "RenderType" = "Transparent"}

			Blend SrcAlpha OneMinusSrcAlpha

			ZWrite Off
			Cull Back
			Lighting Off


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			half4 _Color;

			struct v2f
			{
				half4 pos : POSITION;
			};
		
			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				return _Color;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
