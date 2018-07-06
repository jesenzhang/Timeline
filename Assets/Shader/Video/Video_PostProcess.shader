// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "LDJ/Video_PostProcess" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}              // 主纹理
		_Brightness ("Brightness", Float) = 1						 // 亮度
		_Saturation("Saturation", Float) = 1					    // 饱和度
		_Contrast("Contrast", Float) = 1						   // 对比度
	}
	//每个shader都有Subshaer，各个subshaer之间是平行关系，只可能运行一个subshader，主要针对不同硬件
	SubShader {
	 	//真正干活的就是Pass了，一个shader中可能有不同的pass，可以执行多个pass  
		Pass {  
		    //关闭了深度写入， 是为了防止它“挡住” 在其后面被渲染的物体
		   //这些状态设置可以认为是用于屏幕后处理的Shader 的“标配”
			ZTest Always Cull Off ZWrite Off
			
			CGPROGRAM  
			#pragma vertex vert  
			#pragma fragment frag  
			  
			#include "UnityCG.cginc"  
			  
			sampler2D _MainTex;  
			half _Brightness;
			half _Saturation;
			half _Contrast;
			  
			struct v2f {
				float4 pos : SV_POSITION;		//顶点位置  
				half2 uv: TEXCOORD0;           //UV坐标  
			};
			  
			v2f vert(appdata_img v) {
				v2f o;
				//从自身空间转向投影空间  
				o.pos = UnityObjectToClipPos(v.vertex);
				//uv坐标赋值给output  
				o.uv = v.texcoord;
						 
				return o;
			}
		
			fixed4 frag(v2f i) : SV_Target {
				//从_MainTex中根据uv坐标进行采样  
				fixed4 renderTex = tex2D(_MainTex, i.uv); 
				
				if(!IsGammaSpace())
				{
					renderTex = half4(LinearToGammaSpace(renderTex.rgb), renderTex.a);
				}
				  
				// Apply brightness
				//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度  
				fixed3 finalColor = renderTex.rgb * _Brightness;
				
				// Apply saturation
				//该公式是一个经验公式
				//saturation饱和度：首先根据公式计算同等亮度情况下饱和度最低的值：  
				fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
				fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
				 //根据Saturation在饱和度最低的图像和原图之间差值  
				finalColor = lerp(luminanceColor, finalColor, _Saturation);
				
				// Apply contrast
				//contrast对比度：首先计算对比度最低的值  
				fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
				//根据Contrast在对比度最低的图像和原图之间差值  
				finalColor = lerp(avgColor, finalColor, _Contrast);
				
				return fixed4(finalColor, renderTex.a);  

			}  
			  
			ENDCG
		}  
	}
	//防止shader失效的保障措施  
	Fallback Off
}
