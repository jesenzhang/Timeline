// Shader created with Shader Forge v1.38 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:0,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:32881,y:32683,varname:node_4013,prsc:2|normal-7997-OUT,emission-7044-OUT,alpha-1019-OUT;n:type:ShaderForge.SFN_Fresnel,id:1180,x:32128,y:32787,varname:node_1180,prsc:2|EXP-953-OUT;n:type:ShaderForge.SFN_Color,id:8917,x:32103,y:32608,ptovrint:False,ptlb:node_8917,ptin:_node_8917,varname:node_8917,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:6470,x:32423,y:32849,varname:node_6470,prsc:2|A-8917-RGB,B-1180-OUT,C-1442-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1442,x:32236,y:32971,ptovrint:False,ptlb:glow,ptin:_glow,varname:node_1442,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:6;n:type:ShaderForge.SFN_Slider,id:953,x:31775,y:32873,ptovrint:False,ptlb:node_953,ptin:_node_953,varname:node_953,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:6.128205,max:10;n:type:ShaderForge.SFN_Tex2d,id:5591,x:32110,y:33053,ptovrint:False,ptlb:node_5591,ptin:_node_5591,varname:node_5591,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:be48a2bc1dd94e0489a9267550ac7433,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Multiply,id:7997,x:32461,y:33065,varname:node_7997,prsc:2|A-5591-RGB,B-9248-OUT;n:type:ShaderForge.SFN_Vector1,id:9248,x:32236,y:33222,varname:node_9248,prsc:2,v1:3;n:type:ShaderForge.SFN_Vector1,id:9147,x:32464,y:33448,varname:node_9147,prsc:2,v1:0;n:type:ShaderForge.SFN_VertexColor,id:3081,x:32261,y:32595,varname:node_3081,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7044,x:32551,y:32640,varname:node_7044,prsc:2|A-3081-RGB,B-6470-OUT;n:type:ShaderForge.SFN_Multiply,id:1019,x:32682,y:32942,varname:node_1019,prsc:2|A-3081-A,B-8917-A;proporder:8917-1442-953-5591;pass:END;sub:END;*/

Shader "LDJ/Fx/Fresnel-b" {
    Properties {
        _node_8917 ("node_8917", Color) = (1,1,1,1)
        _glow ("glow", Float ) = 6
        _node_953 ("node_953", Range(0, 10)) = 6.128205
        _node_5591 ("node_5591", 2D) = "bump" {}
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
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform float4 _node_8917;
            uniform float _glow;
            uniform float _node_953;
            uniform sampler2D _node_5591; uniform float4 _node_5591_ST;
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
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _node_5591_var = UnpackNormal(tex2D(_node_5591,TRANSFORM_TEX(i.uv0, _node_5591)));
                float3 normalLocal = (_node_5591_var.rgb*3.0);
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
////// Lighting:
////// Emissive:
                float3 emissive = (i.vertexColor.rgb*(_node_8917.rgb*pow(1.0-max(0,dot(normalDirection, viewDirection)),_node_953)*_glow));
                float3 finalColor = emissive;
                return fixed4(finalColor,(i.vertexColor.a*_node_8917.a));
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
