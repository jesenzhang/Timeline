// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Instanced2/WaterSurface"
{
	Properties
	{
		_NormalMap("Normal Map", 2D) = "white" {}
		_ReflMap("Reflection Map", 2D) = "white" {}
		_RippleAmount("Ripple Amount", Float) = 0.5
		
		_WaveMap("Wave Map", 2D) = "white" {}
		_NoiseMap("Noise Map", 2D) = "white" {}
		_TEXP("Tex Params", Vector) = (10.0, 1.0, 1.0, 1.0)

		_WaveSpeed("Wave Speed", Range(5, 20)) = -12.64 //海浪速度
		//_WaveWidth("wave width",range(1,10)) = 2

		_WaterColor("Water Color", Color) = (0.2, 0.27, 0.33)
		_WaterClerity("Water Clerity", Range(0, 1)) = 0.8
		_WaterGlistening("Water Glistening", Range(0, 1)) = 0.8
		_WaveWidth("Wave Width", Range(0, 1)) = 0.2
		_WaveOffshore("Wave Offshore", Range(0, 1)) = 0.5
		_NoiseRange("Noise Range", Range(0, 10)) = 6.43
		_WaveDelta("Wave Delta", float) = 2.43

	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" }
		LOD 100
		//Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL0;
				float4 tangent : TANGENT0;
				float4 color : COLOR0;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
			};

			struct v2f
			{
				//float2 uv : TEXCOORD0;
				float4 vertex      : SV_POSITION;
				float4 clr         : COLOR0;
				float4 tex         : TEXCOORD0;
				float4 tan         : TEXCOORD1;
				float4 ext         : TEXCOORD2;	

				half3  worldNormal : TEXCOORD3;
				half2  pos         : TEXCOORD4;
				half3  worldPos    : TEXCOORD5;
				half4 screenPos    : TEXCOORD6;
			};

			sampler2D _CameraDepthTexture;

			sampler2D _TexNoise;
			float4 _TexNoise_ST;
			float4 _TEXP;

			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			sampler2D _ReflMap;
			float4 _ReflMap_ST;
			
			sampler2D _ReflectiveColor;
			float _RippleAmount;

			sampler2D _WaveMap;
			sampler2D _NoiseMap;

			float4 _WaterColor;
			float _WaterClerity;
			float _WaterGlistening;
			float _WaveSpeed;
			float _WaveWidth;
			float _WaveOffshore;
			float _NoiseRange;
			float _WaveDelta;

			v2f vert (appdata v)
			{
				v2f o;
				float4 vt = v.vertex;
				float4 vm = mul(UNITY_MATRIX_M, vt);
				
				o.vertex = mul(UNITY_MATRIX_VP, vm);

				o.tex.xy = v.uv;
				o.tex.xy*=1.0f/_TEXP.x;
				o.tex.zw = float2(vt.z, o.vertex.z);
				o.tan = v.tangent;
				o.clr = v.color;
				
				float3 vn = mul((float3x3)UNITY_MATRIX_M, v.normal.xyz);
				o.ext.xyz = vn;
				o.ext.w = o.vertex.z;

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos    = worldPos;
				o.worldNormal = normalize(reflect(-worldViewDir, worldNormal));
				o.pos         = v.vertex.xy*0.06;
				o.screenPos   = ComputeScreenPos(UnityObjectToClipPos(v.vertex));
				return o;
			}

			float4 desaturation(float4 c, float k)
			{
				float f = dot(c.xyz, float3(0.3, 0.59, 0.11));
				float3 cc = lerp(c.xyz, f.xxx, k);

				return float4(cc, c.w);
			}

			float3 calcNormal(float2 texcoord)
			{
				float2 p1 = texcoord+float2(0.484, 0.867);
				float2 p2 = texcoord+float2(0.685, 0.447);

				p1.y -= 0.01 * _Time.y;
				p2.y += 0.01 * _Time.y;

				p1 *= 2;
				p2 *= 2;

				float3 n1 = tex2D(_NormalMap, p1); // sampling 1 & 2
				float3 n2 = tex2D(_NormalMap, p2);

				float3 n = (n1 + n2)*0.5;
				n = n * 2 - 2;

				n = lerp(n, float3(0, 1, 0), _RippleAmount);

				return n;
			}

			float3 mReflect(float3 eye, float3 norm)
			{
				return eye - 2 * norm * dot(eye, norm);
			}

			//RGB to HSV  
			fixed3 RGBConvertToHSV(fixed3 rgb)
			{
				fixed R = rgb.x, G = rgb.y, B = rgb.z;
				fixed3 hsv;
				fixed max1 = max(R, max(G, B));
				fixed min1 = min(R, min(G, B));
				if (R == max1)
				{
					hsv.x = (G - B) / (max1 - min1);
				}
				if (G == max1)
				{
					hsv.x = 2 + (B - R) / (max1 - min1);
				}
				if (B == max1)
				{
					hsv.x = 4 + (R - G) / (max1 - min1);
				}
				hsv.x = hsv.x * 60.0;
				if (hsv.x < 0)
					hsv.x = hsv.x + 360;
				hsv.z = max1;
				hsv.y = (max1 - min1) / max1;
				return hsv;
			}

			//HSV to RGB  
			fixed3 HSVConvertToRGB(fixed3 hsv)
			{
				fixed R, G, B;
				//float3 rgb;  
				if (hsv.y == 0)
				{
					R = G = B = hsv.z;
				}
				else
				{
					hsv.x = hsv.x / 60.0;
					int i = (int)hsv.x;
					fixed f = hsv.x - (fixed)i;
					fixed a = hsv.z * (1 - hsv.y);
					fixed b = hsv.z * (1 - hsv.y * f);
					fixed c = hsv.z * (1 - hsv.y * (1 - f));
					if (i == 0)
					{
						R = hsv.z; G = c; B = a;
					}
					else if (i == 1)
					{
						R = b; G = hsv.z; B = a;
					}
					else if (i == 2)
					{
						R = a; G = hsv.z; B = c;
					}
					else if (i == 3)
					{
						R = a; G = b; B = hsv.z;
					}
					else if (i == 4)
					{
						R = c; G = a; B = hsv.z;
					}
					else
					{
						R = hsv.z; G = a; B = b;
					}
				}
				return fixed3(R, G, B);
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 uv;
				uv.xy = i.tex.xy;
				uv.zw = fixed2(0, i.ext.w);
				
				fixed3 n = i.worldNormal;
				float3 v = normalize(i.worldPos.xyz - _WorldSpaceCameraPos.xyz);
				float3 norm = normalize(calcNormal(uv.xy));
				//return fixed4(norm,1);
			
				fixed3 ref = normalize(mReflect(v, norm));
				fixed2 texCoord = ref.xy * 0.5 + 0.5;
				fixed4 reflColor = tex2D(_ReflMap, TRANSFORM_TEX(texCoord, _ReflMap));  // sampling 3

				fixed3 colorFilter_HSV;
				fixed intensityFilter;
				if (_WaterColor.r < 0.01 && _WaterColor.g < 0.01 && _WaterColor.b < 0.01)
				{
					colorFilter_HSV = RGBConvertToHSV(reflColor.rgb);
					intensityFilter = clamp(colorFilter_HSV.z, 0, _WaterGlistening);
				}
				else
				{
					colorFilter_HSV = RGBConvertToHSV(_WaterColor);
					fixed3 intensityFilter_HSV = RGBConvertToHSV(fixed3(reflColor.a, reflColor.a, reflColor.a));
					intensityFilter = clamp(intensityFilter_HSV.z, 0, _WaterGlistening);
				}
				fixed3 colorMode_HSV = fixed3(colorFilter_HSV.x, colorFilter_HSV.y, intensityFilter);
				fixed3 finalWaterColor = HSVConvertToRGB(colorMode_HSV);

				//float shore = i.water.x;
				//float shore = 0;
				half depth = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos));
				depth = LinearEyeDepth(depth);
				half blendFactor = depth - i.screenPos.w;
				//return fixed4(fixed3(blendFactor, blendFactor, blendFactor) * 10, 1);
				float shore = blendFactor*10;
				_WaveWidth = 1 - _WaveWidth;
				_WaveOffshore = 1- _WaveOffshore;
				if (shore>0.01 && shore<0.8)
				{
					fixed4 noiseColor = tex2D(_NoiseMap, texCoord);  // sampling 4 & 5 & 6
					fixed4 waveColor = tex2D(_WaveMap, float2(1 - min(_WaveWidth, shore) / _WaveWidth + _WaveOffshore*sin(_Time.x*_WaveSpeed + noiseColor.r*_NoiseRange), 1)*0.6);
					waveColor.rgb *= (1 - (sin(_Time.x*_WaveSpeed + noiseColor.r*_NoiseRange) + 1) / 2)*noiseColor.r;

					fixed4 waveColor2 = tex2D(_WaveMap, float2(1 - min(_WaveWidth, shore) / _WaveWidth + _WaveOffshore*sin(_Time.x*_WaveSpeed + _WaveDelta + noiseColor.r*_NoiseRange), 1)*0.6);
					waveColor2.rgb *= (1 - (sin(_Time.x*_WaveSpeed + _WaveDelta + noiseColor.r*_NoiseRange) + 1) / 2)*noiseColor.r;

					finalWaterColor += waveColor;
				}

				// water terrain soft particle blend
				return fixed4(finalWaterColor.xyz * 0.8, _WaterClerity*shore);

			}
			ENDCG
		}
	}
}
