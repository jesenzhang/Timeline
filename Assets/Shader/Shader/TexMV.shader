// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Custom-Swtil" {
    Properties {
        _Slider("Slider", range(0, 100)) = 1
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200
         
        Pass
        {
         
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
             
            sampler2D _MainTex;
             
            float _Slider;
             
            float4 _MainTex_ST;
             
            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };
 
            v2f vert(appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }
             
            float4 frag(v2f i) : COLOR
            {       
                float2 tc = i.uv;
                tc -= float2(0.5,0.5);
                float dist = length(tc);
                float radius = 0.5f;
                if (dist < radius) 
                {
                    float percent = (radius - dist) / radius;
                    float theta = percent * _Slider ;
                    float s = sin(theta);
                    float c = cos(theta);
                    tc = float2(dot(tc, float2(c, -s)), dot(tc, float2(s, c)));
                }
                tc += float2(0.5,0.5);
                float3 color = tex2D(_MainTex, tc).rgb;
                return float4(color, 1.0);
            }
             
            ENDCG
        }
    } 
    FallBack "Diffuse"
}
