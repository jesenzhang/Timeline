// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Scene/YSF_metalHW_shader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_YSF_MetalHW_N("YSF_MetalHW_N", 2D) = "bump" {}
		_YSF_MetalHW_R("YSF_MetalHW_R", 2D) = "white" {}
		_YSF_MetalHW_D("YSF_MetalHW_D", 2D) = "white" {}
		_metal_color("metal_color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _YSF_MetalHW_N;
		uniform float4 _YSF_MetalHW_N_ST;
		uniform sampler2D _YSF_MetalHW_D;
		uniform float4 _YSF_MetalHW_D_ST;
		uniform float4 _metal_color;
		uniform sampler2D _YSF_MetalHW_R;
		uniform float4 _YSF_MetalHW_R_ST;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_YSF_MetalHW_N = i.uv_texcoord * _YSF_MetalHW_N_ST.xy + _YSF_MetalHW_N_ST.zw;
			o.Normal = UnpackNormal( tex2D( _YSF_MetalHW_N, uv_YSF_MetalHW_N ) );
			float2 uv_YSF_MetalHW_D = i.uv_texcoord * _YSF_MetalHW_D_ST.xy + _YSF_MetalHW_D_ST.zw;
			float4 tex2DNode3 = tex2D( _YSF_MetalHW_D, uv_YSF_MetalHW_D );
			o.Albedo = ( tex2DNode3 * _metal_color ).rgb;
			float2 uv_YSF_MetalHW_R = i.uv_texcoord * _YSF_MetalHW_R_ST.xy + _YSF_MetalHW_R_ST.zw;
			float4 tex2DNode2 = tex2D( _YSF_MetalHW_R, uv_YSF_MetalHW_R );
			o.Metallic = tex2DNode2.r;
			o.Smoothness = tex2DNode2.a;
			o.Alpha = 1;
			clip( tex2DNode3.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14101
1927;29;1906;1004;1234;191;1;True;True
Node;AmplifyShaderEditor.SamplerNode;3;-598,-377;Float;True;Property;_YSF_MetalHW_D;YSF_MetalHW_D;3;0;Create;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-590,-196;Float;False;Property;_metal_color;metal_color;4;0;Create;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-804,44;Float;True;Property;_YSF_MetalHW_R;YSF_MetalHW_R;2;0;Create;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-210,-175;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-502,434;Float;True;Property;_YSF_MetalHW_N;YSF_MetalHW_N;1;0;Create;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;YSF_metalHW_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.5;True;True;0;True;TransparentCutout;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;6;0
WireConnection;0;0;4;0
WireConnection;0;1;1;0
WireConnection;0;3;2;0
WireConnection;0;4;2;4
WireConnection;0;10;3;4
ASEEND*/
//CHKSM=6A44705DA388E5345C0F9D2F5785990EAA12A458