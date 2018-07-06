// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Simplified Additive Particle shader. Differences from regular Additive Particle one:
// - no Tint color
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "TLStudio/Effect/AdditiveMultiColorGradient" {
Properties {
	_ColorA("Color1",Color) =  (0,0,0,1)
	_ColorB("Color2",Color) = (1,1,1,1)
	_ControlTex ("Control Texture alpha(B)", 2D) = "white" {}
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend One One
	Cull Off ZWrite Off Fog { Color (0,0,0,0) }
	
	SubShader {
	LOD 150
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : Color;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : Color;
			};

			fixed4 _ColorA;
			fixed4 _ColorB;
			sampler2D _ControlTex;
			float4  _ControlTex_ST;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _ControlTex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 ctrlTex = tex2D(_ControlTex, i.texcoord);
			    fixed3 col = (_ColorA*ctrlTex.r + _ColorB*ctrlTex.g)*ctrlTex.a*i.color;
				return fixed4 (col,ctrlTex.a*i.color.a);
			}
			ENDCG
		}
	}
}
}