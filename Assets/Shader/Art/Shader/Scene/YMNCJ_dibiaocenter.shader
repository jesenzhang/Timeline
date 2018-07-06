// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Scene/YMNCJ_dibiaocenter"
{
	Properties
	{
		_YMNCJ_dibiao_D("YMNCJ_dibiao_D", 2D) = "white" {}
		_YMNCJ_dibiao_N("YMNCJ_dibiao_N", 2D) = "bump" {}
		_YMNCJ_MasterGround_D("YMNCJ_MasterGround_D", 2D) = "white" {}
		_YMNCJ_MasterGround_N("YMNCJ_MasterGround_N", 2D) = "bump" {}
		_dibiaoUV("dibiao UV", Float) = 1
		_heightmin("height min", Float) = 1
		_dibiaoRmax("dibiao R max", Float) = 0
		_dibiaoRmin("dibiao R min", Float) = 0
		_heightmax("height max", Float) = 0
		_mastergroundRmax("masterground R max", Float) = 0
		_mastergroundRmin("masterground R min", Float) = 0
		_mastergroundcolor("masterground color", Color) = (0,0,0,0)
		_diaobiaocolor("diaobiao color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _YMNCJ_MasterGround_N;
		uniform float4 _YMNCJ_MasterGround_N_ST;
		uniform sampler2D _YMNCJ_dibiao_N;
		uniform float _dibiaoUV;
		uniform float _heightmin;
		uniform float _heightmax;
		uniform sampler2D _YMNCJ_MasterGround_D;
		uniform float4 _YMNCJ_MasterGround_D_ST;
		uniform float4 _mastergroundcolor;
		uniform float4 _diaobiaocolor;
		uniform sampler2D _YMNCJ_dibiao_D;
		uniform float _mastergroundRmin;
		uniform float _mastergroundRmax;
		uniform float _dibiaoRmin;
		uniform float _dibiaoRmax;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_YMNCJ_MasterGround_N = i.uv_texcoord * _YMNCJ_MasterGround_N_ST.xy + _YMNCJ_MasterGround_N_ST.zw;
			float2 temp_cast_0 = (_dibiaoUV).xx;
			float2 uv_TexCoord11 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float3 tex2DNode21 = UnpackNormal( tex2D( _YMNCJ_dibiao_N, uv_TexCoord11 ) );
			float2 uv_YMNCJ_MasterGround_D = i.uv_texcoord * _YMNCJ_MasterGround_D_ST.xy + _YMNCJ_MasterGround_D_ST.zw;
			float4 tex2DNode22 = tex2D( _YMNCJ_MasterGround_D, uv_YMNCJ_MasterGround_D );
			float lerpResult27 = lerp( _heightmin , _heightmax , tex2DNode22.a);
			float lerpResult29 = lerp( 0.0 , lerpResult27 , i.vertexColor.r);
			float3 lerpResult7 = lerp( UnpackNormal( tex2D( _YMNCJ_MasterGround_N, uv_YMNCJ_MasterGround_N ) ) , tex2DNode21 , lerpResult29);
			o.Normal = lerpResult7;
			float4 lerpResult6 = lerp( ( _mastergroundcolor * tex2DNode22 ) , ( _diaobiaocolor * tex2D( _YMNCJ_dibiao_D, uv_TexCoord11 ) ) , lerpResult29);
			o.Albedo = lerpResult6.rgb;
			o.Metallic = 0.0;
			float lerpResult42 = lerp( _mastergroundRmin , _mastergroundRmax , tex2DNode22.a);
			float lerpResult36 = lerp( _dibiaoRmin , _dibiaoRmax , tex2DNode21.g);
			float lerpResult41 = lerp( lerpResult42 , lerpResult36 , i.vertexColor.r);
			o.Smoothness = lerpResult41;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14101
1927;33;1906;1004;1952.261;582.9913;1.41333;True;True
Node;AmplifyShaderEditor.RangedFloatNode;12;-2174.804,56.33405;Float;False;Property;_dibiaoUV;dibiao UV;4;0;Create;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1089.73,-348.8994;Float;False;Property;_heightmin;height min;5;0;Create;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1951.255,-73.60326;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1548.582,137.9299;Float;True;Property;_YMNCJ_MasterGround_D;YMNCJ_MasterGround_D;2;0;Create;Assets/DITAN/masterground/New Folder/new_dibiao/YMNCJ_MasterGround_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-1087.147,-250.1623;Float;False;Property;_heightmax;height max;8;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1527.477,-547.3793;Float;True;Property;_YMNCJ_dibiao_D;YMNCJ_dibiao_D;0;0;Create;Assets/DITAN/masterground/New Folder/new_dibiao/YMNCJ_dibiao_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;27;-835.6386,-208.4545;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;-946.8062,-463.6476;Float;False;Property;_mastergroundcolor;masterground color;11;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-1540.87,-290.1555;Float;True;Property;_YMNCJ_dibiao_N;YMNCJ_dibiao_N;1;0;Create;Assets/DITAN/masterground/New Folder/new_dibiao/YMNCJ_dibiao_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;45;-899.0977,-629.3719;Float;False;Property;_diaobiaocolor;diaobiao color;12;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-994.2137,825.6891;Float;False;Property;_dibiaoRmax;dibiao R max;6;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1125.359,340.5912;Float;False;Property;_mastergroundRmin;masterground R min;10;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1105.616,711.4655;Float;False;Property;_dibiaoRmin;dibiao R min;7;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;35;-948.7821,92.7187;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-1215.608,483.0183;Float;False;Property;_mastergroundRmax;masterground R max;9;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-539.1912,-448.5818;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;29;-643.7617,-63.29673;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-586.8997,-282.8576;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;23;-1545.854,359.5309;Float;True;Property;_YMNCJ_MasterGround_N;YMNCJ_MasterGround_N;3;0;Create;Assets/DITAN/masterground/New Folder/new_dibiao/YMNCJ_MasterGround_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;36;-748.757,652.5555;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;-806.6603,430.842;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;19.12644,-309.6038;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;39;138.1523,17.66248;Float;False;Constant;_Float0;Float 0;9;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;-472.4505,343.4117;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-204.6047,63.01407;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;487.3048,-100.5775;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;YMNCJ_dibiaocenter;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;12;0
WireConnection;20;1;11;0
WireConnection;27;0;26;0
WireConnection;27;1;28;0
WireConnection;27;2;22;4
WireConnection;21;1;11;0
WireConnection;44;0;45;0
WireConnection;44;1;20;0
WireConnection;29;1;27;0
WireConnection;29;2;35;1
WireConnection;46;0;47;0
WireConnection;46;1;22;0
WireConnection;36;0;40;0
WireConnection;36;1;37;0
WireConnection;36;2;21;2
WireConnection;42;0;38;0
WireConnection;42;1;43;0
WireConnection;42;2;22;4
WireConnection;6;0;46;0
WireConnection;6;1;44;0
WireConnection;6;2;29;0
WireConnection;41;0;42;0
WireConnection;41;1;36;0
WireConnection;41;2;35;1
WireConnection;7;0;23;0
WireConnection;7;1;21;0
WireConnection;7;2;29;0
WireConnection;0;0;6;0
WireConnection;0;1;7;0
WireConnection;0;3;39;0
WireConnection;0;4;41;0
ASEEND*/
//CHKSM=744D43B472BC3E622E136820D3FC0F743D21FEAF