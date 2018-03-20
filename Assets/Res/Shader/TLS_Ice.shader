// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


Shader "TLStudio/FX/ICE" {
    Properties {
        _MainTexture ("MainTexture", 2D) = "white" {}
        _SpecularColor ("SpecularColor", Color) = (0.5,0.5,0.5,1)
        _Color1 ("Color1", Color) = (0.5,0.5,0.5,1)
        _Color2 ("Color2", Color) = (0.5,0.5,0.5,1)
        _IceDepth ("IceDepth", Range(0, -2)) = 0
        _ReflectMap ("ReflectMap", Cube) = "_Skybox" {}
        _NormalMapUP ("NormalMapUP", 2D) = "bump" {}
        _NormalMapDown ("NormalMapDown", 2D) = "bump" {}
        _UPReflection ("UPReflection", Range(0.5, 1)) = 0.7052907
        _DownReflection ("DownReflection", Range(0.5, 1)) = 1
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3  d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform samplerCUBE _ReflectMap;
            uniform sampler2D _NormalMapDown; uniform float4 _NormalMapDown_ST;
            uniform float _IceDepth;
            uniform float4 _Color1;
            uniform sampler2D _NormalMapUP; uniform float4 _NormalMapUP_ST;
            uniform sampler2D _MainTexture; uniform float4 _MainTexture_ST;
            uniform float4 _SpecularColor;
            uniform float4 _Color2;
            uniform fixed _UPReflection;
            uniform fixed _DownReflection;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = mul(unity_ObjectToWorld, float4(v.normal,0)).xyz;
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
/////// Vectors:
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                fixed3 _NormalMapUP_var = UnpackNormal(tex2D(_NormalMapUP,TRANSFORM_TEX(i.uv0, _NormalMapUP)));
                float2 Depth = (0.05*(_IceDepth - 0.5)*mul(tangentTransform, viewDirection).xy + i.uv0);
                fixed3 _NormalMapDown_var = UnpackNormal(tex2D(_NormalMapDown,TRANSFORM_TEX(Depth.rg, _NormalMapDown)));
                float3 normalLocal = ((_NormalMapUP_var.rgb*0.7)+(_NormalMapDown_var.rgb*0.3));
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 viewReflectDirection = reflect( -viewDirection, normalDirection );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = 0.8;
                float specPow = exp2( gloss * 10.0+1.0);
////// Specular:
                float NdotL = max(0, dot( normalDirection, lightDirection ));
                fixed4 _MainTexture_var = tex2D(_MainTexture,TRANSFORM_TEX(i.uv0, _MainTexture));
                float3 specularColor = (_SpecularColor.rgb*lerp(3.0,_DownReflection,_MainTexture_var.rgb));
                float3 directSpecular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(halfDirection,normalDirection)),specPow);
                float3 specular = directSpecular * specularColor;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 indirectDiffuse = float3(0,0,0);
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float Frecnel = (1.0-max(0,dot(normalDirection, viewDirection)));
                float3 diffuse = (directDiffuse + indirectDiffuse) * (lerp(_Color2.rgb,_Color1.rgb,_MainTexture_var.rgb)*(1.0 - Frecnel));
////// Emissive:
                float node_5242 = lerp(_DownReflection,_UPReflection,_MainTexture_var.rgb);
                float3 emissive = (texCUBE(_ReflectMap,viewReflectDirection).rgb*node_5242);
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
