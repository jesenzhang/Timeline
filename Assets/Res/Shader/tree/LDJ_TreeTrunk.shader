// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Foliage/Tree Trunk"
{
	Properties
	{
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		_GradientBrightness("GradientBrightness", Range( 0 , 2)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.1058824
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		LOD 200
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile _ LOD_FADE_CROSSFADE
		#pragma exclude_renderers xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			UNITY_DITHER_CROSSFADE_COORDS
		};

		uniform sampler2D _MainTex;
		uniform float _GradientBrightness;
		uniform float _Smoothness;
		uniform float _WindSpeed;
		uniform float _TrunkWindSpeed;
		uniform float4 _WindDirection;
		uniform float _TrunkWindSwinging;
		uniform fixed _TrunkWindWeight;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 appendResult88 = (float3(_WindDirection.x , 0.0 , _WindDirection.z));
			float3 _Vector1 = float3(1,1,1);
			float3 appendResult93 = (float3((float3( 0,0,0 ) + (sin( ( ( ( ( _WindSpeed * 0.05 ) * _Time.w ) * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult88 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector1 - float3( 0,0,0 )) / (_Vector1 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))).x , 0.0 , (float3( 0,0,0 ) + (sin( ( ( ( ( _WindSpeed * 0.05 ) * _Time.w ) * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult88 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector1 - float3( 0,0,0 )) / (_Vector1 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))).z));
			float3 Wind111 = ( ( appendResult93 * _TrunkWindWeight ) * ( v.color.a * 0.1 ) );
			v.vertex.xyz += Wind111;
			UNITY_TRANSFER_DITHER_CROSSFADE( o, v.vertex );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			UNITY_APPLY_DITHER_CROSSFADE(i);
			float2 uv_MainTex = i.uv_texcoord;
			float4 tex2DNode45 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult85 = lerp( ( tex2DNode45 * _GradientBrightness ) , tex2DNode45 , ( 1.0 - i.vertexColor.a ));
			float4 Albedo115 = lerpResult85;
			o.Albedo = Albedo115.rgb;
			o.Metallic = (float)0;
			o.Smoothness = _Smoothness;
			o.Occlusion = i.vertexColor.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Nature/SpeedTree"
}
/*ASEBEGIN
Version=13901
1950;58;1877;1014;-429.5833;2049.13;2.827678;True;False
Node;AmplifyShaderEditor.CommentaryNode;119;-473.8982,-2238.46;Float;False;3601.922;1223.073;;27;13;14;16;17;19;15;21;62;18;88;23;82;28;27;83;32;84;81;94;78;80;37;93;41;79;44;111;Wind motion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-423.8982,-2188.46;Float;False;Global;_WindSpeed;_WindSpeed;7;0;0.3;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;14;-357.037,-2110.237;Float;False;Constant;_Float3;Float 3;10;0;0.05;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-44.63774,-2181.637;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ObjectScaleNode;17;-44.83769,-1464.938;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;16;-122.4307,-1559.33;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;10;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.TimeNode;15;-122.8037,-2069.158;Float;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;177.6025,-2132.86;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;196.2327,-1562.635;Float;False;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3
Node;AmplifyShaderEditor.Vector4Node;18;-98.73761,-1770.237;Float;False;Global;_WindDirection;_WindDirection;9;0;0,0,0,0;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;417.268,-1851.53;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3
Node;AmplifyShaderEditor.DynamicAppendNode;88;174.4365,-1749.536;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.Vector3Node;82;668.8383,-1648.035;Float;False;Constant;_Vector0;Vector 0;2;0;-1,-1,-1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;677.6683,-1766.735;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;27;587.163,-1464.039;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.Vector3Node;84;881.838,-1469.036;Float;False;Constant;_Vector1;Vector 1;2;0;1,1,1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SinOpNode;32;879.9669,-1794.236;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;83;910.838,-1617.035;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.TFHCRemapNode;81;1284.713,-1768.683;Float;False;5;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;1,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.BreakToComponentsNode;94;1549.968,-1735.767;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;45;710.5229,-583.6145;Float;True;Property;_MainTex;MainTex;0;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;87;693.0071,-332.882;Float;False;Property;_GradientBrightness;GradientBrightness;2;0;1;0;2;0;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;117;1364.636,-260.2025;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;80;2265.996,-1130.388;Float;False;Constant;_Float1;Float 1;2;0;0.1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;78;2248.996,-1349.388;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;37;1837.233,-1367.685;Fixed;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;93;2027.235,-1738.305;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;1412.229,-570.617;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;2515.995,-1219.388;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;2392.929,-1653.667;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.OneMinusNode;118;1585.059,-170.4572;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;85;1792.079,-409.7187;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;2681.317,-1634.999;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;114;2845.253,-371.6863;Float;False;113;0;1;FLOAT3
Node;AmplifyShaderEditor.VertexColorNode;90;2859.868,-186.6569;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;2219.219,-416.456;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.GetLocalVarNode;116;2859.665,-459.6248;Float;False;115;0;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;46;1702.239,71.77939;Float;True;Property;_Normals;Normals;1;1;[NoScaleOffset];None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;2172.658,62.40754;Float;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;2885.024,-1584.535;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;112;2849.923,6.235733;Float;False;111;0;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;1145.77,-377.2452;Fixed;False;Roughness;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;110;2164.944,-209.1704;Float;False;109;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;120;2660.537,-293.9069;Float;False;Property;_Smoothness;Smoothness;3;0;0.1058824;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.IntNode;122;2978.537,-299.9069;Float;False;Constant;_Int0;Int 0;4;0;0;0;1;INT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3159.507,-299.7967;Float;False;True;2;Float;;200;0;Standard;FAE/Tree Trunk;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;False;True;True;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;200;Nature/SpeedTree;-1;-1;-1;-1;0;0;0;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;13;0
WireConnection;19;1;14;0
WireConnection;21;0;19;0
WireConnection;21;1;15;4
WireConnection;62;0;16;0
WireConnection;62;1;17;0
WireConnection;23;0;21;0
WireConnection;23;1;62;0
WireConnection;88;0;18;1
WireConnection;88;2;18;3
WireConnection;28;0;23;0
WireConnection;28;1;88;0
WireConnection;32;0;28;0
WireConnection;83;0;82;0
WireConnection;83;1;27;0
WireConnection;81;0;32;0
WireConnection;81;1;83;0
WireConnection;81;2;84;0
WireConnection;81;4;84;0
WireConnection;94;0;81;0
WireConnection;93;0;94;0
WireConnection;93;2;94;2
WireConnection;86;0;45;0
WireConnection;86;1;87;0
WireConnection;79;0;78;4
WireConnection;79;1;80;0
WireConnection;41;0;93;0
WireConnection;41;1;37;0
WireConnection;118;0;117;4
WireConnection;85;0;86;0
WireConnection;85;1;45;0
WireConnection;85;2;118;0
WireConnection;44;0;41;0
WireConnection;44;1;79;0
WireConnection;115;0;85;0
WireConnection;113;0;46;0
WireConnection;111;0;44;0
WireConnection;109;0;45;4
WireConnection;0;0;116;0
WireConnection;0;3;122;0
WireConnection;0;4;120;0
WireConnection;0;5;90;1
WireConnection;0;11;112;0
ASEEND*/
//CHKSM=A1E3D6F69B6659C8733CC6DE0B160B5691348D33