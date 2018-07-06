// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Particles/Additive,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:8175,x:32992,y:32389,varname:node_8175,prsc:2|emission-730-OUT;n:type:ShaderForge.SFN_Tex2d,id:423,x:32097,y:32693,ptovrint:False,ptlb:Maintex,ptin:_Maintex,varname:_Maintex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1392-OUT;n:type:ShaderForge.SFN_VertexColor,id:7575,x:31913,y:32931,varname:node_7575,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3553,x:32396,y:32835,varname:node_3553,prsc:2|A-423-RGB,B-7575-RGB,C-7504-OUT,D-423-A,E-7575-A;n:type:ShaderForge.SFN_Color,id:6555,x:31565,y:33200,ptovrint:False,ptlb:Tint Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:9691,x:31477,y:32490,ptovrint:False,ptlb:niuqu_tex,ptin:_niuqu_tex,varname:_niuqu_tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5609-OUT;n:type:ShaderForge.SFN_Multiply,id:4346,x:31683,y:32583,varname:node_4346,prsc:2|A-9691-R,B-3445-OUT;n:type:ShaderForge.SFN_TexCoord,id:3318,x:31008,y:32700,varname:node_3318,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:1392,x:31842,y:32693,varname:node_1392,prsc:2|A-4346-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:3445,x:31477,y:32735,ptovrint:False,ptlb:QD,ptin:_QD,varname:_QD,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;n:type:ShaderForge.SFN_Time,id:9081,x:30579,y:32476,varname:node_9081,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4199,x:30829,y:32398,varname:node_4199,prsc:2|A-9436-OUT,B-9081-T;n:type:ShaderForge.SFN_Multiply,id:1645,x:30840,y:32569,varname:node_1645,prsc:2|A-1732-OUT,B-9081-T;n:type:ShaderForge.SFN_Append,id:6806,x:31008,y:32470,varname:node_6806,prsc:2|A-4199-OUT,B-1645-OUT;n:type:ShaderForge.SFN_Add,id:5609,x:31238,y:32574,varname:node_5609,prsc:2|A-6806-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_Multiply,id:730,x:32631,y:32630,varname:node_730,prsc:2|A-948-OUT,B-3553-OUT;n:type:ShaderForge.SFN_Multiply,id:948,x:32307,y:32413,varname:node_948,prsc:2|A-8583-OUT,B-423-RGB;n:type:ShaderForge.SFN_Vector1,id:2746,x:31755,y:32392,varname:node_2746,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:8583,x:31933,y:32398,varname:node_8583,prsc:2|A-2746-OUT,B-9691-RGB;n:type:ShaderForge.SFN_ValueProperty,id:6050,x:31579,y:33502,ptovrint:False,ptlb:GLOW,ptin:_GLOW,varname:_GLOW,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:7504,x:31849,y:33441,varname:node_7504,prsc:2|A-6555-RGB,B-6050-OUT,C-6555-A;n:type:ShaderForge.SFN_ValueProperty,id:1732,x:30594,y:32709,ptovrint:False,ptlb:V,ptin:_V,varname:_V,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9436,x:30579,y:32362,ptovrint:False,ptlb:U,ptin:_U,varname:_U,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:6555-423-9691-3445-6050-1732-9436;pass:END;sub:END;*/

Shader "LDJ/Fx/Additive_distort" {
    Properties {
        _TintColor ("Tint Color", Color) = (1,1,1,1)
        _Maintex ("Maintex", 2D) = "white" {}
        _niuqu_tex ("niuqu_tex", 2D) = "white" {}
        _QD ("QD", Float ) = 0.05
        _GLOW ("GLOW", Float ) = 1
        _V ("V", Float ) = 0
        _U ("U", Float ) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        LOD 100
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
            uniform sampler2D _Maintex; uniform float4 _Maintex_ST;
            uniform float4 _TintColor;
            uniform sampler2D _niuqu_tex; uniform float4 _niuqu_tex_ST;
            uniform float _QD;
            uniform float _GLOW;
            uniform float _V;
            uniform float _U;
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
                float4 node_9081 = _Time;
                float2 node_5609 = (float2((_U*node_9081.g),(_V*node_9081.g))+i.uv0);
                float4 _niuqu_tex_var = tex2D(_niuqu_tex,TRANSFORM_TEX(node_5609, _niuqu_tex));
                float2 node_1392 = ((_niuqu_tex_var.r*_QD)+i.uv0);
                float4 _Maintex_var = tex2D(_Maintex,TRANSFORM_TEX(node_1392, _Maintex));
                float3 emissive = (((2.0*_niuqu_tex_var.rgb)*_Maintex_var.rgb)*(_Maintex_var.rgb*i.vertexColor.rgb*(_TintColor.rgb*_GLOW*_TintColor.a)*_Maintex_var.a*i.vertexColor.a));
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
    CustomEditor "ShaderForgeMaterialInspector"
}
