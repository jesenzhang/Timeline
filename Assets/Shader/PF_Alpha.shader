
Shader "PF/Alpha" 
{
	Properties {
		_Color("Color (RGBA)", Color) = (0, 0, 0, 1)
	}
	SubShader 
	{
		Tags{"Queue" = "Transparent"}
		pass
		{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

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
