// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UIEffect/Outline"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {} 
		_Outline ("OutLine Width",Range(0,30)) = 10 
		_TimeX ("Time", Range(0.0, 1.0)) = 1.0
		_TextureSize ("_TextureSize", Vector) = (1024,1024,0,0)
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST; 

			float _Outline;
			float _TimeX;
			float4 _TextureSize;
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				fixed gray: TEXCOORD1;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				o.gray = dot(v.color,fixed4(1,1,1,0));
				return o;
			}
			 

			float near_color(half2 texcood,half offsetx,half offsety){
				float alpha = tex2D(_MainTex, half2(texcood.x+offsetx,texcood.y+offsety)).a;
				if (alpha > 0.001)
					return 1;
				return 0;
			}

			fixed4 outline(fixed4 col,half2 texcood,float width){
				float factor = col.a;
				if(factor < 0.1 ){
					float v = 0; 
					fixed count = 0;
					float stepX  = 1 / _TextureSize.x * _Outline;
					float stepY  = 1 / _TextureSize.y * _Outline;
					int radius = 5;
					for(int x = -radius;x<=radius;x+=1){
						for(int y = -radius;y<=radius;y+=1){
							v += near_color(texcood,x * stepX,y * stepY); 
							count++;
						}
					}
					if(v >=1 && count >=1)
						col.rgba = float4(1,0,0,v/count);
				}
				return col;
			}
				
			fixed4 frag (v2f IN) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, IN.texcoord); 
				col = outline(col,IN.texcoord);
				return  col;
			}
			ENDCG
		}
	}

	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			//ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
