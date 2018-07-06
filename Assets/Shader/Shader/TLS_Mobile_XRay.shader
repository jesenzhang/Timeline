// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TLStudio/FX/XRayPlayer" {
    Properties {
		_ShadeColor ("Shade Color", Color) = (0.7, 0.3, 0.6, 1)
    }
    SubShader {
        Tags {
            "Queue" = "AlphaTest+5" "RenderType"="Transparent"
        }
        LOD 200
		Pass
		{
		   Blend One One
           Lighting Off   
		   ZTest Greater 
		   ZWrite Off
		   CGPROGRAM
		   #pragma vertex vert
		   #pragma fragment frag
		   #pragma fragmentoption ARB_precision_hint_fastest   
   
		   float4 _ShadeColor;
		   struct appdata
		   {
				float4 vertex : POSITION;
				float3 _normal : NORMAL;
				half2 uv0 : TEXCOORD0;
		   };

		   struct v2f
		   {
				float4 pos : POSITION; 
				float2 uv0 : TEXCOORD0;  
		   };

		   v2f vert(appdata v)
		   {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv0 = v.uv0;
				return o;
		   }
		   float4 frag(v2f i) : COLOR
		   {
				return _ShadeColor;
		   }
		   ENDCG
		}  
    }
    FallBack "Diffuse"
}
