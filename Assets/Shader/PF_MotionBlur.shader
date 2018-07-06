// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "PF/ImageEffect/MotionBlur" 
{
	Properties 
	{
		_MainTex ("MainTex", 2D) = "white" {}
		_AccumOrig("AccumOrig", Float) = 0.65
		_Center("Center",Vector) = (1,1,1,1)
		_Forward("Forward",Vector) = (1,1,1,1)
		_Angle("Angle",Float) = 1
		_Radius("Radius",Float) = 1
	}

    SubShader 
    { 
		ZTest Always 
		Cull Off 
		ZWrite Off
		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMask RGB
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _AccumOrig;
			sampler2D _MainTex;

			struct v2f 
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
				
			half4 frag (v2f v) : COLOR
			{
				return half4(tex2D(_MainTex, v.uv).rgb, _AccumOrig);
			}
			ENDCG 
		} 

		Pass 
		{
			Blend One Zero
			ColorMask A
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
				
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			struct v2f 
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			half4 frag (v2f v) : COLOR
			{
				return tex2D(_MainTex, v.uv);
			}
			ENDCG 
		}

		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
				
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Center;
			float4 _Forward;
			float _Angle;

			struct v2f 
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			half4 frag (v2f v) : COLOR
			{
				float4 c = tex2D(_MainTex, v.uv);

				float2 v1 = normalize(_Forward.xy - _Center.xy);
				float2 v2 = normalize(v.uv - _Center.xy);
				float cosV = dot(v1,v2);

				if(cosV < _Angle)
				{
					c.a = 1;
				}
				else
				{
					float a = 1 / (_Angle - 1);
					float b = -a;
					c.a = (cosV - 1) / (_Angle - 1);
				}
				return c;
			}
			ENDCG 
		}

		Pass 
		{
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
				
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Center;
			float _Radius;

			struct v2f 
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			half4 frag (v2f v) : COLOR
			{
				float4 c = tex2D(_MainTex, v.uv);
				float dis = length(v.uv - _Center.xy);
				c.a = saturate(dis * _Radius);
				return c;
			}
			ENDCG 
		}
	}
}
