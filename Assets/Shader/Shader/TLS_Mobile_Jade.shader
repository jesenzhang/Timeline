// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TLStudio/FX/Jade" {
    Properties {
        _main ("MainTexture", 2D) = "white" {}
        _SpecularColor ("SpecularColor", Color) = (1,1,1,1)
        _SSSColor ("SSS", Color) = (0,0,0,1)
        _normal ("NormalTexture", 2D) = "bump" {}
        _rel_EL ("ReflectionTexture", 2D) = "white" {}
        _AmbientLight ("AmbientLight", Color) = (0.5,0.5,0.5,1)
       _lightDrectiotn ("LightDrection (0<w<1)",vector) = (0,0,0,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 250
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fog
            #pragma target 3.0
            uniform fixed4 _SSSColor;
            uniform sampler2D _main; uniform float4 _main_ST;
            uniform fixed4 _SpecularColor;
            uniform sampler2D _normal; uniform float4 _normal_ST;
            uniform sampler2D _rel_EL;
            uniform fixed4 _AmbientLight;
            uniform fixed4 _lightDrectiotn;
            struct VertexInput {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
                half4 tangent : TANGENT;
                half2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
				fixed3 normalDir : TEXCOORD2;
				fixed3 tangentDir : TEXCOORD3;
				fixed3 bitangentDir : TEXCOORD4;
				half2 capUV : TEXCOORD5;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                //将法线规格化操作放到顶点渲染
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
				half2 capCoord;
				capCoord.x = dot(UNITY_MATRIX_IT_MV[0].xyz, v.normal);
				capCoord.y = dot(UNITY_MATRIX_IT_MV[1].xyz, v.normal);
				o.capUV = capCoord * 0.5 + 0.5;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
				half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                half3 normalLocal = UnpackNormal(tex2D(_normal,TRANSFORM_TEX(i.uv0, _normal)));
				half3 normalDirection = normalize(mul( normalLocal, tangentTransform ));
				half3 lightDirection = normalize(_lightDrectiotn.xyz);
				
				//LightDirection 在低端机(iphone5C)不能是零向量 如果为零向量参与任何计算都会造成计算结果不正确,如果希望使用光照方向（光照非零）则使用下面注释行的计算方式。
				//half3 halfDirection = normalize(viewDirection+lightDirection);
				half3 halfDirection = normalize(viewDirection);
				//对颜色贴图进行采样
				fixed4 _main_var = tex2D(_main, TRANSFORM_TEX(i.uv0, _main));
				//预留了gb通道 可以制作彩色反射效果 如果多添加一次采样可以将gloss信息放到这里
				fixed4 rel_var = tex2D(_rel_EL, i.capUV);
				///////// Gloss:
                fixed gloss = _main_var.a;
                float specPow = gloss *_SpecularColor.a*128+1.0;
                ////// Specular:
				fixed3 specular =pow(max(0,dot(halfDirection,normalDirection)),specPow)*_SpecularColor.rgb;
                /////// Diffuse:
				
				//LightDirection 在低端机(iphone5C)不能是零向量 如果为零向量参与任何计算都会造成计算结果不正确,如果希望使用光照方向（光照非零）则使用下面注释行的计算方式。
				//这里N.L取-1到1而不是0到1
				//fixed3 NdotL = dot( normalDirection, lightDirection );
				fixed3 NdotL = dot( normalDirection, viewDirection );
				fixed3 _3S = (_SSSColor.rgb*_SSSColor.a*2);
				fixed3 NdotLWrap = NdotL * ( 1.0 - _3S);
				fixed3 directDiffuse = max(float3(0.0,0.0,0.0), NdotLWrap + _3S);
                fixed3 diffuseColor = _main_var.rgb*_AmbientLight.a;
				fixed3 diffuse = directDiffuse * diffuseColor;
                 ////// Reflection:
				fixed3 rel = (_lightDrectiotn.w*rel_var.r)+_AmbientLight.rgb*_main_var.rgb;
                /// Final Color:
				fixed3 finalColor = diffuse + specular + rel;
                fixed4 finalRGBA = fixed4(finalColor,1);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Mobile/Unlit (Supports Lightmap)"
}
