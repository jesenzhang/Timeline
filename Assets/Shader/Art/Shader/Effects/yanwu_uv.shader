// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33091,y:32658,varname:node_4013,prsc:2|emission-7235-OUT,alpha-3288-OUT;n:type:ShaderForge.SFN_Tex2d,id:9882,x:32381,y:32749,ptovrint:False,ptlb:node_9882,ptin:_node_9882,varname:node_9882,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-7675-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:6905,x:32135,y:33047,varname:node_6905,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3288,x:32576,y:33139,varname:node_3288,prsc:2|A-9882-A,B-6905-A;n:type:ShaderForge.SFN_Multiply,id:7235,x:32895,y:32715,varname:node_7235,prsc:2|A-333-OUT,B-9882-RGB,C-6905-RGB,D-1328-RGB,E-7157-OUT;n:type:ShaderForge.SFN_Tex2d,id:1136,x:32217,y:32540,ptovrint:False,ptlb:node_1136,ptin:_node_1136,varname:node_1136,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:1328,x:32567,y:32824,ptovrint:False,ptlb:node_1328,ptin:_node_1328,varname:node_1328,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:7157,x:32567,y:33025,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_7157,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Panner,id:7675,x:32140,y:32749,varname:node_7675,prsc:2,spu:0,spv:0.35|UVIN-8823-UVOUT,DIST-8707-OUT;n:type:ShaderForge.SFN_TexCoord,id:8823,x:31871,y:32746,varname:node_8823,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Slider,id:8707,x:31772,y:32969,ptovrint:False,ptlb:UV,ptin:_UV,varname:node_8707,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-2,cur:2,max:2;n:type:ShaderForge.SFN_Multiply,id:333,x:32623,y:32576,varname:node_333,prsc:2|A-1136-RGB,B-1136-A;proporder:9882-1136-1328-7157-8707;pass:END;sub:END;*/

Shader "LDJ/Fx/yanwu_uv" {
    Properties {
        _node_9882 ("node_9882", 2D) = "white" {}
        _node_1136 ("node_1136", 2D) = "white" {}
        _node_1328 ("node_1328", Color) = (1,1,1,1)
        _glow ("glow", Float ) = 1
        _UV ("UV", Range(-2, 2)) = 2
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
            uniform sampler2D _node_9882; uniform float4 _node_9882_ST;
            uniform sampler2D _node_1136; uniform float4 _node_1136_ST;
            uniform float4 _node_1328;
            uniform float _glow;
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
                float4 _node_1136_var = tex2D(_node_1136,TRANSFORM_TEX(i.uv0, _node_1136));
                float2 node_7675 = (i.uv0+_UV*float2(0,0.35));
                float4 _node_9882_var = tex2D(_node_9882,TRANSFORM_TEX(node_7675, _node_9882));
                float3 emissive = ((_node_1136_var.rgb*_node_1136_var.a)*_node_9882_var.rgb*i.vertexColor.rgb*_node_1328.rgb*_glow);
                float3 finalColor = emissive;
                return fixed4(finalColor,(_node_9882_var.a*i.vertexColor.a));
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
