// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Scene/YSF_Brick_shader"
{
	Properties
	{
		_T_YSF_EBcarpet_D("T_YSF_EBcarpet_D", 2D) = "white" {}
		_T_YSF_EBcarpet_Mask("T_YSF_EBcarpet_Mask", 2D) = "white" {}
		_T_YSF_EBcarpet_N("T_YSF_EBcarpet_N", 2D) = "bump" {}
		_metal_smoothness("metal_smoothness", Float) = 0
		_T_YSF_Brick_N("T_YSF_Brick_N", 2D) = "bump" {}
		_T_YSF_Brick_D("T_YSF_Brick_D", 2D) = "white" {}
		_stone_smoothness("stone_smoothness", Float) = 0
		_stone_tileing("stone_tileing", Vector) = (0,0,0,0)
		_stone_offest("stone_offest", Vector) = (0,0,0,0)
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
		};

		uniform sampler2D _T_YSF_EBcarpet_N;
		uniform float4 _T_YSF_EBcarpet_N_ST;
		uniform sampler2D _T_YSF_Brick_N;
		uniform float2 _stone_tileing;
		uniform float2 _stone_offest;
		uniform sampler2D _T_YSF_EBcarpet_Mask;
		uniform float4 _T_YSF_EBcarpet_Mask_ST;
		uniform sampler2D _T_YSF_EBcarpet_D;
		uniform float4 _T_YSF_EBcarpet_D_ST;
		uniform sampler2D _T_YSF_Brick_D;
		uniform float _stone_smoothness;
		uniform float _metal_smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_T_YSF_EBcarpet_N = i.uv_texcoord * _T_YSF_EBcarpet_N_ST.xy + _T_YSF_EBcarpet_N_ST.zw;
			float2 uv_TexCoord11 = i.uv_texcoord * _stone_tileing + _stone_offest;
			float2 uv_T_YSF_EBcarpet_Mask = i.uv_texcoord * _T_YSF_EBcarpet_Mask_ST.xy + _T_YSF_EBcarpet_Mask_ST.zw;
			float4 tex2DNode2 = tex2D( _T_YSF_EBcarpet_Mask, uv_T_YSF_EBcarpet_Mask );
			float3 lerpResult10 = lerp( UnpackNormal( tex2D( _T_YSF_EBcarpet_N, uv_T_YSF_EBcarpet_N ) ) , UnpackNormal( tex2D( _T_YSF_Brick_N, uv_TexCoord11 ) ) , tex2DNode2.a);
			o.Normal = lerpResult10;
			float2 uv_T_YSF_EBcarpet_D = i.uv_texcoord * _T_YSF_EBcarpet_D_ST.xy + _T_YSF_EBcarpet_D_ST.zw;
			float4 tex2DNode8 = tex2D( _T_YSF_Brick_D, uv_TexCoord11 );
			float4 lerpResult13 = lerp( tex2D( _T_YSF_EBcarpet_D, uv_T_YSF_EBcarpet_D ) , tex2DNode8 , tex2DNode2.a);
			o.Albedo = lerpResult13.rgb;
			o.Metallic = tex2DNode2.r;
			float lerpResult4 = lerp( ( _stone_smoothness * tex2DNode8.a ) , ( _metal_smoothness * tex2DNode2.g ) , tex2DNode2.r);
			o.Smoothness = lerpResult4;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14101
1927;29;1906;1004;2518.39;741.3082;2.245011;True;True
Node;AmplifyShaderEditor.Vector2Node;12;-1815.408,435.1864;Float;False;Property;_stone_tileing;stone_tileing;7;0;Create;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;17;-1791.634,683.6359;Float;False;Property;_stone_offest;stone_offest;8;0;Create;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1499.408,520.1864;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-928.4219,-13.43816;Float;False;Property;_metal_smoothness;metal_smoothness;3;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-734.7868,367.6762;Float;False;Property;_stone_smoothness;stone_smoothness;6;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1087.137,496.5679;Float;True;Property;_T_YSF_Brick_D;T_YSF_Brick_D;5;0;Create;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1139,113;Float;True;Property;_T_YSF_EBcarpet_Mask;T_YSF_EBcarpet_Mask;1;0;Create;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1092.976,723.2802;Float;True;Property;_T_YSF_Brick_N;T_YSF_Brick_N;4;0;Create;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-660,165;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-545.8907,595.9919;Float;True;Property;_T_YSF_EBcarpet_N;T_YSF_EBcarpet_N;2;0;Create;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-809.6002,-382.3;Float;True;Property;_T_YSF_EBcarpet_D;T_YSF_EBcarpet_D;0;0;Create;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-534.587,450.8763;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-209,89;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-10.98283,622.4714;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;13;-320.4538,-255.2231;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;296.4034,-126.9251;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;YSF_Brick_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;12;0
WireConnection;11;1;17;0
WireConnection;8;1;11;0
WireConnection;7;1;11;0
WireConnection;6;0;5;0
WireConnection;6;1;2;2
WireConnection;16;0;15;0
WireConnection;16;1;8;4
WireConnection;4;0;16;0
WireConnection;4;1;6;0
WireConnection;4;2;2;1
WireConnection;10;0;3;0
WireConnection;10;1;7;0
WireConnection;10;2;2;4
WireConnection;13;0;1;0
WireConnection;13;1;8;0
WireConnection;13;2;2;4
WireConnection;0;0;13;0
WireConnection;0;1;10;0
WireConnection;0;3;2;1
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=FB38330DD1808297E2ABF5CE61998ED56FD1AC0D