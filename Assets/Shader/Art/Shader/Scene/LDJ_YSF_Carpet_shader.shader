// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "YSF_carpet_shader"
{
	Properties
	{
		_YSF_Carpet_D("YSF_Carpet_D", 2D) = "white" {}
		_YSF_Carpet_R("YSF_Carpet_R", 2D) = "white" {}
		_YSF_Carpet_N("YSF_Carpet_N", 2D) = "bump" {}
		_metal_smoothness("metal_smoothness", Float) = 0
		_carpet_smoothness_max("carpet_smoothness_max", Float) = 0
		_YSF_DT_N("YSF_DT_N", 2D) = "bump" {}
		_uv_tiling("uv_tiling", Float) = 40
		_YSF_anwen_N("YSF_anwen_N", 2D) = "bump" {}
		_carpet_color("carpet_color", Color) = (1,0,0,0)
		_YSF_anwen_D("YSF_anwen_D", 2D) = "white" {}
		_anwen_power01("anwen_power01", Float) = 0
		_anwen_uv("anwen_uv", Vector) = (1.85,1.25,0,0)
		_anwen_uvoffset("anwen_uvoffset", Vector) = (0.49,0.12,0,0)
		_ditan_sejie("ditan_sejie", Float) = 0
		_anwen_alluv("anwen_alluv", Float) = 1
		_keli_power("keli_power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _YSF_Carpet_N;
		uniform float4 _YSF_Carpet_N_ST;
		uniform float _keli_power;
		uniform sampler2D _YSF_DT_N;
		uniform float _uv_tiling;
		uniform sampler2D _YSF_anwen_N;
		uniform float2 _anwen_uv;
		uniform float _anwen_alluv;
		uniform float2 _anwen_uvoffset;
		uniform sampler2D _YSF_Carpet_R;
		uniform float4 _YSF_Carpet_R_ST;
		uniform sampler2D _YSF_Carpet_D;
		uniform float4 _YSF_Carpet_D_ST;
		uniform float _anwen_power01;
		uniform sampler2D _YSF_anwen_D;
		uniform float4 _carpet_color;
		uniform float _ditan_sejie;
		uniform float _carpet_smoothness_max;
		uniform float _metal_smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_YSF_Carpet_N = i.uv_texcoord * _YSF_Carpet_N_ST.xy + _YSF_Carpet_N_ST.zw;
			float2 temp_cast_0 = (_uv_tiling).xx;
			float2 uv_TexCoord21 = i.uv_texcoord * temp_cast_0 + float2( 0,0 );
			float2 uv_TexCoord26 = i.uv_texcoord * ( _anwen_uv * _anwen_alluv ) + _anwen_uvoffset;
			float2 uv_YSF_Carpet_R = i.uv_texcoord * _YSF_Carpet_R_ST.xy + _YSF_Carpet_R_ST.zw;
			float4 tex2DNode2 = tex2D( _YSF_Carpet_R, uv_YSF_Carpet_R );
			float3 lerpResult10 = lerp( UnpackNormal( tex2D( _YSF_Carpet_N, uv_YSF_Carpet_N ) ) , ( UnpackScaleNormal( tex2D( _YSF_DT_N, uv_TexCoord21 ) ,_keli_power ) + UnpackScaleNormal( tex2D( _YSF_anwen_N, uv_TexCoord26 ) ,1.0 ) ) , tex2DNode2.b);
			o.Normal = lerpResult10;
			float2 uv_YSF_Carpet_D = i.uv_texcoord * _YSF_Carpet_D_ST.xy + _YSF_Carpet_D_ST.zw;
			float4 tex2DNode1 = tex2D( _YSF_Carpet_D, uv_YSF_Carpet_D );
			float4 lerpResult36 = lerp( float4( 0,0,0,0 ) , ( _anwen_power01 * ( float4(1,0,0,0) * tex2D( _YSF_anwen_D, uv_TexCoord26 ) ) ) , tex2DNode2.b);
			float4 lerpResult13 = lerp( tex2DNode1 , ( tex2DNode1 * _carpet_color * _ditan_sejie ) , tex2DNode2.b);
			float4 lerpResult32 = lerp( tex2DNode1 , ( lerpResult36 + lerpResult13 ) , tex2DNode2.b);
			o.Albedo = lerpResult32.rgb;
			float4 lerpResult39 = lerp( float4( 0,0,0,0 ) , tex2DNode2 , tex2DNode2.r);
			o.Metallic = lerpResult39.r;
			float clampResult57 = clamp( _carpet_smoothness_max , -1.0 , 2.0 );
			float lerpResult4 = lerp( clampResult57 , ( _metal_smoothness * tex2DNode2.g ) , tex2DNode2.r);
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
1927;33;1906;1004;2589.005;-518.1456;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;52;-2116.514,949.0161;Float;False;Property;_anwen_alluv;anwen_alluv;16;0;Create;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;45;-2155.419,735.2123;Float;False;Property;_anwen_uv;anwen_uv;12;0;Create;1.85,1.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1762.114,808.3161;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;44;-2121.476,1098.347;Float;False;Property;_anwen_uvoffset;anwen_uvoffset;13;0;Create;0.49,0.12;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1520.024,847.1724;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;-1306.101,-834.324;Float;False;Constant;_anwen_FX;anwen_FX;12;0;Create;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-1497.339,-1085.271;Float;True;Property;_YSF_anwen_D;YSF_anwen_D;10;0;Create;Assets/DITAN/YSF_carpet/YSF_anwen_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-981.3045,-945.2824;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-835.2286,-94.71838;Float;False;Property;_ditan_sejie;ditan_sejie;15;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-941.6002,-577.3;Float;True;Property;_YSF_Carpet_D;YSF_Carpet_D;0;0;Create;Assets/DITAN/YSF_carpet/YSF_Carpet_D.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1090.877,-1236.354;Float;False;Property;_anwen_power01;anwen_power01;11;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1941.164,466.4101;Float;False;Property;_uv_tiling;uv_tiling;6;0;Create;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-918.3165,-304.0691;Float;False;Property;_carpet_color;carpet_color;8;0;Create;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1676.87,490.7717;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1139,113;Float;True;Property;_YSF_Carpet_R;YSF_Carpet_R;1;0;Create;Assets/DITAN/YSF_carpet/YSF_Carpet_R.tga;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-592.7017,-331.4773;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-725.2299,-1061.166;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1212.077,665.5847;Float;False;Property;_keli_power;keli_power;17;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1615.114,1136.316;Float;False;Constant;_anwen_scale;anwen_scale;13;0;Create;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-209.0538,-325.623;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-1184.024,884.1724;Float;True;Property;_YSF_anwen_N;YSF_anwen_N;7;0;Create;Assets/DITAN/YSF_carpet/YSF_anwen_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1003.687,392.6762;Float;False;Property;_carpet_smoothness_max;carpet_smoothness_max;4;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-675.9523,118.6449;Float;False;Property;_metal_smoothness;metal_smoothness;3;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-669.9866,341.5974;Float;False;Constant;_Float3;Float 3;15;0;Create;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-610.9863,458.5974;Float;False;Constant;_Float4;Float 4;15;0;Create;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-16.52938,-783.8566;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;19;-1004.714,545.7007;Float;True;Property;_YSF_DT_N;YSF_DT_N;5;0;Create;Assets/DITAN/YSF_carpet/YSF_DT_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-523.2607,648.8423;Float;False;2;2;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;3;-696.7053,830.9427;Float;True;Property;_YSF_Carpet_N;YSF_Carpet_N;2;0;Create;Assets/DITAN/YSF_carpet/YSF_Carpet_N.tga;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;57;-422.9867,289.5978;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;52.91008,-292.5632;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-383.5307,126.2831;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;-61.61471,97.03221;Float;False;Property;_Color0;Color 0;9;0;Create;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-49.00721,16.29002;Float;False;Property;_power;power;14;0;Create;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;270.6926,1.290013;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;4;90.69478,317.3738;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;39;-73.25449,-107.4966;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;10;-111.8402,578.2785;Float;True;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;32;300.3804,-334.3198;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;575.4034,-118.9251;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;YSF_carpet_shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;45;0
WireConnection;51;1;52;0
WireConnection;26;0;51;0
WireConnection;26;1;44;0
WireConnection;31;1;26;0
WireConnection;38;0;37;0
WireConnection;38;1;31;0
WireConnection;21;0;20;0
WireConnection;22;0;1;0
WireConnection;22;1;23;0
WireConnection;22;2;76;0
WireConnection;74;0;35;0
WireConnection;74;1;38;0
WireConnection;13;0;1;0
WireConnection;13;1;22;0
WireConnection;13;2;2;3
WireConnection;28;1;26;0
WireConnection;28;5;50;0
WireConnection;36;1;74;0
WireConnection;36;2;2;3
WireConnection;19;1;21;0
WireConnection;19;5;83;0
WireConnection;30;0;19;0
WireConnection;30;1;28;0
WireConnection;57;0;15;0
WireConnection;57;1;58;0
WireConnection;57;2;59;0
WireConnection;33;0;36;0
WireConnection;33;1;13;0
WireConnection;6;0;5;0
WireConnection;6;1;2;2
WireConnection;71;0;70;0
WireConnection;71;1;72;0
WireConnection;4;0;57;0
WireConnection;4;1;6;0
WireConnection;4;2;2;1
WireConnection;39;1;2;0
WireConnection;39;2;2;1
WireConnection;10;0;3;0
WireConnection;10;1;30;0
WireConnection;10;2;2;3
WireConnection;32;0;1;0
WireConnection;32;1;33;0
WireConnection;32;2;2;3
WireConnection;0;0;32;0
WireConnection;0;1;10;0
WireConnection;0;3;39;0
WireConnection;0;4;4;0
ASEEND*/
//CHKSM=035114458C818D7EF781B8ACAF41166675E0760F