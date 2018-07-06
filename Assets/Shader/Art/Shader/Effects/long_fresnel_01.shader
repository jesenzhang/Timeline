// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32739,y:32704,varname:node_4013,prsc:2|normal-727-RGB,emission-672-OUT,alpha-6809-OUT;n:type:ShaderForge.SFN_Tex2d,id:4598,x:31570,y:33026,ptovrint:False,ptlb:node_4598,ptin:_node_4598,varname:node_4598,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:dd6f28e1366da614baa4d58f83fc1902,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:727,x:32330,y:32671,ptovrint:False,ptlb:node_727,ptin:_node_727,varname:node_727,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:d36cb77c8c311814a8ab52a558d3f785,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:6809,x:32360,y:32969,varname:node_6809,prsc:2|A-4598-A,B-4194-A,C-9894-OUT;n:type:ShaderForge.SFN_VertexColor,id:4194,x:31950,y:33137,varname:node_4194,prsc:2;n:type:ShaderForge.SFN_Fresnel,id:9187,x:31139,y:32725,varname:node_9187,prsc:2|NRM-9448-OUT,EXP-4487-OUT;n:type:ShaderForge.SFN_NormalVector,id:9448,x:30901,y:32725,prsc:2,pt:False;n:type:ShaderForge.SFN_ValueProperty,id:4487,x:30901,y:32924,ptovrint:False,ptlb:S1,ptin:_S1,varname:node_4487,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Color,id:4250,x:31139,y:32864,ptovrint:False,ptlb:node_4250,ptin:_node_4250,varname:node_4250,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:4683,x:31373,y:32725,varname:node_4683,prsc:2|A-9187-OUT,B-4250-RGB;n:type:ShaderForge.SFN_Add,id:7157,x:31580,y:32866,varname:node_7157,prsc:2|A-4683-OUT,B-3156-OUT;n:type:ShaderForge.SFN_Multiply,id:3156,x:31364,y:33070,varname:node_3156,prsc:2|A-2210-OUT,B-5815-RGB;n:type:ShaderForge.SFN_Fresnel,id:2210,x:31139,y:33070,varname:node_2210,prsc:2|NRM-1982-OUT,EXP-3321-OUT;n:type:ShaderForge.SFN_NormalVector,id:1982,x:30901,y:33070,prsc:2,pt:False;n:type:ShaderForge.SFN_ValueProperty,id:3321,x:30891,y:33259,ptovrint:False,ptlb:S2,ptin:_S2,varname:_S_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Color,id:5815,x:31126,y:33228,ptovrint:False,ptlb:node_4250_copy,ptin:_node_4250_copy,varname:_node_4250_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:7820,x:32027,y:32907,varname:node_7820,prsc:2|A-7157-OUT,B-6354-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8171,x:31570,y:33232,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_8171,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:10;n:type:ShaderForge.SFN_Multiply,id:6354,x:31803,y:33026,varname:node_6354,prsc:2|A-4598-RGB,B-8171-OUT;n:type:ShaderForge.SFN_Tex2d,id:3650,x:31595,y:33578,ptovrint:False,ptlb:node_3650,ptin:_node_3650,varname:node_3650,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_If,id:9894,x:31995,y:33344,varname:node_9894,prsc:2|A-6433-OUT,B-3650-R,GT-3084-OUT,EQ-3084-OUT,LT-1646-OUT;n:type:ShaderForge.SFN_If,id:287,x:32030,y:33609,varname:node_287,prsc:2|A-9076-OUT,B-3650-R,GT-3084-OUT,EQ-3084-OUT,LT-1646-OUT;n:type:ShaderForge.SFN_Slider,id:6433,x:31475,y:33417,ptovrint:False,ptlb:RJ,ptin:_RJ,varname:node_6433,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:-1,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:3084,x:31755,y:33532,varname:node_3084,prsc:2,v1:0;n:type:ShaderForge.SFN_Vector1,id:1646,x:31755,y:33606,varname:node_1646,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:9076,x:31835,y:33730,varname:node_9076,prsc:2|A-6433-OUT,B-3222-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3222,x:31611,y:33819,ptovrint:False,ptlb:RJ_b,ptin:_RJ_b,varname:node_3222,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.05;n:type:ShaderForge.SFN_Subtract,id:1782,x:32271,y:33468,varname:node_1782,prsc:2|A-9894-OUT,B-287-OUT;n:type:ShaderForge.SFN_Multiply,id:9167,x:32514,y:33194,varname:node_9167,prsc:2|A-1275-RGB,B-1782-OUT,C-7883-OUT;n:type:ShaderForge.SFN_Color,id:1275,x:32238,y:33151,ptovrint:False,ptlb:node_1275,ptin:_node_1275,varname:node_1275,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:7883,x:32238,y:33344,ptovrint:False,ptlb:B_glow,ptin:_B_glow,varname:node_7883,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:12;n:type:ShaderForge.SFN_Add,id:672,x:32537,y:32868,varname:node_672,prsc:2|A-7820-OUT,B-9167-OUT;proporder:727-4598-4487-4250-3321-5815-8171-3650-6433-3222-1275-7883;pass:END;sub:END;*/

Shader "LDJ/Fx/long_fresnel_01" {
    Properties {
        _node_727 ("node_727", 2D) = "white" {}
        _node_4598 ("node_4598", 2D) = "white" {}
        _S1 ("S1", Float ) = 1
        _node_4250 ("node_4250", Color) = (1,1,1,1)
        _S2 ("S2", Float ) = 10
        _node_4250_copy ("node_4250_copy", Color) = (1,1,1,1)
        _glow ("glow", Float ) = 10
        _node_3650 ("node_3650", 2D) = "white" {}
        _RJ ("RJ", Range(-1, 1)) = 0
        _RJ_b ("RJ_b", Float ) = 0.05
        _node_1275 ("node_1275", Color) = (1,1,1,1)
        _B_glow ("B_glow", Float ) = 12
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
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _node_4598; uniform float4 _node_4598_ST;
            uniform sampler2D _node_727; uniform float4 _node_727_ST;
            uniform float _S1;
            uniform float4 _node_4250;
            uniform float _S2;
            uniform float4 _node_4250_copy;
            uniform float _glow;
            uniform sampler2D _node_3650; uniform float4 _node_3650_ST;
            uniform float _RJ;
            uniform float _RJ_b;
            uniform float4 _node_1275;
            uniform float _B_glow;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _node_727_var = tex2D(_node_727,TRANSFORM_TEX(i.uv0, _node_727));
                float3 normalLocal = _node_727_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
////// Lighting:
////// Emissive:
                float4 _node_4598_var = tex2D(_node_4598,TRANSFORM_TEX(i.uv0, _node_4598));
                float4 _node_3650_var = tex2D(_node_3650,TRANSFORM_TEX(i.uv0, _node_3650));
                float node_9894_if_leA = step(_RJ,_node_3650_var.r);
                float node_9894_if_leB = step(_node_3650_var.r,_RJ);
                float node_1646 = 1.0;
                float node_3084 = 0.0;
                float node_9894 = lerp((node_9894_if_leA*node_1646)+(node_9894_if_leB*node_3084),node_3084,node_9894_if_leA*node_9894_if_leB);
                float node_287_if_leA = step((_RJ+_RJ_b),_node_3650_var.r);
                float node_287_if_leB = step(_node_3650_var.r,(_RJ+_RJ_b));
                float3 emissive = ((((pow(1.0-max(0,dot(i.normalDir, viewDirection)),_S1)*_node_4250.rgb)+(pow(1.0-max(0,dot(i.normalDir, viewDirection)),_S2)*_node_4250_copy.rgb))*(_node_4598_var.rgb*_glow))+(_node_1275.rgb*(node_9894-lerp((node_287_if_leA*node_1646)+(node_287_if_leB*node_3084),node_3084,node_287_if_leA*node_287_if_leB))*_B_glow));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,(_node_4598_var.a*i.vertexColor.a*node_9894));
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
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
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
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
