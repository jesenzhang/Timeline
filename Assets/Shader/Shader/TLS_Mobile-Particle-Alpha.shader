// Simplified Alpha Blended Particle shader. Differences from regular Alpha Blended Particle one:
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "TLStudio/Effect/AlphaBlended" {
Properties {
	_TintColor("Tint Color", Color) = (1,1,1,1)
	_MainTex ("Particle Texture", 2D) = "white" {}
}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off Lighting Off ZWrite Off
	
	BindChannels {
	    Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}
	
	SubShader {
	LOD 150
		Pass {
			SetTexture[_MainTex]{
			combine texture * Primary,texture*Primary
			}
			SetTexture[_MainTex]{
			constantColor[_TintColor]
			combine Previous  * constant  Double, Previous * constant
			}
		}
	}
}
}