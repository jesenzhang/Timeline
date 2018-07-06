// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Mask_By_Alpha" 
{
	Properties 
	{
		_MainTex ("Main", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
	}
	SubShader 
	{
		Tags { "Queue"="Transparent" "RenderType" = "Transparent"  }
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			sampler2D _MaskTex;

			struct v2f
			{
				half4 pos : POSITION;
				half2 uv  : TEXCOORD;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;

				return o;
			}

			fixed4 frag(v2f v) : COLOR
			{
				fixed4 c = tex2D(_MainTex,v.uv);
				fixed4 m = tex2D(_MaskTex,v.uv);
				c.a *= m.a;
				return c;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
