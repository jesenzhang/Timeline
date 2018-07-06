// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RadialBlur" 
{
     Properties 
     {
         _MainTex ("Base (RGB)", 2D) = "white" {}
         _SampleDist("SampleDist", Float) = 1 
         _SampleStrength("SampleStrength", Float) = 2.2 
     }
     SubShader 
     {
         Pass 
         {               
             ZTest Always 
             Cull Off 
             ZWrite Off
             Fog { Mode off }  
             CGPROGRAM
             #include "UnityCG.cginc"  
             #pragma vertex vert
             #pragma fragment frag            

             sampler2D _MainTex;
             float _SampleDist;
             float _SampleStrength;   
             // some sample positions  
             static const float samples[6] =   
             {   
                -0.05,  
                -0.03,    
                -0.01,  
                0.01,    
                0.03,  
                0.05,  
             }; 
             struct v2f 
             {
                 float4 vertex : POSITION;
                 float2 uv : TEXCOORD;
             };
             
             v2f vert(appdata_base v)
             {
                 v2f o;
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 o.uv = v.texcoord;
                 return o;
             }                       
             
             half4 frag(v2f v) : COLOR
             {
             	float2 center = float2(0.5,0.5);
                float2 dir = center - v.uv;
                float dist = length(dir);  
                dir = normalize(dir); 
                float4 color = tex2D(_MainTex, v.uv);  

                float4 sum = color;
                for (int i = 0; i < 6; ++i)  
                {                                                
                   sum += tex2D(_MainTex, v.uv + dir * samples[i] * _SampleDist);    
                }  
                sum /= 7.0f;  

                float t = saturate(dist * _SampleStrength);                 
                return lerp(color, sum, t);              
             }
             ENDCG 
         }
     } 
     Fallback off
 }