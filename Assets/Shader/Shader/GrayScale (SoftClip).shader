// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GrayScale (SoftClip)" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _MainTex;
	fixed4 _MainTex_ST;
	fixed2 _ClipSharpness = fixed2(20.0, 20.0);
	fixed4 _Color;


	struct v2f{
		fixed4 pos:POSITION;
		fixed2 uv:TEXCOORD;
		fixed2 worldPos : TEXCOORD1;
	};
	
	v2f vert(appdata_base i){
		v2f o;
		o.pos = UnityObjectToClipPos(i.vertex);
		o.uv = i.texcoord;
		o.worldPos = TRANSFORM_TEX(i.vertex.xy, _MainTex);
		return o;
	}
	
	fixed4 frag(v2f i):COLOR{
		// Softness factor
		fixed2 factor = (fixed2(1.0, 1.0) - abs(i.worldPos)) * _ClipSharpness;
		fixed fade = clamp( min(factor.x, factor.y), 0.0, 1.0);

		fixed4 tex = tex2D(_MainTex,i.uv);
		fixed gray = Luminance(tex.rgb);
		tex.rgb = fixed3(gray,gray,gray) * _Color;

		//for ngui clip
		tex.rgb = lerp(fixed3(0,0,0),tex.rgb,fade);
		tex.a *= fade;
		
		return tex;
	}
	
	ENDCG
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Blend One OneMinusSrcAlpha
		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	} 
	// FallBack "Diffuse"
}
