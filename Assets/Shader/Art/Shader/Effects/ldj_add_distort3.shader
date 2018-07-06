// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:34040,y:32575,varname:node_4013,prsc:2|emission-8398-OUT;n:type:ShaderForge.SFN_Time,id:1695,x:31730,y:32735,varname:node_1695,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:791,x:31730,y:32623,ptovrint:False,ptlb:U,ptin:_U,varname:node_791,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:-1;n:type:ShaderForge.SFN_ValueProperty,id:1947,x:31754,y:32926,ptovrint:False,ptlb:V,ptin:_V,varname:_node_791_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:2384,x:31969,y:32665,varname:node_2384,prsc:2|A-791-OUT,B-1695-T;n:type:ShaderForge.SFN_Multiply,id:7508,x:31988,y:32851,varname:node_7508,prsc:2|A-1947-OUT,B-1695-T;n:type:ShaderForge.SFN_Append,id:3237,x:32155,y:32716,varname:node_3237,prsc:2|A-2384-OUT,B-7508-OUT;n:type:ShaderForge.SFN_TexCoord,id:6574,x:32139,y:32851,varname:node_6574,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:6814,x:32382,y:32734,varname:node_6814,prsc:2|A-3237-OUT,B-6574-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:8237,x:32570,y:32734,ptovrint:False,ptlb:NQ_tex,ptin:_NQ_tex,varname:node_8237,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6814-OUT;n:type:ShaderForge.SFN_Multiply,id:6568,x:32809,y:32638,varname:node_6568,prsc:2|A-7261-OUT,B-8237-RGB;n:type:ShaderForge.SFN_Vector1,id:7261,x:32553,y:32586,varname:node_7261,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:5651,x:32799,y:32847,varname:node_5651,prsc:2|A-8237-R,B-4698-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4698,x:32570,y:32974,ptovrint:False,ptlb:QD,ptin:_QD,varname:node_4698,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;n:type:ShaderForge.SFN_Add,id:5630,x:32977,y:32847,varname:node_5630,prsc:2|A-5651-OUT,B-6574-UVOUT;n:type:ShaderForge.SFN_Multiply,id:7417,x:33323,y:32642,varname:node_7417,prsc:2|A-6568-OUT,B-7636-RGB;n:type:ShaderForge.SFN_Tex2d,id:7636,x:33164,y:32847,ptovrint:False,ptlb:tex,ptin:_tex,varname:_node_8237_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5630-OUT;n:type:ShaderForge.SFN_VertexColor,id:1685,x:33049,y:33020,varname:node_1685,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5853,x:33434,y:32961,varname:node_5853,prsc:2|A-7636-RGB,B-1685-RGB,C-7037-OUT,D-1685-A,E-7636-A;n:type:ShaderForge.SFN_Color,id:6762,x:32917,y:33173,ptovrint:False,ptlb:node_6762,ptin:_node_6762,varname:node_6762,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:7037,x:33191,y:33238,varname:node_7037,prsc:2|A-6762-RGB,B-9616-OUT,C-6762-A;n:type:ShaderForge.SFN_ValueProperty,id:9616,x:32917,y:33361,ptovrint:False,ptlb:GLOW,ptin:_GLOW,varname:node_9616,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:5223,x:33570,y:32771,varname:node_5223,prsc:2|A-7417-OUT,B-5853-OUT;n:type:ShaderForge.SFN_Tex2d,id:7105,x:33493,y:32464,ptovrint:False,ptlb:mask,ptin:_mask,varname:_node_8237_copy_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5630-OUT;n:type:ShaderForge.SFN_Multiply,id:8398,x:33800,y:32627,varname:node_8398,prsc:2|A-7105-RGB,B-5223-OUT;proporder:6762-9616-4698-791-1947-8237-7636-7105;pass:END;sub:END;*/

Shader "LDJ/Fx/add_distort3" {
    Properties {
        _node_6762 ("node_6762", Color) = (1,1,1,1)
        _GLOW ("GLOW", Float ) = 1
        _QD ("QD", Float ) = 0.05
        _U ("U", Float ) = -1
        _V ("V", Float ) = 0
        _NQ_tex ("NQ_tex", 2D) = "white" {}
        _tex ("tex", 2D) = "white" {}
        _mask ("mask", 2D) = "white" {}
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
            Blend One One
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
            uniform float _U;
            uniform float _V;
            uniform sampler2D _NQ_tex; uniform float4 _NQ_tex_ST;
            uniform float _QD;
            uniform sampler2D _tex; uniform float4 _tex_ST;
            uniform float4 _node_6762;
            uniform float _GLOW;
            uniform sampler2D _mask; uniform float4 _mask_ST;
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
////// Lighting:
////// Emissive:
                float4 node_1695 = _Time;
                float2 node_6814 = (float2((_U*node_1695.g),(_V*node_1695.g))+i.uv0);
                float4 _NQ_tex_var = tex2D(_NQ_tex,TRANSFORM_TEX(node_6814, _NQ_tex));
                float2 node_5630 = ((_NQ_tex_var.r*_QD)+i.uv0);
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(node_5630, _mask));
                float4 _tex_var = tex2D(_tex,TRANSFORM_TEX(node_5630, _tex));
                float3 emissive = (_mask_var.rgb*(((2.0*_NQ_tex_var.rgb)*_tex_var.rgb)*(_tex_var.rgb*i.vertexColor.rgb*(_node_6762.rgb*_GLOW*_node_6762.a)*i.vertexColor.a*_tex_var.a)));
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
