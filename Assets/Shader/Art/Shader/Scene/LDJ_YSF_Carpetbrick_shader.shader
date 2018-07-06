// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Scene/YSF_Carpetbrick_shader"
{
	Properties
	{
		_YSF_Carpetbrick_D("YSF_Carpetbrick_D", 2D) = "white" {}
		_YSF_Carpetbrick_N("YSF_Carpetbrick_N", 2D) = "bump" {}
		[Toggle] _Keyword1("Keyword 1", Float) = 0.0
		[Toggle] _Keyword2("Keyword 2", Float) = 0.0
		[Toggle] _Keyword0("Keyword 0", Float) = 0.0
		_metal_smoothness("metal_smoothness", Float) = 0
		_brick_smoothness("brick_smoothness", Float) = 0
		_unmetal_smoothness("unmetal_smoothness", Float) = 0
		_brick_HW_color("brick_HW_color", Color) = (0,0,0,0)
		_brick_color("brick_color", Color) = (0,0,0,0)
		_half_metal("half_metal", Float) = 0
		_YSF_Carpetbrick_R("YSF_Carpetbrick_R", 2D) = "white" {}
		_halfmetal_color("halfmetal_color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _KEYWORD2_ON
		#pragma shader_feature _KEYWORD0_ON
		#pragma shader_feature _KEYWORD1_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _YSF_Carpetbrick_N;
		uniform float4 _YSF_Carpetbrick_N_ST;
		uniform float4 _brick_color;
		uniform sampler2D _YSF_Carpetbrick_D;
		uniform float4 _YSF_Carpetbrick_D_ST;
		uniform float4 _brick_HW_color;
		uniform sampler2D _YSF_Carpetbrick_R;
		uniform float4 _YSF_Carpetbrick_R_ST;
		uniform float4 _halfmetal_color;
		uniform float _half_metal;
		uniform float _brick_smoothness;
		uniform float _metal_smoothness;
		uniform float _unmetal_smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_YSF_Carpetbrick_N = i.uv_texcoord * _YSF_Carpetbrick_N_ST.xy + _YSF_Carpetbrick_N_ST.zw;
			o.Normal = UnpackNormal( tex2D( _YSF_Carpetbrick_N, uv_YSF_Carpetbrick_N ) );
			float2 uv_YSF_Carpetbrick_D = i.uv_texcoord * _YSF_Carpetbrick_D_ST.xy + _YSF_Carpetbrick_D_ST.zw;
			float4 tex2DNode1 = tex2D( _YSF_Carpetbrick_D, uv_YSF_Carpetbrick_D );
			float4 temp_output_30_0 = ( _brick_color * tex2DNode1 );
			float2 uv_YSF_Carpetbrick_R = i.uv_texcoord * _YSF_Carpetbrick_R_ST.xy + _YSF_Carpetbrick_R_ST.zw;
			float4 tex2DNode36 = tex2D( _YSF_Carpetbrick_R, uv_YSF_Carpetbrick_R );
			float4 lerpResult29 = lerp( temp_output_30_0 , _brick_HW_color , tex2DNode36.r);
			#ifdef _KEYWORD2_ON
				float4 staticSwitch28 = lerpResult29;
			#else
				float4 staticSwitch28 = temp_output_30_0;
			#endif
			float4 lerpResult21 = lerp( staticSwitch28 , staticSwitch28 , tex2DNode36.r);
			float4 lerpResult39 = lerp( lerpResult21 , ( tex2DNode1 * _halfmetal_color ) , tex2DNode36.b);
			o.Albedo = lerpResult39.rgb;
			float lerpResult37 = lerp( 0.0 , _half_metal , tex2DNode36.b);
			float lerpResult4 = lerp( lerpResult37 , 1.0 , tex2DNode36.r);
			#ifdef _KEYWORD0_ON
				float staticSwitch7 = lerpResult4;
			#else
				float staticSwitch7 = 0.0;
			#endif
			o.Metallic = staticSwitch7;
			float2 _Vector0 = float2(0.1,1.2);
			float clampResult24 = clamp( _metal_smoothness , _Vector0.x , _Vector0.y );
			float lerpResult8 = lerp( ( tex2DNode36.g * _brick_smoothness ) , pow( ( tex2DNode36.g * clampResult24 ) , clampResult24 ) , tex2DNode36.r);
			float2 _Vector1 = float2(0.1,1.2);
			float clampResult34 = clamp( _unmetal_smoothness , _Vector1.x , _Vector1.y );
			#ifdef _KEYWORD1_ON
				float staticSwitch15 = lerpResult8;
			#else
				float staticSwitch15 = ( clampResult34 * tex2DNode36.g );
			#endif
			o.Smoothness = staticSwitch15;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14101
1927;29;1906;1004;1744.885;321.973;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;14;-1534.301,749.1666;Float;False;Property;_metal_smoothness;metal_smoothness;5;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-1423.641,878.1183;Float;False;Constant;_Vector0;Vector 0;9;0;Create;0.1,1.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;31;-1200.2,-217.5281;Float;False;Property;_brick_color;brick_color;9;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1411.389,-540.0853;Float;True;Property;_YSF_Carpetbrick_D;YSF_Carpetbrick_D;0;0;Create;Assets/DITAN/YSF_Carpetbirck/YSF_Carpetbrick_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;24;-1153.181,719.1376;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-1452.875,100.6923;Float;True;Property;_YSF_Carpetbrick_R;YSF_Carpetbrick_R;11;0;Create;Assets/DITAN/YSF_Carpetbirck/YSF_Carpetbrick_R.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-950.8699,-502.9816;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-1166.859,-873.1902;Float;False;Property;_brick_HW_color;brick_HW_color;8;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;35;-1049.827,1070.47;Float;False;Constant;_Vector1;Vector 1;9;0;Create;0.1,1.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;38;-1062.461,-6.75946;Float;False;Property;_half_metal;half_metal;10;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1075.899,917.1084;Float;False;Property;_unmetal_smoothness;unmetal_smoothness;7;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-949.7997,604.6667;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1140.2,384.6;Float;False;Property;_brick_smoothness;brick_smoothness;6;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;-687.8155,-683.1061;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-880.3595,-146.2086;Float;False;Constant;_metal;metal;3;0;Create;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;-815.0615,55.24056;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;34;-779.3666,911.4894;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;28;-471.1082,-583.4739;Float;False;Property;_Keyword2;Keyword 2;3;0;Create;0;False;True;;Toggle;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-878.1,333.7;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;23;-731.4805,587.0377;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-801.0433,-350.801;Float;False;Property;_halfmetal_color;halfmetal_color;12;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-612.1492,843.7317;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-708.3595,-95.20864;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-63.69939,-467.008;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;8;-602.2003,287.7001;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-257.6435,-356.0008;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-613.4,135.8001;Float;False;Constant;_unmetal;unmetal;3;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-364,533;Float;True;Property;_YSF_Carpetbrick_N;YSF_Carpetbrick_N;1;0;Create;Assets/DITAN/YSF_Carpetbirck/YSF_Carpetbrick_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;15;-298.8,308.4;Float;False;Property;_Keyword1;Keyword 1;2;0;Create;0;False;True;;Toggle;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;67.35622,-242.9012;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;7;-411,64;Float;False;Property;_Keyword0;Keyword 0;4;0;Create;0;False;True;;Toggle;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;258,4;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;YSF_Carpetbrick_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;14;0
WireConnection;24;1;27;1
WireConnection;24;2;27;2
WireConnection;30;0;31;0
WireConnection;30;1;1;0
WireConnection;13;0;36;2
WireConnection;13;1;24;0
WireConnection;29;0;30;0
WireConnection;29;1;22;0
WireConnection;29;2;36;1
WireConnection;37;1;38;0
WireConnection;37;2;36;3
WireConnection;34;0;17;0
WireConnection;34;1;35;1
WireConnection;34;2;35;2
WireConnection;28;0;29;0
WireConnection;28;1;30;0
WireConnection;9;0;36;2
WireConnection;9;1;10;0
WireConnection;23;0;13;0
WireConnection;23;1;24;0
WireConnection;16;0;34;0
WireConnection;16;1;36;2
WireConnection;4;0;37;0
WireConnection;4;1;5;0
WireConnection;4;2;36;1
WireConnection;21;0;28;0
WireConnection;21;1;28;0
WireConnection;21;2;36;1
WireConnection;8;0;9;0
WireConnection;8;1;23;0
WireConnection;8;2;36;1
WireConnection;41;0;1;0
WireConnection;41;1;40;0
WireConnection;15;0;8;0
WireConnection;15;1;16;0
WireConnection;39;0;21;0
WireConnection;39;1;41;0
WireConnection;39;2;36;3
WireConnection;7;0;4;0
WireConnection;7;1;6;0
WireConnection;0;0;39;0
WireConnection;0;1;3;0
WireConnection;0;3;7;0
WireConnection;0;4;15;0
ASEEND*/
//CHKSM=5F033C39E7DE5BBFE109D7BA3477F3C71D61EEE6