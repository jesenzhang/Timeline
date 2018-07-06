// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:33034,y:32757,varname:node_4013,prsc:2|normal-5942-RGB,emission-4212-OUT,alpha-5896-OUT;n:type:ShaderForge.SFN_Tex2d,id:1785,x:32107,y:32691,ptovrint:False,ptlb:node_1785,ptin:_node_1785,varname:node_1785,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:1a75f3d46249a2745af0aff87682725c,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:2245,x:32331,y:32828,varname:node_2245,prsc:2|A-1785-RGB,B-7720-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7720,x:32138,y:32909,ptovrint:False,ptlb:F,ptin:_F,varname:node_7720,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:6;n:type:ShaderForge.SFN_Fresnel,id:4311,x:31971,y:32946,varname:node_4311,prsc:2|EXP-154-OUT;n:type:ShaderForge.SFN_Vector1,id:154,x:31793,y:33045,varname:node_154,prsc:2,v1:1;n:type:ShaderForge.SFN_Multiply,id:5335,x:32243,y:32986,varname:node_5335,prsc:2|A-4311-OUT,B-7483-RGB;n:type:ShaderForge.SFN_Color,id:7483,x:32092,y:33050,ptovrint:False,ptlb:c,ptin:_c,varname:node_7483,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3161765,c2:0.4623732,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:2270,x:32276,y:33244,varname:node_2270,prsc:2|A-3544-OUT,B-2284-RGB;n:type:ShaderForge.SFN_Fresnel,id:3544,x:32082,y:33219,varname:node_3544,prsc:2|EXP-8855-OUT;n:type:ShaderForge.SFN_Color,id:2284,x:32082,y:33385,ptovrint:False,ptlb:t,ptin:_t,varname:_node_7483_copy,prsc:2,glob:False,taghide:False,taghdr:True,tagprd:False,tagnsco:False,tagnrm:False,c1:0.3161765,c2:0.4623732,c3:1,c4:1;n:type:ShaderForge.SFN_Vector1,id:8855,x:31898,y:33243,varname:node_8855,prsc:2,v1:10;n:type:ShaderForge.SFN_Add,id:826,x:32426,y:33087,varname:node_826,prsc:2|A-5335-OUT,B-2270-OUT;n:type:ShaderForge.SFN_Multiply,id:5071,x:32536,y:32911,varname:node_5071,prsc:2|A-2245-OUT,B-826-OUT;n:type:ShaderForge.SFN_Multiply,id:9645,x:32670,y:32911,varname:node_9645,prsc:2|A-5071-OUT,B-9095-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9095,x:32582,y:33075,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_9095,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:3;n:type:ShaderForge.SFN_Tex2d,id:5942,x:32677,y:32633,ptovrint:False,ptlb:node_5942,ptin:_node_5942,varname:node_5942,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:aaefa3b59962d4044ae07d7103e3d0a8,ntxv:3,isnm:True;n:type:ShaderForge.SFN_If,id:5896,x:32665,y:33539,varname:node_5896,prsc:2|A-5302-OUT,B-1393-R,GT-5856-OUT,EQ-5856-OUT,LT-5934-OUT;n:type:ShaderForge.SFN_Slider,id:5302,x:32239,y:33516,ptovrint:False,ptlb:RJ,ptin:_RJ,varname:node_5302,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:-1,max:1;n:type:ShaderForge.SFN_Tex2d,id:1393,x:32304,y:33614,ptovrint:False,ptlb:node_1393,ptin:_node_1393,varname:node_1393,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:0f79e7c19743c81458f0446b7bc39733,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Vector1,id:5856,x:32453,y:33643,varname:node_5856,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:5934,x:32453,y:33710,varname:node_5934,prsc:2,v1:1;n:type:ShaderForge.SFN_If,id:4082,x:32685,y:33747,varname:node_4082,prsc:2|A-6218-OUT,B-1393-R,GT-5856-OUT,EQ-5856-OUT,LT-5934-OUT;n:type:ShaderForge.SFN_Add,id:6218,x:32517,y:33785,varname:node_6218,prsc:2|A-5302-OUT,B-3452-OUT;n:type:ShaderForge.SFN_Subtract,id:6552,x:32868,y:33564,varname:node_6552,prsc:2|A-5896-OUT,B-4082-OUT;n:type:ShaderForge.SFN_Add,id:4212,x:32836,y:32911,varname:node_4212,prsc:2|A-9645-OUT,B-2258-OUT;n:type:ShaderForge.SFN_Multiply,id:2258,x:32826,y:33254,varname:node_2258,prsc:2|A-7243-RGB,B-6552-OUT,C-7293-OUT;n:type:ShaderForge.SFN_Color,id:7243,x:32611,y:33214,ptovrint:False,ptlb:N_color,ptin:_N_color,varname:node_7243,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:7293,x:32562,y:33421,ptovrint:False,ptlb:B_glow,ptin:_B_glow,varname:node_7293,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:12;n:type:ShaderForge.SFN_ValueProperty,id:3452,x:32288,y:33859,ptovrint:False,ptlb:RJ_b,ptin:_RJ_b,varname:node_3452,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;proporder:1785-7720-7483-2284-9095-5942-5302-1393-7243-7293-3452;pass:END;sub:END;*/

Shader "LDJ/Fx/ldj_wutiFresnel_01" {
    Properties {
        _node_1785 ("node_1785", 2D) = "white" {}
        _F ("F", Float ) = 6
        [HDR]_c ("c", Color) = (0.3161765,0.4623732,1,1)
        [HDR]_t ("t", Color) = (0.3161765,0.4623732,1,1)
        _glow ("glow", Float ) = 3
        _node_5942 ("node_5942", 2D) = "bump" {}
        _RJ ("RJ", Range(-1, 1)) = -1
        _node_1393 ("node_1393", 2D) = "white" {}
        _N_color ("N_color", Color) = (1,1,1,1)
        _B_glow ("B_glow", Float ) = 12
        _RJ_b ("RJ_b", Float ) = 0.05
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
            uniform sampler2D _node_1785; uniform float4 _node_1785_ST;
            uniform float _F;
            uniform float4 _c;
            uniform float4 _t;
            uniform float _glow;
            uniform sampler2D _node_5942; uniform float4 _node_5942_ST;
            uniform float _RJ;
            uniform sampler2D _node_1393; uniform float4 _node_1393_ST;
            uniform float4 _N_color;
            uniform float _B_glow;
            uniform float _RJ_b;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _node_5942_var = UnpackNormal(tex2D(_node_5942,TRANSFORM_TEX(i.uv0, _node_5942)));
                float3 normalLocal = _node_5942_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
////// Lighting:
////// Emissive:
                float4 _node_1785_var = tex2D(_node_1785,TRANSFORM_TEX(i.uv0, _node_1785));
                float4 _node_1393_var = tex2D(_node_1393,TRANSFORM_TEX(i.uv0, _node_1393));
                float node_5896_if_leA = step(_RJ,_node_1393_var.r);
                float node_5896_if_leB = step(_node_1393_var.r,_RJ);
                float node_5934 = 1.0;
                float node_5856 = 0.0;
                float node_5896 = lerp((node_5896_if_leA*node_5934)+(node_5896_if_leB*node_5856),node_5856,node_5896_if_leA*node_5896_if_leB);
                float node_4082_if_leA = step((_RJ+_RJ_b),_node_1393_var.r);
                float node_4082_if_leB = step(_node_1393_var.r,(_RJ+_RJ_b));
                float3 emissive = ((((_node_1785_var.rgb*_F)*((pow(1.0-max(0,dot(normalDirection, viewDirection)),1.0)*_c.rgb)+(pow(1.0-max(0,dot(normalDirection, viewDirection)),10.0)*_t.rgb)))*_glow)+(_N_color.rgb*(node_5896-lerp((node_4082_if_leA*node_5934)+(node_4082_if_leB*node_5856),node_5856,node_4082_if_leA*node_4082_if_leB))*_B_glow));
                float3 finalColor = emissive;
                return fixed4(finalColor,node_5896);
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
