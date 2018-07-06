// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/FX/WaterMali" {
    Properties {
		_AmbientColor ("Amb Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _WaterTexture ("WaterTexture", 2D) = "white" {}
        _Normal ("Normal", 2D) = "bump" {}
        _WaveSpeed ("WaterSpeed", Vector) = (0,0,0,0)
        _RelDistortion ("RelDistortion", Float ) = 0.0
        _Reflection ("Reflection", Cube) = "_Skybox" {}
        _Alpha("Alpha", Range(0,1) ) = 0
        _lightDirection("LightDirection",Vector) = (1,0,0,1)
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 150
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma target 3.0
            uniform float4 _lightDirection;
            uniform float4 _TimeEditor;
			uniform float4 _AmbientColor;
            uniform sampler2D _WaterTexture; uniform float4 _WaterTexture_ST;
            uniform sampler2D _Normal; uniform float4 _Normal_ST;
            uniform float4 _WaveSpeed;
            uniform fixed _RelDistortion;
            uniform float  _Alpha;
            uniform samplerCUBE _Reflection;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD3;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 Timer = _Time + _TimeEditor;
                o.uv0 = v.texcoord0+_WaveSpeed.xy*Timer.r;
                o.uv1 = v.texcoord0+_WaveSpeed.zw*Timer.r;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_lightDirection.xyz);
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 indirectDiffuse = float3(0,0,0);
                float3 directDiffuse = max( 0.0, NdotL)* _lightDirection.w;
                //indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
				indirectDiffuse += _AmbientColor.rgb; // Ambient Light
               
                float2 uv1 = i.uv0;
                float2 uv2 = i.uv1;
                half3 _UVOffset1 = UnpackNormal(tex2D(_Normal,uv1));
                half3 _UVOffset2 = UnpackNormal(tex2D(_Normal,uv2));
                half3 _UVOffset = (_UVOffset1+_UVOffset2)*0.5;
                fixed4 _WaterTexture_var = tex2D(_WaterTexture,uv1);
                float rim =max(0,dot(i.normalDir,viewDirection));
                float3 diffuse = (directDiffuse + indirectDiffuse) * (_WaterTexture_var.rgb+texCUBE(_Reflection,normalize((((_UVOffset.rgb+(-0.5))*_RelDistortion)+viewReflectDirection))).rgb*(1-rim));
                float3 finalColor = diffuse;
                return fixed4(finalColor,1-rim*_Alpha);
            }
            ENDCG
        }
    }
}
