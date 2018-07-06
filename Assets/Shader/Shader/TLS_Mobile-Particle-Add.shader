// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Simplified Additive Particle shader. Differences from regular Additive Particle one:
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "TLStudio/Effect/Additive" {
Properties {
	_TintColor("TintColor", Color) = (1,1,1,1)
	_MainTex ("Particle Texture", 2D) = "white" {}
}
Subshader{
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha One
	Cull Off 
	Lighting Off 
	ZWrite Off 
	Fog { Color (0,0,0,0) }
	ColorMask RGBA
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
			sampler2D _MainTex;
			float4  _MainTex_ST;
			float4 _TintColor;
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 MainTex_Var = tex2D(_MainTex, i.texcoord);
			    fixed4 col = MainTex_Var*i.color*_TintColor;
				return  col;
			}
			ENDCG
		}
		}
}