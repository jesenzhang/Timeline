// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33440,y:32663,varname:node_4013,prsc:2|emission-7976-OUT,alpha-9375-OUT;n:type:ShaderForge.SFN_Tex2d,id:2666,x:32668,y:32893,ptovrint:False,ptlb:node_2666,ptin:_node_2666,varname:node_2666,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0e19bbb97b4dffe458e1acd24c065aa3,ntxv:0,isnm:False|UVIN-9477-UVOUT;n:type:ShaderForge.SFN_TexCoord,id:1272,x:32240,y:32893,varname:node_1272,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Panner,id:9477,x:32483,y:32893,varname:node_9477,prsc:2,spu:-0.8,spv:0|UVIN-1272-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:1447,x:32668,y:33083,ptovrint:False,ptlb:node_1447,ptin:_node_1447,varname:node_1447,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c0eb2b2c27f73544997095d76327e1b5,ntxv:0,isnm:False|UVIN-4470-UVOUT;n:type:ShaderForge.SFN_Panner,id:4470,x:32483,y:33083,varname:node_4470,prsc:2,spu:-0.5,spv:0|UVIN-1272-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:6753,x:32464,y:32654,ptovrint:False,ptlb:node_6753,ptin:_node_6753,varname:node_6753,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:239b2f4be5c588243adeb1c529fb61ce,ntxv:0,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:8203,x:32650,y:32671,varname:node_8203,prsc:2|IN-6753-R;n:type:ShaderForge.SFN_Multiply,id:1646,x:32836,y:32715,varname:node_1646,prsc:2|A-8203-OUT,B-2666-RGB;n:type:ShaderForge.SFN_Multiply,id:4820,x:32919,y:33051,varname:node_4820,prsc:2|A-8203-OUT,B-6497-OUT;n:type:ShaderForge.SFN_Multiply,id:9375,x:33229,y:32918,varname:node_9375,prsc:2|A-2666-R,B-2412-OUT;n:type:ShaderForge.SFN_Tex2d,id:311,x:32811,y:32521,ptovrint:False,ptlb:node_311,ptin:_node_311,varname:node_311,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:c47211810b13c2a4ca94fe8e86129fae,ntxv:0,isnm:False|UVIN-9863-OUT;n:type:ShaderForge.SFN_Multiply,id:6097,x:33033,y:32613,varname:node_6097,prsc:2|A-311-RGB,B-1646-OUT;n:type:ShaderForge.SFN_Multiply,id:7976,x:33241,y:32704,varname:node_7976,prsc:2|A-6097-OUT,B-3699-OUT;n:type:ShaderForge.SFN_Vector1,id:3699,x:33039,y:32807,varname:node_3699,prsc:2,v1:2;n:type:ShaderForge.SFN_Tex2d,id:3284,x:32668,y:33290,ptovrint:False,ptlb:node_1447_copy,ptin:_node_1447_copy,varname:_node_1447_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:6f74e2238d710bd4a9990dadb17f8fbb,ntxv:0,isnm:False|UVIN-3285-UVOUT;n:type:ShaderForge.SFN_Panner,id:3285,x:32443,y:33290,varname:node_3285,prsc:2,spu:-0.5,spv:-0.12|UVIN-1272-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6497,x:32854,y:33195,varname:node_6497,prsc:2|A-1447-R,B-3284-R;n:type:ShaderForge.SFN_Multiply,id:2412,x:33196,y:33107,varname:node_2412,prsc:2|A-4820-OUT,B-231-OUT;n:type:ShaderForge.SFN_Vector1,id:231,x:32996,y:33229,varname:node_231,prsc:2,v1:10;n:type:ShaderForge.SFN_Color,id:5901,x:32777,y:32329,ptovrint:False,ptlb:node_5901,ptin:_node_5901,varname:node_5901,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Tex2d,id:5128,x:32136,y:32323,ptovrint:False,ptlb:node_5128,ptin:_node_5128,varname:node_5128,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:661d5d0589c3c9641a7dae34e8bf560c,ntxv:0,isnm:False|UVIN-8043-UVOUT;n:type:ShaderForge.SFN_Multiply,id:5824,x:32438,y:32392,varname:node_5824,prsc:2|A-5128-R,B-1792-OUT;n:type:ShaderForge.SFN_Vector1,id:1792,x:32189,y:32520,varname:node_1792,prsc:2,v1:0.05;n:type:ShaderForge.SFN_Add,id:9863,x:32650,y:32451,varname:node_9863,prsc:2|A-5824-OUT,B-1272-UVOUT;n:type:ShaderForge.SFN_Panner,id:8043,x:31929,y:32323,varname:node_8043,prsc:2,spu:1,spv:1|UVIN-1272-UVOUT;proporder:2666-1447-6753-311-3284-5901-5128;pass:END;sub:END;*/

Shader "LDJ/Fx/ldj_trail" {
    Properties {
        _node_2666 ("node_2666", 2D) = "white" {}
        _node_1447 ("node_1447", 2D) = "white" {}
        _node_6753 ("node_6753", 2D) = "white" {}
        _node_311 ("node_311", 2D) = "white" {}
        _node_1447_copy ("node_1447_copy", 2D) = "white" {}
        _node_5901 ("node_5901", Color) = (0,0,0,1)
        _node_5128 ("node_5128", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _node_2666; uniform float4 _node_2666_ST;
            uniform sampler2D _node_1447; uniform float4 _node_1447_ST;
            uniform sampler2D _node_6753; uniform float4 _node_6753_ST;
            uniform sampler2D _node_311; uniform float4 _node_311_ST;
            uniform sampler2D _node_1447_copy; uniform float4 _node_1447_copy_ST;
            uniform sampler2D _node_5128; uniform float4 _node_5128_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_9276 = _Time;
                float2 node_8043 = (i.uv0+node_9276.g*float2(1,1));
                float4 _node_5128_var = tex2D(_node_5128,TRANSFORM_TEX(node_8043, _node_5128));
                float2 node_9863 = ((_node_5128_var.r*0.05)+i.uv0);
                float4 _node_311_var = tex2D(_node_311,TRANSFORM_TEX(node_9863, _node_311));
                float4 _node_6753_var = tex2D(_node_6753,TRANSFORM_TEX(i.uv0, _node_6753));
                float node_8203 = (1.0 - _node_6753_var.r);
                float2 node_9477 = (i.uv0+node_9276.g*float2(-0.8,0));
                float4 _node_2666_var = tex2D(_node_2666,TRANSFORM_TEX(node_9477, _node_2666));
                float3 emissive = ((_node_311_var.rgb*(node_8203*_node_2666_var.rgb))*2.0);
                float3 finalColor = emissive;
                float2 node_4470 = (i.uv0+node_9276.g*float2(-0.5,0));
                float4 _node_1447_var = tex2D(_node_1447,TRANSFORM_TEX(node_4470, _node_1447));
                float2 node_3285 = (i.uv0+node_9276.g*float2(-0.5,-0.12));
                float4 _node_1447_copy_var = tex2D(_node_1447_copy,TRANSFORM_TEX(node_3285, _node_1447_copy));
                return fixed4(finalColor,(_node_2666_var.r*((node_8203*(_node_1447_var.r*_node_1447_copy_var.r))*10.0)));
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
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
