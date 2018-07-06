// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32781,y:32739,varname:node_4013,prsc:2|emission-9626-OUT;n:type:ShaderForge.SFN_Tex2d,id:7216,x:32099,y:33075,ptovrint:False,ptlb:node_7216,ptin:_node_7216,varname:node_7216,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:61ccb5a07b3f5104ab753d12a85848df,ntxv:0,isnm:False|UVIN-8439-OUT;n:type:ShaderForge.SFN_Color,id:7872,x:32091,y:32639,ptovrint:False,ptlb:node_7872,ptin:_node_7872,varname:node_7872,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:9626,x:32381,y:32780,varname:node_9626,prsc:2|A-7872-RGB,B-3703-OUT,C-8751-OUT,D-5317-RGB;n:type:ShaderForge.SFN_ValueProperty,id:3703,x:32160,y:32925,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_3703,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:3709,x:31516,y:32981,varname:node_3709,prsc:2|A-9672-OUT,B-6869-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9672,x:31299,y:32920,ptovrint:False,ptlb:U,ptin:_U,varname:node_9672,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:5818,x:31283,y:33228,ptovrint:False,ptlb:V,ptin:_V,varname:_node_9672_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_Multiply,id:4070,x:31516,y:33151,varname:node_4070,prsc:2|A-5818-OUT,B-6869-OUT;n:type:ShaderForge.SFN_Append,id:395,x:31690,y:33036,varname:node_395,prsc:2|A-3709-OUT,B-4070-OUT;n:type:ShaderForge.SFN_TexCoord,id:3728,x:31690,y:33178,varname:node_3728,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:8439,x:31907,y:33075,varname:node_8439,prsc:2|A-395-OUT,B-3728-UVOUT;n:type:ShaderForge.SFN_VertexColor,id:5317,x:30912,y:32909,varname:node_5317,prsc:2;n:type:ShaderForge.SFN_Slider,id:9100,x:30860,y:33136,ptovrint:False,ptlb:sz,ptin:_sz,varname:node_9100,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-10,cur:-2.482274,max:10;n:type:ShaderForge.SFN_Multiply,id:6869,x:31188,y:33028,varname:node_6869,prsc:2|A-5317-R,B-9100-OUT;n:type:ShaderForge.SFN_Tex2d,id:3447,x:31447,y:32729,ptovrint:False,ptlb:node_3447,ptin:_node_3447,varname:node_3447,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:61ccb5a07b3f5104ab753d12a85848df,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:8751,x:32030,y:32818,varname:node_8751,prsc:2|A-3447-RGB,B-7216-R,C-5317-A;proporder:7872-3703-3447-7216-9672-5818-9100;pass:END;sub:END;*/

Shader "LDJ/Fx/UV_directional_add" {
    Properties {
        _node_7872 ("node_7872", Color) = (1,1,1,1)
        _glow ("glow", Float ) = 1
        _node_3447 ("node_3447", 2D) = "white" {}
        _node_7216 ("node_7216", 2D) = "white" {}
        _U ("U", Float ) = 0
        _V ("V", Float ) = 0.2
        _sz ("sz", Range(-10, 10)) = -2.482274
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
            uniform sampler2D _node_7216; uniform float4 _node_7216_ST;
            uniform float4 _node_7872;
            uniform float _glow;
            uniform float _U;
            uniform float _V;
            uniform float _sz;
            uniform sampler2D _node_3447; uniform float4 _node_3447_ST;
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
                float4 _node_3447_var = tex2D(_node_3447,TRANSFORM_TEX(i.uv0, _node_3447));
                float node_6869 = (i.vertexColor.r*_sz);
                float2 node_8439 = (float2((_U*node_6869),(_V*node_6869))+i.uv0);
                float4 _node_7216_var = tex2D(_node_7216,TRANSFORM_TEX(node_8439, _node_7216));
                float3 emissive = (_node_7872.rgb*_glow*(_node_3447_var.rgb*_node_7216_var.r*i.vertexColor.a)*i.vertexColor.rgb);
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
