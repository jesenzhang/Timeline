// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


    Shader "Custom/OutLighting_Normal" {
        Properties {
            _OutlineColor ("Outline Color", Color) = (0,0,0,1)
            _Outline ("Outline width", Range (.002, 0.03)) = .005
            _MainTex ("Base (RGB)", 2D) = "white" { }
			_NormalTex ("Normal Tex", 2D) = "normal" {}
            
            _DiffuseStep("_DiffuseStep 0.1-3",Range(0.1,3)) = 0.5
            _SpecFacStep("_SpecFacStep 0.1-3",Range(0.1,3)) = 1
        }

        SubShader
        {
            pass
            {
                Name "OUTLINE"
                Tags { "LightMode" = "Always"}
                Cull front
                
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                sampler2D _MainTex;
                float4 _MainTex_ST;
				
                uniform float _Outline;
                uniform float4 _OutlineColor;

				struct appdata
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float2 texcoord : TEXCOORD0;
				};
                    
                struct v2f 
				{
                    float4 pos : POSITION;
                    float4 color : COLOR;
                };

                v2f vert (appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);

                    float3 norm   = mul ((float3x3)UNITY_MATRIX_IT_MV, v.normal);
                    float2 offset = TransformViewToProjection(norm.xy);

                    o.pos.xy += offset * o.pos.z * _Outline;
                    o.color = _OutlineColor;
                    return o;
                }
                float4 frag (v2f i) : COLOR
                {
                    return i.color;
                }
                ENDCG
            }

            pass
            {
                tags{"LightMode"="Vertex"}
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "Lighting.cginc"
				#include "AutoLight.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST;
				sampler2D _NormalTex;
				float4 _NormalTex_ST;

                float _DiffuseStep;
                float _SpecFacStep;

				struct appdata
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
				};

                struct v2f 
				{
                    float4  pos : SV_POSITION;
                    float2  uv_MainTex : TEXCOORD0;
                    float3 lightDir:TEXCOORD1;
                    float atten:TEXCOORD2;
                    float3 viewDir:TEXCOORD3;
					float2 uv_NormalTex : TEXCOORD4;
                    float3 normal:TEXCOORD5;
                } ;
                
                    
                float4x4 inverse(float4x4 input)
                {
                    #define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
                    //determinant(float3x3(input._22_23_23, input._32_33_34, input._42_43_44))
                 
                    float4x4 cofactors = float4x4(
                         minor(_22_23_24, _32_33_34, _42_43_44), 
                        -minor(_21_23_24, _31_33_34, _41_43_44),
                         minor(_21_22_24, _31_32_34, _41_42_44),
                        -minor(_21_22_23, _31_32_33, _41_42_43),
                 
                        -minor(_12_13_14, _32_33_34, _42_43_44),
                         minor(_11_13_14, _31_33_34, _41_43_44),
                        -minor(_11_12_14, _31_32_34, _41_42_44),
                         minor(_11_12_13, _31_32_33, _41_42_43),
                 
                         minor(_12_13_14, _22_23_24, _42_43_44),
                        -minor(_11_13_14, _21_23_24, _41_43_44),
                         minor(_11_12_14, _21_22_24, _41_42_44),
                        -minor(_11_12_13, _21_22_23, _41_42_43),
                 
                        -minor(_12_13_14, _22_23_24, _32_33_34),
                         minor(_11_13_14, _21_23_24, _31_33_34),
                        -minor(_11_12_14, _21_22_24, _31_32_34),
                         minor(_11_12_13, _21_22_23, _31_32_33)
                    );
                    #undef minor
                    return transpose(cofactors) / determinant(input);
                }
                
                v2f vert (appdata v)
                {
                    v2f o;
                    o.pos = UnityObjectToClipPos(v.vertex);
                    o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);
                    o.uv_NormalTex = TRANSFORM_TEX(v.texcoord, _NormalTex);
                    o.normal = v.normal;
                    
                    //#ifndef USING_DIRECTIONAL_LIGHT
                    //float3 lightPos = mul( inverse(UNITY_MATRIX_MV),unity_LightPosition[0]).xyz;
                    //o.lightDir = lightPos;
                    //#else
                    //o.lightDir = mul( inverse(UNITY_MATRIX_MV),unity_LightPosition[0]).xyz;
                    //#endif
                    
                    //float3 viewpos = mul (UNITY_MATRIX_MV, v.vertex).xyz;
                    //float3 toLight = unity_LightPosition[0].xyz - viewpos.xyz * unity_LightPosition[0].w;
                    //float lengthSq = dot(toLight, toLight);
                    //o.atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[0.5].z);
                    
                    //o.viewDir = mul ((float3x3)inverse(UNITY_MATRIX_MV), float3(0,0,1)).xyz;

					float3 viewpos = mul (UNITY_MATRIX_MV, v.vertex).xyz;
                    float3 toLight = unity_LightPosition[0].xyz - viewpos.xyz * unity_LightPosition[0].w;
                    float lengthSq = dot(toLight, toLight);
                    o.atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[0.5].z);
					TANGENT_SPACE_ROTATION;
					o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));
					o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex));
					TRANSFER_VERTEX_TO_FRAGMENT(o);

                    return o;
                }

                float4 frag (v2f i) : COLOR
                {
                    float4 texCol = tex2D(_MainTex,i.uv_MainTex);
                    //i.normal = normalize(i.normal);
					//float3 normal = normalize(UnpackNormal(tex2D(_NormalTex, i.uv_NormalTex)));
					float3 normal = UnpackNormal(tex2D(_NormalTex, i.uv_MainTex));
                    i.lightDir = normalize(i.lightDir);
                    i.viewDir = normalize(i.viewDir);
                    //(1)漫反射强度
                    float diffuseF = max(0,dot(normal,i.lightDir));
                    
                    //*** 漫反射光离散化 ***
                     diffuseF = floor(diffuseF* _DiffuseStep)/_DiffuseStep;
                       //(2)镜面反射强度
                    float specF;
                    float3 H = normalize(i.lightDir + i.viewDir);
                    float specBase = max(0,dot(normal,H));
                    // shininess 镜面强度系数
                    specF = pow(specBase,35);
                      
                    //*** 镜面反射光离散化 ***
                    specF = floor(specF* _SpecFacStep)/_SpecFacStep;
                    //(3)结合漫反射光与镜面反射光
                    float4 outp = texCol*unity_LightColor[0]*(0.9 + 0.5* diffuseF*i.atten )+ unity_LightColor[0]*specF *1;
                    return outp;
					//return texCol;
                }
                ENDCG
            }
        }
    }
