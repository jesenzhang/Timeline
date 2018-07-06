// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32857,y:32714,varname:node_4013,prsc:2|alpha-9770-OUT,refract-976-OUT;n:type:ShaderForge.SFN_Tex2d,id:5878,x:32184,y:32791,ptovrint:False,ptlb:node_5878,ptin:_node_5878,varname:node_5878,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:2c86388ecc85e4a4a918711b7ae58f9e,ntxv:0,isnm:False|UVIN-7754-OUT;n:type:ShaderForge.SFN_Multiply,id:7754,x:31986,y:32791,varname:node_7754,prsc:2|A-1858-UVOUT,B-384-OUT;n:type:ShaderForge.SFN_TexCoord,id:1858,x:31736,y:32735,varname:node_1858,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Vector1,id:384,x:31790,y:32918,varname:node_384,prsc:2,v1:1;n:type:ShaderForge.SFN_ComponentMask,id:4810,x:32380,y:32791,varname:node_4810,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-5878-RGB;n:type:ShaderForge.SFN_Multiply,id:976,x:32582,y:32891,varname:node_976,prsc:2|A-4810-OUT,B-1291-OUT;n:type:ShaderForge.SFN_Multiply,id:1291,x:32159,y:33005,varname:node_1291,prsc:2|A-170-A,B-8008-OUT;n:type:ShaderForge.SFN_VertexColor,id:170,x:31888,y:32995,varname:node_170,prsc:2;n:type:ShaderForge.SFN_Vector1,id:9770,x:32649,y:32784,varname:node_9770,prsc:2,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:8008,x:31888,y:33174,ptovrint:False,ptlb:QD,ptin:_QD,varname:node_8008,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;proporder:5878-8008;pass:END;sub:END;*/

Shader "LDJ/Fx/ldj_Twist" {
    Properties {
        _node_5878 ("node_5878", 2D) = "white" {}
        _QD ("QD", Float ) = 0.05
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
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
            uniform sampler2D _GrabTexture;
            uniform sampler2D _node_5878; uniform float4 _node_5878_ST;
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
                float4 projPos : TEXCOORD1;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.projPos = ComputeScreenPos (o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float2 node_7754 = (i.uv0*1.0);
                float4 _node_5878_var = tex2D(_node_5878,TRANSFORM_TEX(node_7754, _node_5878));
                float2 sceneUVs = (i.projPos.xy / i.projPos.w) + (_node_5878_var.rgb.rg*(i.vertexColor.a*_QD));
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float3 finalColor = 0;
                return fixed4(lerp(sceneColor.rgb, finalColor,0.0),1);
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
