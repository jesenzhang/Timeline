Shader "LDJ/Scene/SkyTransparent" 
{
    Properties 
    {
         _Color ("Main Color", Color) = (1.000000,1.000000,1.000000,1.000000)
         _MainTex ("Base (RGB)", 2D) = "white" { }
    }
    SubShader 
    { 
        Pass 
        {
            Tags { "LIGHTMODE"="FORWARDBASE"  "IgnoreProjector"="True"  "QUEUE"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            //#pragma multi_compile_fwdbasealpha noshadow
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #include "UnityCG.cginc"

            // uniforms
            float4 _MainTex_ST;

            // vertex shader input data
            struct appdata {
                float3 pos : POSITION;
                half4 color : COLOR;
                float3 uv0 : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            // vertex-to-fragment interpolators
            struct v2f {
                  //fixed4 color : COLOR0;
                  float2 uv0 : TEXCOORD0;
                  //float2 uv1 : TEXCOORD1;
                  float4 pos : SV_POSITION;
                  UNITY_VERTEX_OUTPUT_STEREO
            };

            // vertex shader
            v2f vert (appdata IN) {
                  v2f o;
                  UNITY_SETUP_INSTANCE_ID(IN);
                  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                  half4 color = IN.color;
                  half3 viewDir = 0.0;
                  //o.color = saturate(color);
                  // compute texture coordinates
                  o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                  //o.uv1 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                  // transform position
                  o.pos = UnityObjectToClipPos(IN.pos);
                  return o;
            }

            // textures
            sampler2D _MainTex;
            fixed4 _Color;

            // fragment shader
            fixed4 frag (v2f IN) : SV_Target {
                  fixed4 tex;
                  // SetTexture #0
                  tex = tex2D (_MainTex, IN.uv0.xy);
                  //col.a = tex.a * IN.color.a;
                  // SetTexture #1
                  //tex = tex2D (_MainTex, IN.uv1.xy);
                  //col.rgb = col * _Color;
                  //col *= 2;
                  //col.a = col.a * _Color.a;
                  return fixed4(tex.rgb * _Color.rgb, tex.a * _Color.a);
            }

            // texenvs
            //! TexEnv0: 01010103 01050107 [_MainTex]
            //! TexEnv1: 02000102 01040106 [_MainTex] [_Color]
            ENDCG
        }
    }
    Fallback " VertexLit"
}