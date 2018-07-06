// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "TLStudio/FX/Shadow" { 
	Properties {
		_ShadowTex ("Cookie", 2D) = "gray" {}
	}
	Subshader {
		Tags {"Queue"="Transparent"}
		LOD 100
		Pass {
			ZWrite Off
			ColorMask RGB
			Blend DstColor Zero
			Offset -1, -1
 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;
				float4 pos : SV_POSITION;
			};
			
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (vertex);
				o.uvShadow = mul (unity_Projector, vertex);
				o.uvFalloff = mul(unity_ProjectorClip, vertex);
				return o;
			}
			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 texS = tex2Dproj (_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
			    texS = 1 - min(1,ceil(texS.r+texS.g+texS.b))+0.3;
				return texS;
			}
			ENDCG
		}
	}
}
