// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "TLStudio/Opaque/Diffuse" {
Properties {
	_Color("Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 200

CGPROGRAM
#pragma surface surf Lambert noforwardadd

sampler2D _MainTex;
fixed4 _Color;

struct Input {
	float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb*_Color.rgb;
	//o.Alpha = c.a*_Color.a;
}
ENDCG
        	Pass
	{
		Name "ShadowCollector"
		Tags { "LightMode" = "ShadowCollector" }
		
		Fog {Mode Off}
		ZWrite On ZTest LEqual

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_shadowcollector

		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"

		struct appdata {
			float4 vertex : POSITION;
		};

		struct v2f {
			V2F_SHADOW_COLLECTOR;
		};

		v2f vert (appdata v)
		{
			v2f o;
			TRANSFER_SHADOW_COLLECTOR(o)
			return o;
		}

		fixed4 frag (v2f i) : SV_Target
		{
			SHADOW_COLLECTOR_FRAGMENT(i)
		}
		ENDCG
	}
}

Fallback "TLStudio/Opaque/UnLit"
}
