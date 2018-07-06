// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33723,y:32775,varname:node_4013,prsc:2|emission-8463-OUT,voffset-80-OUT;n:type:ShaderForge.SFN_Tex2d,id:6590,x:32840,y:32479,ptovrint:False,ptlb:node_6590,ptin:_node_6590,varname:node_6590,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:1630,x:32509,y:32925,ptovrint:False,ptlb:node_1630,ptin:_node_1630,varname:node_1630,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2654,x:32734,y:33041,varname:node_2654,prsc:2|A-1630-G,B-8544-OUT;n:type:ShaderForge.SFN_Append,id:2860,x:32988,y:33107,varname:node_2860,prsc:2|A-2212-OUT,B-2654-OUT,C-1065-OUT;n:type:ShaderForge.SFN_Vector1,id:1065,x:32734,y:33225,varname:node_1065,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:2212,x:32806,y:32943,varname:node_2212,prsc:2,v1:0;n:type:ShaderForge.SFN_Time,id:8250,x:32509,y:33318,varname:node_8250,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4847,x:32722,y:33404,varname:node_4847,prsc:2|A-8250-T,B-3016-OUT;n:type:ShaderForge.SFN_Sin,id:2603,x:32980,y:33363,varname:node_2603,prsc:2|IN-4847-OUT;n:type:ShaderForge.SFN_Multiply,id:80,x:33211,y:33223,varname:node_80,prsc:2|A-2860-OUT,B-2603-OUT;n:type:ShaderForge.SFN_VertexColor,id:7757,x:32972,y:32838,varname:node_7757,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8463,x:33383,y:32594,varname:node_8463,prsc:2|A-6590-RGB,B-7757-RGB,C-9700-OUT,D-408-RGB,E-7757-A;n:type:ShaderForge.SFN_ValueProperty,id:9700,x:33167,y:32443,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_9700,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Color,id:408,x:32972,y:32658,ptovrint:False,ptlb:node_408,ptin:_node_408,varname:node_408,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:3016,x:32509,y:33498,ptovrint:False,ptlb:PL,ptin:_PL,varname:node_3016,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:12;n:type:ShaderForge.SFN_ValueProperty,id:8544,x:32526,y:33147,ptovrint:False,ptlb:QD,ptin:_QD,varname:node_8544,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;proporder:408-9700-6590-1630-3016-8544;pass:END;sub:END;*/

Shader "LDJ/Fx/hudie_add" {
    Properties {
        _node_408 ("node_408", Color) = (1,1,1,1)
        _glow ("glow", Float ) = 1
        _node_6590 ("node_6590", 2D) = "white" {}
        _node_1630 ("node_1630", 2D) = "white" {}
        _PL ("PL", Float ) = 12
        _QD ("QD", Float ) = 0.2
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
            uniform sampler2D _node_6590; uniform float4 _node_6590_ST;
            uniform sampler2D _node_1630; uniform float4 _node_1630_ST;
            uniform float _glow;
            uniform float4 _node_408;
            uniform float _PL;
            uniform float _QD;
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
                float4 _node_1630_var = tex2Dlod(_node_1630,float4(TRANSFORM_TEX(o.uv0, _node_1630),0.0,0));
                float4 node_8250 = _Time;
                v.vertex.xyz += (float3(0.0,(_node_1630_var.g*_QD),0.0)*sin((node_8250.g*_PL)));
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 _node_6590_var = tex2D(_node_6590,TRANSFORM_TEX(i.uv0, _node_6590));
                float3 emissive = (_node_6590_var.rgb*i.vertexColor.rgb*_glow*_node_408.rgb*i.vertexColor.a);
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
            uniform sampler2D _node_1630; uniform float4 _node_1630_ST;
            uniform float _PL;
            uniform float _QD;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 _node_1630_var = tex2Dlod(_node_1630,float4(TRANSFORM_TEX(o.uv0, _node_1630),0.0,0));
                float4 node_8250 = _Time;
                v.vertex.xyz += (float3(0.0,(_node_1630_var.g*_QD),0.0)*sin((node_8250.g*_PL)));
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
