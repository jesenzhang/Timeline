Shader "PF/Alpha double sided"
{
	Properties 
	{ 
		_Color("Main Color", Color) = (1.0, 0.0, 0.0, 0.7) 
	}
	SubShader
	{
	   Tags { "RenderType"="Transparent" "Queue"="Transparent"}
	   Pass 
	   {
			Blend SrcAlpha OneMinusSrcAlpha 
			ZWrite Off 
		    ColorMask RGB 
		    Cull off 
		    Color [_Color] 
		    Offset -1, -1
			Material { Diffuse [_Color] Ambient [_Color] }
			Lighting Off
			SetTexture [_Dummy] { combine primary double, primary }
		}
	}
}