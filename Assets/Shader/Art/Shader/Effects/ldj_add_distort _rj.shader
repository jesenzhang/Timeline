// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:Particles/Additive,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:0,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:14,ufog:False,aust:False,igpj:False,qofs:0,qpre:3,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:True,fsmp:False;n:type:ShaderForge.SFN_Final,id:8175,x:33106,y:32391,varname:node_8175,prsc:2|emission-8623-OUT,clip-8427-OUT;n:type:ShaderForge.SFN_Tex2d,id:423,x:32071,y:32282,ptovrint:False,ptlb:Maintex,ptin:_Maintex,varname:_Maintex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1392-OUT;n:type:ShaderForge.SFN_VertexColor,id:7575,x:31471,y:32507,varname:node_7575,prsc:2;n:type:ShaderForge.SFN_Multiply,id:3553,x:32276,y:32673,varname:node_3553,prsc:2|A-423-RGB,B-7575-RGB,C-7504-OUT,D-423-A,E-7575-A;n:type:ShaderForge.SFN_Color,id:6555,x:31459,y:32718,ptovrint:False,ptlb:Tint Color,ptin:_TintColor,varname:_TintColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:9691,x:31244,y:32173,ptovrint:False,ptlb:niuqu_tex,ptin:_niuqu_tex,varname:_niuqu_tex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5609-OUT;n:type:ShaderForge.SFN_Multiply,id:4346,x:31422,y:32261,varname:node_4346,prsc:2|A-9691-R,B-3445-OUT;n:type:ShaderForge.SFN_TexCoord,id:3318,x:30775,y:32383,varname:node_3318,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:1392,x:31599,y:32297,varname:node_1392,prsc:2|A-4346-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:3445,x:31185,y:32425,ptovrint:False,ptlb:QD,ptin:_QD,varname:_QD,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;n:type:ShaderForge.SFN_Time,id:9081,x:30346,y:32159,varname:node_9081,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4199,x:30596,y:32081,varname:node_4199,prsc:2|A-9436-OUT,B-9081-T;n:type:ShaderForge.SFN_Multiply,id:1645,x:30607,y:32252,varname:node_1645,prsc:2|A-1732-OUT,B-9081-T;n:type:ShaderForge.SFN_Append,id:6806,x:30775,y:32153,varname:node_6806,prsc:2|A-4199-OUT,B-1645-OUT;n:type:ShaderForge.SFN_Add,id:5609,x:31005,y:32257,varname:node_5609,prsc:2|A-6806-OUT,B-3318-UVOUT;n:type:ShaderForge.SFN_Multiply,id:948,x:32026,y:31982,varname:node_948,prsc:2|A-8583-OUT,B-423-RGB;n:type:ShaderForge.SFN_Vector1,id:2746,x:31522,y:32075,varname:node_2746,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:8583,x:31700,y:32081,varname:node_8583,prsc:2|A-2746-OUT,B-9691-RGB;n:type:ShaderForge.SFN_ValueProperty,id:6050,x:31459,y:32878,ptovrint:False,ptlb:GLOW,ptin:_GLOW,varname:_GLOW,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:7504,x:31892,y:32683,varname:node_7504,prsc:2|A-6555-RGB,B-6050-OUT,C-6555-A;n:type:ShaderForge.SFN_ValueProperty,id:1732,x:30361,y:32392,ptovrint:False,ptlb:V,ptin:_V,varname:_V,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:9436,x:30346,y:32045,ptovrint:False,ptlb:U,ptin:_U,varname:_U,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:8623,x:32758,y:32332,varname:node_8623,prsc:2|A-9569-OUT,B-3553-OUT;n:type:ShaderForge.SFN_Divide,id:8427,x:32010,y:33132,varname:node_8427,prsc:2|A-101-RGB,B-5437-OUT;n:type:ShaderForge.SFN_Slider,id:5437,x:31557,y:33225,ptovrint:False,ptlb:RJ,ptin:_RJ,varname:node_5437,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5101444,max:2;n:type:ShaderForge.SFN_Relay,id:777,x:32069,y:32959,varname:node_777,prsc:2|IN-8427-OUT;n:type:ShaderForge.SFN_If,id:7665,x:32553,y:32749,varname:node_7665,prsc:2|A-777-OUT,B-2650-OUT,GT-2459-OUT,EQ-933-OUT,LT-933-OUT;n:type:ShaderForge.SFN_Vector1,id:2459,x:32336,y:33191,varname:node_2459,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:933,x:32336,y:33298,varname:node_933,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:9569,x:32564,y:32204,varname:node_9569,prsc:2|A-948-OUT,B-6630-OUT;n:type:ShaderForge.SFN_Slider,id:2650,x:32152,y:32959,ptovrint:False,ptlb:node_2650,ptin:_node_2650,varname:node_2650,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.6628246,max:1;n:type:ShaderForge.SFN_Tex2d,id:101,x:31714,y:33009,ptovrint:False,ptlb:node_101,ptin:_node_101,varname:node_101,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1392-OUT;n:type:ShaderForge.SFN_Multiply,id:6630,x:32722,y:32592,varname:node_6630,prsc:2|A-6050-OUT,B-7665-OUT;proporder:6555-423-9691-3445-6050-1732-9436-5437-2650-101;pass:END;sub:END;*/

Shader "LDJ/Fx/ldj_add_distort _rj" {
    Properties {
        _TintColor ("Tint Color", Color) = (1,1,1,1)
        _Maintex ("Maintex", 2D) = "white" {}
        _niuqu_tex ("niuqu_tex", 2D) = "white" {}
        _QD ("QD", Float ) = 0.05
        _GLOW ("GLOW", Float ) = 1
        _V ("V", Float ) = 0
        _U ("U", Float ) = 0
        _RJ ("RJ", Range(0, 2)) = 0.5101444
        _node_2650 ("node_2650", Range(0, 1)) = 0.6628246
        _node_101 ("node_101", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent"
            "RenderType"="TransparentCutout"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One One
            Cull Off
            
            ColorMask RGB
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _Maintex; uniform float4 _Maintex_ST;
            uniform float4 _TintColor;
            uniform sampler2D _niuqu_tex; uniform float4 _niuqu_tex_ST;
            uniform float _QD;
            uniform float _GLOW;
            uniform float _V;
            uniform float _U;
            uniform float _RJ;
            uniform float _node_2650;
            uniform sampler2D _node_101; uniform float4 _node_101_ST;
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
                float4 node_9081 = _Time;
                float2 node_5609 = (float2((_U*node_9081.g),(_V*node_9081.g))+i.uv0);
                float4 _niuqu_tex_var = tex2D(_niuqu_tex,TRANSFORM_TEX(node_5609, _niuqu_tex));
                float2 node_1392 = ((_niuqu_tex_var.r*_QD)+i.uv0);
                float4 _node_101_var = tex2D(_node_101,TRANSFORM_TEX(node_1392, _node_101));
                float3 node_8427 = (_node_101_var.rgb/_RJ);
                clip(node_8427 - 0.5);
////// Lighting:
////// Emissive:
                float4 _Maintex_var = tex2D(_Maintex,TRANSFORM_TEX(node_1392, _Maintex));
                float node_7665_if_leA = step(node_8427,_node_2650);
                float node_7665_if_leB = step(_node_2650,node_8427);
                float node_933 = 1.0;
                float3 emissive = ((((2.0*_niuqu_tex_var.rgb)*_Maintex_var.rgb)+(_GLOW*lerp((node_7665_if_leA*node_933)+(node_7665_if_leB*0.0),node_933,node_7665_if_leA*node_7665_if_leB)))*(_Maintex_var.rgb*i.vertexColor.rgb*(_TintColor.rgb*_GLOW*_TintColor.a)*_Maintex_var.a*i.vertexColor.a));
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
            ColorMask RGB
            
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
            uniform sampler2D _niuqu_tex; uniform float4 _niuqu_tex_ST;
            uniform float _QD;
            uniform float _V;
            uniform float _U;
            uniform float _RJ;
            uniform sampler2D _node_101; uniform float4 _node_101_ST;
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
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 node_9081 = _Time;
                float2 node_5609 = (float2((_U*node_9081.g),(_V*node_9081.g))+i.uv0);
                float4 _niuqu_tex_var = tex2D(_niuqu_tex,TRANSFORM_TEX(node_5609, _niuqu_tex));
                float2 node_1392 = ((_niuqu_tex_var.r*_QD)+i.uv0);
                float4 _node_101_var = tex2D(_node_101,TRANSFORM_TEX(node_1392, _node_101));
                float3 node_8427 = (_node_101_var.rgb/_RJ);
                clip(node_8427 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    CustomEditor "ShaderForgeMaterialInspector"
}
