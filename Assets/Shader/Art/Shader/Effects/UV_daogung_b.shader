// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32772,y:32722,varname:node_4013,prsc:2|emission-3919-OUT,alpha-1515-OUT;n:type:ShaderForge.SFN_Tex2d,id:5104,x:31924,y:32732,ptovrint:False,ptlb:node_5104,ptin:_node_5104,varname:node_5104,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b6d1055ecf499204a9221f4babe957ba,ntxv:0,isnm:False;n:type:ShaderForge.SFN_TexCoord,id:302,x:31526,y:32765,varname:node_302,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_VertexColor,id:6238,x:31526,y:32947,varname:node_6238,prsc:2;n:type:ShaderForge.SFN_Multiply,id:1969,x:31742,y:33038,varname:node_1969,prsc:2|A-6238-R,B-6631-OUT;n:type:ShaderForge.SFN_Tex2d,id:1778,x:32094,y:33033,ptovrint:False,ptlb:node_5104_copy,ptin:_node_5104_copy,varname:_node_5104_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:b6d1055ecf499204a9221f4babe957ba,ntxv:0,isnm:False|UVIN-3069-UVOUT;n:type:ShaderForge.SFN_Panner,id:3069,x:31924,y:32920,varname:node_3069,prsc:2,spu:0.1,spv:0|UVIN-302-UVOUT,DIST-1969-OUT;n:type:ShaderForge.SFN_Multiply,id:3919,x:32294,y:32546,varname:node_3919,prsc:2|A-3995-RGB,B-9303-OUT,C-5104-RGB;n:type:ShaderForge.SFN_Color,id:3995,x:31946,y:32461,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_3995,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:9303,x:31946,y:32629,ptovrint:False,ptlb:Glow,ptin:_Glow,varname:node_9303,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:1515,x:32383,y:32942,varname:node_1515,prsc:2|A-5104-R,B-1778-R,C-6238-A;n:type:ShaderForge.SFN_ValueProperty,id:6631,x:31526,y:33128,ptovrint:False,ptlb:UV,ptin:_UV,varname:node_6631,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:9303-3995-6631-5104-1778;pass:END;sub:END;*/

Shader "LDJ/Fx/UV_daogung_b" {
    Properties {
        _Glow ("Glow", Float ) = 1
        _Color ("Color", Color) = (1,1,1,1)
        _UV ("UV", Float ) = 0
        _node_5104 ("node_5104", 2D) = "white" {}
        _node_5104_copy ("node_5104_copy", 2D) = "white" {}
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
            uniform sampler2D _node_5104; uniform float4 _node_5104_ST;
            uniform sampler2D _node_5104_copy; uniform float4 _node_5104_copy_ST;
            uniform float4 _Color;
            uniform float _Glow;
            uniform float _UV;
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
                float4 _node_5104_var = tex2D(_node_5104,TRANSFORM_TEX(i.uv0, _node_5104));
                float3 emissive = (_Color.rgb*_Glow*_node_5104_var.rgb);
                float3 finalColor = emissive;
                float2 node_3069 = (i.uv0+(i.vertexColor.r*_UV)*float2(0.1,0));
                float4 _node_5104_copy_var = tex2D(_node_5104_copy,TRANSFORM_TEX(node_3069, _node_5104_copy));
                return fixed4(finalColor,(_node_5104_var.r*_node_5104_copy_var.r*i.vertexColor.a));
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
