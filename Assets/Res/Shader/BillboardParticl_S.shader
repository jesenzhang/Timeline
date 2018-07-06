Shader "Billboard/BillboardParticl_S" 
    {
        Properties 
        {
            _MainTex ("Base (RGB)", 2D) = "white" {}
            _Disappear( "Disappear", Range(0, 20) ) = 8
            _Life("Life", float) = 1//1.5
            _Speed("Speed", float) = 2
            _Acce("Acce", float) = -0.9
            _B("Scale time", float) = 0.125
            _C("Scale size", float) = 1
        }

        Subshader 
        {
            Tags { "Queue"="Transparent+1000" "IgnoreProjector"="True" "RenderType"="Transparent" }
			Fog { Mode Off }
			Cull Off
			Blend SrcAlpha  OneMinusSrcAlpha
			ZWrite Off
			Lighting Off
            Pass 
            {
				CGPROGRAM
				#pragma noambient
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #pragma glsl_no_auto_normalization
                #include "UnityCG.cginc"                


				
				struct appdata_t
				{
					float4 vertex : POSITION;
					float2 texcoord : TEXCOORD0;
					float2 texcoord1 : TEXCOORD1;
					float4 color : COLOR;
					float4 tangent : TANGENT;
				};

                struct v2f 
                { 
                    fixed4   pos : SV_POSITION;
                    fixed2   uv : TEXCOORD0;
                    fixed4   clr : COLOR;
                };

                fixed4 _MainTex_ST;
                float _Disappear;
                
                float _Life;
                float _Speed;
                float _Acce;
                float _B;
                float _C;
                //v2f vert (appdata_full v)
                v2f vert (appdata_t v)
                {
                    v2f o;
					float time = _Time.y - v.tangent.z;
					if( time < _Life )
					{
					
							float dTime = time - _B;
							dTime *= sqrt(_C)/_B;
							float scale = _C - dTime*dTime;
							scale = max(0.0,scale)*v.tangent.w;
							
							v.tangent.xy += v.tangent.xy * scale;
						
                    	float4 camspacePos = mul (UNITY_MATRIX_V, v.vertex);
                    
                    	camspacePos.y += _Speed * time + time * time * _Acce;
						camspacePos.x += v.texcoord1.x * time * time;// + time * time * _Acce * v.texcoord1.x * 0.5;
                    	camspacePos = float4( v.tangent.xy + camspacePos.xy, camspacePos.z, 1);
                    	o.pos = mul (UNITY_MATRIX_P, camspacePos);
                    	o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                    	o.clr = v.color;
                    	o.clr.a = 1.0 - pow( time / _Life, _Disappear );
                    }
                    else
                    {
                    	o.pos = float4( 0,0,0,0 );
                    }
                    return o;
                }

                sampler2D _MainTex;
				
                fixed4 frag (v2f i) : COLOR
                {
                    fixed4 c = tex2D(_MainTex,i.uv);
                    c *= i.clr;
                    return c;
                 // return i.clr;
                }
                ENDCG
            }
        }
		fallback "Mobile/Unlit (Supports Lightmap)"
    }
