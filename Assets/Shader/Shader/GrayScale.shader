// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GrayScale" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _MainTex;
	fixed4 _Color;
	struct v2f{
		fixed4 pos:POSITION;
		fixed2 uv:TEXCOORD;
	};
	
	v2f vert(appdata_base i){
		v2f o;
		o.pos = UnityObjectToClipPos(i.vertex);
		o.uv = i.texcoord;
		return o;
	}
	
	fixed4 frag(v2f i):COLOR{
		fixed4 tex = tex2D(_MainTex,i.uv);
		fixed gray = Luminance(tex.rgb);
		tex.rgb = fixed3(gray,gray,gray) * _Color;
		return tex;
	}
	
	ENDCG
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	} 
	// FallBack "Diffuse"
}
