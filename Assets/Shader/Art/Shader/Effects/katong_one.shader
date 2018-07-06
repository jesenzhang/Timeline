// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:33952,y:32444,varname:node_3138,prsc:2|custl-9457-OUT,alpha-7653-OUT;n:type:ShaderForge.SFN_Tex2d,id:4645,x:32359,y:32661,ptovrint:False,ptlb:main,ptin:_main,varname:node_4645,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:24ecc1a59ee63ba44bd1ca66571ce8f4,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:8604,x:32359,y:32869,ptovrint:False,ptlb:mask,ptin:_mask,varname:node_8604,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Subtract,id:1931,x:32888,y:32655,varname:node_1931,prsc:2|A-8145-OUT,B-4550-OUT;n:type:ShaderForge.SFN_TexCoord,id:4967,x:32064,y:32178,varname:node_4967,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:8145,x:32705,y:32655,varname:node_8145,prsc:2|A-1932-OUT,B-4645-RGB;n:type:ShaderForge.SFN_ValueProperty,id:1932,x:32367,y:32581,ptovrint:False,ptlb:str,ptin:_str,varname:node_1932,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Blend,id:9577,x:33273,y:32536,varname:node_9577,prsc:2,blmd:12,clmp:True|SRC-1931-OUT,DST-6833-OUT;n:type:ShaderForge.SFN_Vector1,id:6833,x:33099,y:32707,varname:node_6833,prsc:2,v1:1;n:type:ShaderForge.SFN_ComponentMask,id:2802,x:33421,y:32869,varname:node_2802,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-2071-OUT;n:type:ShaderForge.SFN_Color,id:975,x:33208,y:32343,ptovrint:False,ptlb:color,ptin:_color,varname:node_975,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9457,x:33675,y:32424,varname:node_9457,prsc:2|A-975-RGB,B-9577-OUT,C-5911-OUT,D-4818-RGB;n:type:ShaderForge.SFN_Slider,id:8451,x:32343,y:33190,ptovrint:False,ptlb:dissolve,ptin:_dissolve,varname:node_8451,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_ValueProperty,id:5911,x:33532,y:32621,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_5911,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Add,id:4550,x:32783,y:32898,varname:node_4550,prsc:2|A-6635-OUT,B-3354-OUT,C-4706-OUT;n:type:ShaderForge.SFN_VertexColor,id:4818,x:32888,y:32415,varname:node_4818,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7653,x:33623,y:32797,varname:node_7653,prsc:2|A-2802-OUT,B-4818-A,C-9909-OUT;n:type:ShaderForge.SFN_Clamp01,id:2071,x:33224,y:32856,varname:node_2071,prsc:2|IN-1931-OUT;n:type:ShaderForge.SFN_Multiply,id:9909,x:33226,y:32043,varname:node_9909,prsc:2|A-4967-V,B-8204-OUT;n:type:ShaderForge.SFN_Vector1,id:8204,x:33038,y:32203,varname:node_8204,prsc:2,v1:1;n:type:ShaderForge.SFN_OneMinus,id:8943,x:32344,y:32299,varname:node_8943,prsc:2|IN-4967-V;n:type:ShaderForge.SFN_Multiply,id:6635,x:32549,y:32962,varname:node_6635,prsc:2|A-8604-RGB,B-4119-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4119,x:32366,y:33072,ptovrint:False,ptlb:dissolve_str,ptin:_dissolve_str,varname:node_4119,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:4706,x:32662,y:32234,varname:node_4706,prsc:2|A-8943-OUT,B-8943-OUT,C-8943-OUT,D-8041-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8041,x:32483,y:32399,ptovrint:False,ptlb:edge,ptin:_edge,varname:node_8041,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.2;n:type:ShaderForge.SFN_Multiply,id:3354,x:32705,y:33125,varname:node_3354,prsc:2|A-1932-OUT,B-8451-OUT;proporder:4645-8604-1932-975-8451-4119-5911-8041;pass:END;sub:END;*/

Shader "LDJ/Fx/katong_one" {
    Properties {
        _main ("main", 2D) = "white" {}
        _mask ("mask", 2D) = "white" {}
        _str ("str", Float ) = 1
        _color ("color", Color) = (0.5,0.5,0.5,1)
        _dissolve ("dissolve", Range(0, 1)) = 1
        _dissolve_str ("dissolve_str", Float ) = 1
        _glow ("glow", Float ) = 1
        _edge ("edge", Float ) = 0.2
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
            uniform sampler2D _main; uniform float4 _main_ST;
            uniform sampler2D _mask; uniform float4 _mask_ST;
            uniform float _str;
            uniform float4 _color;
            uniform float _dissolve;
            uniform float _glow;
            uniform float _dissolve_str;
            uniform float _edge;
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
                float4 _main_var = tex2D(_main,TRANSFORM_TEX(i.uv0, _main));
                float4 _mask_var = tex2D(_mask,TRANSFORM_TEX(i.uv0, _mask));
                float node_8943 = (1.0 - i.uv0.g);
                float3 node_1931 = ((_str*_main_var.rgb)-((_mask_var.rgb*_dissolve_str)+(_str*_dissolve)+(node_8943*node_8943*node_8943*_edge)));
                float3 finalColor = (_color.rgb*saturate((node_1931 > 0.5 ?  (1.0-(1.0-2.0*(node_1931-0.5))*(1.0-1.0)) : (2.0*node_1931*1.0)) )*_glow*i.vertexColor.rgb);
                return fixed4(finalColor,(saturate(node_1931).r*i.vertexColor.a*(i.uv0.g*1.0)));
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
