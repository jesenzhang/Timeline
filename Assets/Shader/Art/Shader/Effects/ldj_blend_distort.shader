// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Particles/Alpha Blended,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:8175,x:32861,y:32697,varname:node_8175,prsc:2|emission-730-OUT,alpha-4763-OUT;n:type:ShaderForge.SFN_Tex2d,id:423,x:32139,y:32727,ptovrint:False,ptlb:Particle Texture,ptin:_ParticleTexture,varname:_ParticleTexture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1392-OUT;n:type:ShaderForge.SFN_VertexColor,id:7575,x:32139,y:32946,varname:node_7575,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3553,x:32448,y:32810,varname:node_3553,prsc:2|A-423-R,B-7575-RGB,C-7504-OUT;n:type:ShaderForge.SFN_Color,id:6555,x:32139,y:33111,ptovrint:False,ptlb:Tint Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:9691,x:31543,y:32538,ptovrint:False,ptlb:niuqu tex,ptin:_niuqutex,varname:_niuqutex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5609-OUT;n:type:ShaderForge.SFN_Multiply,id:4346,x:31738,y:32629,varname:node_4346,prsc:2|A-9691-R,B-3445-OUT;n:type:ShaderForge.SFN_TexCoord,id:3318,x:31074,y:32748,varname:node_3318,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:1392,x:31950,y:32727,varname:node_1392,prsc:2|A-4346-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:3445,x:31543,y:32783,ptovrint:False,ptlb:QD,ptin:_QD,varname:_QD,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_Time,id:9081,x:30687,y:32582,varname:node_9081,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4199,x:30895,y:32446,varname:node_4199,prsc:2|A-4662-OUT,B-9081-T;n:type:ShaderForge.SFN_Multiply,id:1645,x:30906,y:32617,varname:node_1645,prsc:2|A-9201-OUT,B-9081-T;n:type:ShaderForge.SFN_Append,id:6806,x:31074,y:32518,varname:node_6806,prsc:2|A-4199-OUT,B-1645-OUT;n:type:ShaderForge.SFN_Add,id:5609,x:31304,y:32622,varname:node_5609,prsc:2|A-6806-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_Multiply,id:730,x:32654,y:32794,varname:node_730,prsc:2|A-948-OUT,B-3553-OUT;n:type:ShaderForge.SFN_Multiply,id:948,x:32411,y:32370,varname:node_948,prsc:2|A-8583-OUT,B-423-RGB;n:type:ShaderForge.SFN_Vector1,id:2746,x:31705,y:32361,varname:node_2746,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:8583,x:31933,y:32398,varname:node_8583,prsc:2|A-2746-OUT,B-9691-RGB;n:type:ShaderForge.SFN_ValueProperty,id:6050,x:32151,y:33350,ptovrint:False,ptlb:GLOW,ptin:_GLOW,varname:_GLOW,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:7504,x:32383,y:33245,varname:node_7504,prsc:2|A-6555-RGB,B-6050-OUT;n:type:ShaderForge.SFN_Multiply,id:4763,x:32448,y:32962,varname:node_4763,prsc:2|A-423-B,B-7575-A,C-6555-A;n:type:ShaderForge.SFN_ValueProperty,id:9201,x:30687,y:32794,ptovrint:False,ptlb:V,ptin:_V,varname:_V,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_ValueProperty,id:4662,x:30687,y:32446,ptovrint:False,ptlb:U,ptin:_U,varname:_U,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;proporder:6555-423-9691-3445-6050-9201-4662;pass:END;sub:END;*/

Shader "LDJ/Fx/Alpha Blended_distort" {
    Properties {
        _TintColor ("Tint Color", Color) = (1,1,1,1)
        _ParticleTexture ("Particle Texture", 2D) = "white" {}
        _niuqutex ("niuqu tex", 2D) = "white" {}
        _QD ("QD", Float ) = 0.2
        _GLOW ("GLOW", Float ) = 1
        _V ("V", Float ) = 0.2
        _U ("U", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
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
            uniform sampler2D _ParticleTexture; uniform float4 _ParticleTexture_ST;
            uniform float4 _TintColor;
            uniform sampler2D _niuqutex; uniform float4 _niuqutex_ST;
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
                float4 _niuqutex_var = tex2D(_niuqutex,TRANSFORM_TEX(node_5609, _niuqutex));
                float2 node_1392 = ((_niuqutex_var.r*_QD)+i.uv0);
                float4 _ParticleTexture_var = tex2D(_ParticleTexture,TRANSFORM_TEX(node_1392, _ParticleTexture));
                float3 emissive = (((2.0*_niuqutex_var.rgb)*_ParticleTexture_var.rgb)*(_ParticleTexture_var.r*i.vertexColor.rgb*(_TintColor.rgb*_GLOW)));
                float3 finalColor = emissive;
                return fixed4(finalColor,(_ParticleTexture_var.b*i.vertexColor.a*_TintColor.a));
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
