// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TLStudio/Opaque/Diffuse-Ice2" {
    Properties {
		_Color("Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_IceTex("Ice Texture", 2D) = "white" {}
  _IceEfFadingProgress("IceEf Fading Progress", Range(0, 1)) = 0.0
  _Lum("Luminace", float) = 20.0
  //_RValue("Rvalue", Range(0, 1)) = 0.0
  _Reflection ("Reflection", 2D) = "white" {}
		_ReflectionIntension("Reflection Intensity",Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
		LOD 150
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
			uniform fixed4 _Color;
			uniform sampler2D   _IceTex;
			uniform fixed       _Lum;
			uniform fixed       _IceEfFadingProgress;
			//uniform fixed       _RValue;
            //uniform float4 _LightColor0;
            uniform fixed _ReflectionIntension;
            uniform sampler2D _Reflection;
            uniform float4 _Reflection_ST;

            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                fixed3 viewDirection : TEXCOORD1;
                fixed3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.viewDirection = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                //fixed3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
/////// Vectors:
                //fixed3 normalDirection = i.normalDir;
				fixed4 _MainTexColor = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                fixed3 ice = tex2D(_IceTex, i.uv0).rgb;
                //fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                //fixed3 lightColor = _LightColor0.rgb;
/////// Diffuse:
                //fixed NdotL = max(0.45,dot( normalDirection, lightDirection ));
                //fixed3 indirectDiffuse = UNITY_LIGHTMODEL_AMBIENT.rgb*2;
                fixed gray = dot( fixed3(0.299,0.587,0.114), _MainTexColor.rgb );
                //fixed3 diffuse =  lerp(_MainTexColor.rgb, ice.rgb,  saturate(( 1 - (_MainTexColor.r  - _RValue) * 2)));
                fixed3 diffuse =  lerp(_MainTexColor.rgb, ice.rgb * gray,  _IceEfFadingProgress);
////// Emissive:
                half2 ReflUV = ((normalize(mul( UNITY_MATRIX_V, float4(i.normalDir,0) ).xyz.rgb).rg * 0.5) + 0.5);
                fixed4 _Reflection_var = tex2D(_Reflection, TRANSFORM_TEX(ReflUV, _Reflection));
				//fixed ReflectionRange = tex2D(_Reflection, TRANSFORM_TEX(i.uv0, _MainTex));
                fixed3 emissive = _Color.rgb * _Reflection_var.rgb * _ReflectionIntension;
				//float3 emissive = _Color.rgb + _Reflection_var.rgb*ReflectionRange;
/// Final Color:
                fixed3 finalColor = diffuse + emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
			FallBack "Mobile/Diffuse"
}
