// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:Particles/Additive,iptp:0,cusa:False,bamd:0,cgin:,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:False,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:False,igpj:False,qofs:0,qpre:3,rntp:3,fgom:False,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4795,x:32724,y:32693,varname:node_4795,prsc:2|emission-2393-OUT,clip-5652-OUT;n:type:ShaderForge.SFN_Tex2d,id:6074,x:31992,y:32520,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2393,x:32504,y:32788,varname:node_2393,prsc:2|A-6074-RGB,B-2053-RGB,C-797-RGB,D-789-OUT,E-797-A;n:type:ShaderForge.SFN_VertexColor,id:2053,x:31548,y:32801,varname:node_2053,prsc:2;n:type:ShaderForge.SFN_Color,id:797,x:31992,y:32769,ptovrint:False,ptlb:Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:5652,x:32495,y:33118,varname:node_5652,prsc:2|A-4111-OUT,B-2053-A,C-9522-OUT;n:type:ShaderForge.SFN_ValueProperty,id:789,x:32235,y:32971,ptovrint:False,ptlb:Glow,ptin:_Glow,varname:_Glow,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:2;n:type:ShaderForge.SFN_Tex2d,id:1012,x:31740,y:33039,ptovrint:False,ptlb:rongjie_tex,ptin:_rongjie_tex,varname:_rongjie_tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Add,id:4111,x:31980,y:33081,varname:node_4111,prsc:2|A-1012-R,B-1012-G,C-1012-B,D-5697-OUT;n:type:ShaderForge.SFN_Vector1,id:5697,x:31740,y:33295,varname:node_5697,prsc:2,v1:0.5;n:type:ShaderForge.SFN_ValueProperty,id:9522,x:32269,y:33224,ptovrint:False,ptlb:RJ,ptin:_RJ,varname:_RJ,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:797-6074-1012-789-9522;pass:END;sub:END;*/

Shader "LDJ/Fx/Additive_Disslove" {
    Properties {
        _TintColor ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _rongjie_tex ("rongjie_tex", 2D) = "white" {}
        _Glow ("Glow", Float ) = 2
        _RJ ("RJ", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float4 _TintColor;
            uniform float _Glow;
            uniform sampler2D _rongjie_tex; uniform float4 _rongjie_tex_ST;
            uniform float _RJ;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _rongjie_tex_var = tex2D(_rongjie_tex,TRANSFORM_TEX(i.uv0, _rongjie_tex));
                clip(((_rongjie_tex_var.r+_rongjie_tex_var.g+_rongjie_tex_var.b+0.5)*i.vertexColor.a*_RJ) - 0.5);
////// Lighting:
////// Emissive:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*_Glow*_TintColor.a);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal n3ds wiiu 
            #pragma target 3.0
            uniform sampler2D _rongjie_tex; uniform float4 _rongjie_tex_ST;
            uniform float _RJ;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 _rongjie_tex_var = tex2D(_rongjie_tex,TRANSFORM_TEX(i.uv0, _rongjie_tex));
                clip(((_rongjie_tex_var.r+_rongjie_tex_var.g+_rongjie_tex_var.b+0.5)*i.vertexColor.a*_RJ) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Particles/Additive"
    CustomEditor "ShaderForgeMaterialInspector"
}
