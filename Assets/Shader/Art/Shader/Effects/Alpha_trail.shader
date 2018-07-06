// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:14,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:True,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:1941,x:36334,y:34734,varname:node_1941,prsc:2|emission-5614-RGB,alpha-5614-A;n:type:ShaderForge.SFN_Tex2d,id:5614,x:35894,y:34825,ptovrint:False,ptlb:Texture,ptin:_Texture,varname:_Texture,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:8f08a9ec442aa9d4aa072c1a6f4a0c93,ntxv:0,isnm:False|UVIN-8231-OUT;n:type:ShaderForge.SFN_Time,id:8493,x:33947,y:34867,varname:node_8493,prsc:2;n:type:ShaderForge.SFN_Panner,id:5000,x:34569,y:34948,varname:node_5000,prsc:2,spu:1,spv:0|UVIN-3180-OUT,DIST-935-OUT;n:type:ShaderForge.SFN_Multiply,id:935,x:34144,y:34942,varname:node_935,prsc:2|A-8493-T,B-5903-OUT;n:type:ShaderForge.SFN_Tex2d,id:3541,x:34882,y:35007,ptovrint:False,ptlb:Noise,ptin:_Noise,varname:_Noise,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:fbd4eb55904dffc45b534a2e374d3f09,ntxv:0,isnm:False|UVIN-5000-UVOUT;n:type:ShaderForge.SFN_Append,id:8231,x:35682,y:34825,varname:node_8231,prsc:2|A-3206-OUT,B-1792-OUT;n:type:ShaderForge.SFN_TexCoord,id:4618,x:34187,y:35114,varname:node_4618,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ComponentMask,id:2243,x:35036,y:34728,varname:node_2243,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-3180-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1792,x:35432,y:34961,varname:node_1792,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-3180-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5903,x:33908,y:35112,ptovrint:False,ptlb:U,ptin:_U,varname:_U,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Add,id:3206,x:35432,y:34825,varname:node_3206,prsc:2|A-2243-OUT,B-7331-OUT;n:type:ShaderForge.SFN_Multiply,id:7331,x:35193,y:34942,varname:node_7331,prsc:2|A-2243-OUT,B-3541-R,C-2374-OUT;n:type:ShaderForge.SFN_Slider,id:2374,x:34882,y:35229,ptovrint:False,ptlb:Dissolve,ptin:_Dissolve,varname:_Dissolve,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2.09471,max:10;n:type:ShaderForge.SFN_OneMinus,id:5661,x:34393,y:34776,varname:node_5661,prsc:2|IN-4618-U;n:type:ShaderForge.SFN_Append,id:3180,x:34680,y:34777,varname:node_3180,prsc:2|A-5661-OUT,B-4618-V;n:type:ShaderForge.SFN_Vector1,id:9213,x:31947,y:33724,varname:node_9213,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:3024,x:32011,y:33788,varname:node_3024,prsc:2,v1:0;proporder:5614-3541-5903-2374;pass:END;sub:END;*/

Shader "LDJ/Fx/Alpha_trail" {
    Properties {
        _Texture ("Texture", 2D) = "white" {}
        _Noise ("Noise", 2D) = "white" {}
        _U ("U", Float ) = 0
        _Dissolve ("Dissolve", Range(0, 10)) = 2.09471
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
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform sampler2D _Noise; uniform float4 _Noise_ST;
            uniform float _U;
            uniform float _Dissolve;
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
                float2 node_3180 = float2((1.0 - i.uv0.r),i.uv0.g);
                float node_2243 = node_3180.r;
                float4 node_8493 = _Time;
                float2 node_5000 = (node_3180+(node_8493.g*_U)*float2(1,0));
                float4 _Noise_var = tex2D(_Noise,TRANSFORM_TEX(node_5000, _Noise));
                float2 node_8231 = float2((node_2243+(node_2243*_Noise_var.r*_Dissolve)),node_3180.g);
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(node_8231, _Texture));
                float3 emissive = _Texture_var.rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,_Texture_var.a);
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
