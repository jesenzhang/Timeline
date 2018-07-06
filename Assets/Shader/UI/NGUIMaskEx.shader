Shader "UI/NGUIMaskEx"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}

		_MaskTex ("Mask Texture", 2D) = "white" {}
		_MaskRect ("Mask Rect",Vector) = (0,0,1,1)
		_MaskTexOffset ("Mask Offset",Vector) = (0,0,1,1)
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"DisableBatching" = "True"
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
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
				UNITY_VERTEX_OUTPUT_STEREO
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}

			sampler2D _MaskTex;
			float4 _MaskRect;
			float4 _MaskTexOffset;
				
			fixed4 frag (v2f IN) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, IN.texcoord) * IN.color;
				if(_MaskRect.z > 0 && _MaskRect.w > 0){
					half2 clipStart = (IN.texcoord - _MaskTexOffset.xy) / _MaskTexOffset.zw - _MaskRect.xy;

					clipStart.x = (clipStart.x / _MaskRect.z);
					clipStart.y = (clipStart.y / _MaskRect.w);

					if(clipStart.x >= 0 && clipStart.x <=1 && clipStart.y >= 0 && clipStart.y<=1){
						half4 mask = tex2D(_MaskTex,clipStart);
						color.a *= 1 - mask.a;
					}
				}
				return color;
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
			"DisableBatching" = "True"
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
