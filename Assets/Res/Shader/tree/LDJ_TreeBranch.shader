// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LDJ/Foliage/Tree Branch"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
		_VariationColor("Variation Color", Color) = (1,0.5,0,0.184)
		_TransmissionColor("Transmission Color", Color) = (1,1,1,0)
		_AmbientOcclusion("AmbientOcclusion", Range( 0 , 1)) = 0
		_WindWeight("WindWeight", Range( 0 , 10)) = 0.1164738
		_FlatLighting("FlatLighting", Range( 0 , 1)) = 0
		_WindAmplitudeMultiplier("WindAmplitudeMultiplier", Float) = 1
		_GradientBrightness("GradientBrightness", Range( 0 , 2)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		LOD 200
		Cull Off
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma multi_compile _ LOD_FADE_CROSSFADE
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 viewDir;
			UNITY_DITHER_CROSSFADE_COORDS
		};

		uniform sampler2D _MainTex;
		uniform float _GradientBrightness;
		uniform float4 _VariationColor;
		uniform sampler2D _WindVectors;
		uniform float _WindAmplitudeMultiplier;
		uniform float _WindSpeed;
		uniform float4 _WindDirection;
		uniform float _WindDebug;
		uniform float4 _TransmissionColor;
		uniform float _Smoothness;
		uniform float _AmbientOcclusion;
		uniform float _WindWeight;
		uniform float _TrunkWindSpeed;
		uniform float _TrunkWindSwinging;
		uniform float _TrunkWindWeight;
		uniform float _FlatLighting;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float2 appendResult249 = (float2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackScaleNormal( tex2Dlod( _WindVectors, float4( ( ( _WindAmplitudeMultiplier * ( (ase_worldPos).xz * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ), 0, 0.0) ) ,1.0 );
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 appendResult250 = (float3(_WindDirection.x , 0.0 , _WindDirection.z));
			float3 _Vector2 = float3(1,1,1);
			float3 appendResult283 = (float3(( ( (float3( 0,0,0 ) + (sin( ( ( temp_output_60_0 * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult250 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector2 - float3( 0,0,0 )) / (_Vector2 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))) * _TrunkWindWeight ) * ( v.color.a * 0.1 ) ).x , 0.0 , ( ( (float3( 0,0,0 ) + (sin( ( ( temp_output_60_0 * ( _TrunkWindSpeed / ase_objectScale ) ) * appendResult250 ) ) - ( float3(-1,-1,-1) + _TrunkWindSwinging )) * (_Vector2 - float3( 0,0,0 )) / (_Vector2 - ( float3(-1,-1,-1) + _TrunkWindSwinging ))) * _TrunkWindWeight ) * ( v.color.a * 0.1 ) ).z));
			float3 Wind17 = ( ( ( WindVectors99 * v.color.a ) * _WindWeight ) + appendResult283 );
			v.vertex.xyz += Wind17;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 lerpResult94 = lerp( ase_vertexNormal , float3(0,1,0) , _FlatLighting);
			v.normal = lerpResult94;
			UNITY_TRANSFER_DITHER_CROSSFADE( o, v.vertex );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			UNITY_APPLY_DITHER_CROSSFADE(i);
			float2 uv_MainTex = i.uv_texcoord;
			float4 tex2DNode19 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult246 = lerp( ( tex2DNode19 * _GradientBrightness ) , tex2DNode19 , i.vertexColor.r);
			float4 transform204 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float4 lerpResult20 = lerp( lerpResult246 , _VariationColor , ( _VariationColor.a * frac( ( ( transform204.x + transform204.y ) + transform204.z ) ) ));
			float4 temp_cast_1 = (1.0).xxxx;
			float4 clampResult55 = clamp( lerpResult20 , float4( 0,0,0,0 ) , temp_cast_1 );
			float4 Color56 = clampResult55;
			float3 ase_worldPos = i.worldPos;
			float temp_output_60_0 = ( ( _WindSpeed * 0.05 ) * _Time.w );
			float2 appendResult249 = (float2(_WindDirection.x , _WindDirection.z));
			float3 WindVectors99 = UnpackScaleNormal( tex2D( _WindVectors, ( ( _WindAmplitudeMultiplier * ( (ase_worldPos).xz * 0.01 ) ) + ( temp_output_60_0 * appendResult249 ) ) ) ,1.0 );
			float4 lerpResult97 = lerp( Color56 , float4( WindVectors99 , 0.0 ) , _WindDebug);
			o.Albedo = lerpResult97.rgb;
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			float3 normalizeResult236 = normalize( ase_worldlightDir );
			float dotResult36 = dot( normalizeResult236 , -i.viewDir );
			float4 SSS45 = ( ( ( (0.0 + (dotResult36 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) * i.vertexColor.a ) * _TransmissionColor.a ) * ( _TransmissionColor * _LightColor0 ) );
			o.Emission = SSS45.rgb;
			o.Smoothness = _Smoothness;
			float lerpResult53 = lerp( 1.0 , 0.0 , ( _AmbientOcclusion * ( 1.0 - i.vertexColor ) ).r);
			float AmbientOcclusion218 = lerpResult53;
			o.Occlusion = AmbientOcclusion218;
			o.Alpha = 1;
			float Alpha31 = tex2DNode19.a;
			float lerpResult101 = lerp( Alpha31 , 1.0 , _WindDebug);
			clip( lerpResult101 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha fullforwardshadows nodirlightmap vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				fixed3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13901
1927;29;1906;1014;4784.501;702.4691;3.137316;True;False
Node;AmplifyShaderEditor.CommentaryNode;238;-4012.096,-2102.378;Float;False;2833.298;786.479;Comment;21;5;106;59;4;210;90;86;60;209;211;89;212;91;104;102;99;10;237;15;16;249;Leaf wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3962.096,-1637.201;Float;False;Global;_WindSpeed;_WindSpeed;7;0;0.3;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;239;-3957.72,-1217.98;Float;False;2848.898;709.3215;Comment;21;283;282;118;143;207;152;206;208;144;170;150;242;154;148;171;250;141;194;87;142;168;Global wind animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3896.235,-1558.978;Float;False;Constant;_Float0;Float 0;10;0;0.05;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;142;-3907.72,-909.7822;Float;False;Global;_TrunkWindSpeed;_TrunkWindSpeed;10;0;10;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.ObjectScaleNode;168;-3848.127,-808.3901;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TimeNode;4;-3662.002,-1517.899;Float;False;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-3583.836,-1630.378;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.Vector4Node;87;-3927.026,-1131.687;Float;False;Global;_WindDirection;_WindDirection;9;0;0,0,0,0;0;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;194;-3632.326,-890.6907;Float;False;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-3799.4,-1921.7;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-3361.596,-1581.601;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SwizzleNode;86;-3541.736,-1924.178;Float;False;FLOAT2;0;2;2;2;1;0;FLOAT3;0,0,0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-3342.022,-1167.98;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT3;0;False;1;FLOAT3
Node;AmplifyShaderEditor.DynamicAppendNode;250;-3580.585,-1104.491;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.CommentaryNode;241;-3107.428,-410.5003;Float;False;1876.535;746.0209;Comment;16;204;23;24;203;83;30;19;31;20;105;55;56;245;246;247;248;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-3539.632,-1806.378;Float;False;Constant;_Float7;Float 7;10;0;0.01;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;211;-3361.632,-2052.378;Float;False;Property;_WindAmplitudeMultiplier;WindAmplitudeMultiplier;9;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-3067.625,-1119.186;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.Vector3Node;154;-3111.927,-969.0889;Float;False;Constant;_Vector1;Vector 1;10;0;-1,-1,-1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;204;-3057.428,133.5205;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;85;-3626.292,489.3988;Float;False;2413.568;596.9805;Subsurface;16;213;36;40;45;214;215;224;225;226;229;231;230;34;33;232;236;Transmission;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;249;-3234.896,-1469.981;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;171;-3197.828,-798.7911;Float;False;Global;_TrunkWindSwinging;_TrunkWindSwinging;10;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-3324.632,-1924.378;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;-3038.632,-1913.378;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2
Node;AmplifyShaderEditor.SinOpNode;150;-2880.324,-1106.686;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.Vector3Node;242;-2888.98,-732.9907;Float;False;Constant;_Vector2;Vector 2;10;0;1,1,1;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;33;-3603.792,532.3994;Float;False;1;0;FLOAT;0.0;False;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-3599.492,682.3988;Float;False;World;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-3041.336,-1595.978;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT2;0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleAddOpNode;170;-2873.828,-908.7911;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2841.293,152.8998;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TFHCRemapNode;152;-2439.225,-1114.487;Float;False;5;0;FLOAT3;0,0,0;False;1;FLOAT3;-1,-1,-1;False;2;FLOAT3;1,1,1;False;3;FLOAT3;0,0,0;False;4;FLOAT3;1,1,1;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;208;-2341.52,-578.0903;Float;False;Constant;_Float6;Float 6;10;0;0.1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-2805.536,-1779.578;Float;False;2;2;0;FLOAT2;0.0,0;False;1;FLOAT2;0.0,0;False;1;FLOAT2
Node;AmplifyShaderEditor.RangedFloatNode;248;-2930.195,-149.8801;Float;False;Property;_GradientBrightness;GradientBrightness;10;0;1;0;2;0;1;FLOAT
Node;AmplifyShaderEditor.NegateNode;230;-3414.235,692.5197;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;104;-2810.238,-1535.177;Float;False;Constant;_Float2;Float 2;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;144;-2294.521,-923.9849;Float;False;Global;_TrunkWindWeight;_TrunkWindWeight;10;0;2;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalizeNode;236;-3336.135,536.0207;Float;False;1;0;FLOAT3;0,0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-2653.295,185.6992;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;206;-2344.621,-756.79;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;19;-2948.296,-350.2004;Float;True;Property;_MainTex;MainTex;1;1;[NoScaleOffset];None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-2049.014,-1089.885;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.FractNode;203;-2489.529,186.6203;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;240;-2700.494,1188.223;Float;False;1461.06;358.5759;Comment;7;47;50;49;51;108;53;218;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-2533.993,-368.9799;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;232;-2936.735,762.0214;Float;False;Constant;_Float4;Float 4;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-2020.518,-674.0903;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;231;-2937.638,656.3201;Float;False;Constant;_Float9;Float 9;11;0;-1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DotProductOpNode;36;-3137.692,548.1992;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;83;-2473.749,-110.3892;Float;False;Property;_VariationColor;Variation Color;2;0;1,0.5,0,0.184;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;102;-2600.441,-1812.178;Float;True;Global;_WindVectors;_WindVectors;8;0;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;245;-3037.995,-52.28011;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;246;-2311.794,-314.0801;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2164.695,78.19921;Float;False;2;2;0;FLOAT;0,0,0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1868.222,-1088.986;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.TFHCRemapNode;229;-2659.534,563.4202;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;-1.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;-2208.141,-1794.979;Float;False;WindVectors;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.VertexColorNode;40;-2663.99,833.5;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;10;-2009.397,-1690.9;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;47;-2650.494,1344.798;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;16;-1695.998,-1576;Float;False;Property;_WindWeight;WindWeight;6;0;0.1164738;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;213;-2398.831,721.1215;Float;False;Property;_TransmissionColor;Transmission Color;4;0;1,1,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-2384.838,567.6202;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;105;-1871.637,54.5219;Float;False;Constant;_Float3;Float 3;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;-1657.037,-1796.478;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;50;-2409.993,1253.799;Float;False;Property;_AmbientOcclusion;AmbientOcclusion;5;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.LightColorNode;214;-2240.732,937.2216;Float;False;0;3;COLOR;FLOAT3;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;100;-420.9563,-190.6743;Float;False;Global;_WindDebug;_WindDebug;10;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;49;-2329.393,1396.799;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.BreakToComponentsNode;282;-1708.497,-1084.519;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;20;-1943.796,-123.3005;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;108;-2002.035,1238.223;Float;False;Constant;_Float5;Float 5;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-2005.338,565.3199;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2069.393,1351.298;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;215;-2015.23,749.321;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.WireNode;272;-155.1518,-497.8887;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;283;-1339.63,-1070.413;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1347.798,-1690.899;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.WireNode;274;-109.1185,81.11133;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;55;-1669.095,-113.7017;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-869.729,-1375.275;Float;False;2;2;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.WireNode;273;-109.7907,-588.0359;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;57;307.7924,-795.8511;Float;False;56;0;1;COLOR
Node;AmplifyShaderEditor.WireNode;271;176.8815,94.11133;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;103;-307.0379,32.42241;Float;False;Constant;_Float1;Float 1;10;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.Vector3Node;93;268.633,384.2144;Float;False;Constant;_Vector0;Vector 0;10;0;0,1,0;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;95;166.6328,552.2144;Float;False;Property;_FlatLighting;FlatLighting;7;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;96;255.633,221.2133;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-1767.439,561.4199;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;53;-1805.494,1291.499;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;98;284.0998,-712.3729;Float;False;99;0;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;32;-328.496,-44.40088;Float;False;31;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1492.097,-262.8007;Float;False;Alpha;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;56;-1473.894,-112.0015;Float;False;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1470.397,559.2985;Float;False;SSS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;94;613.6323,307.2142;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.GetLocalVarNode;46;7.430328,-312.6622;Float;False;45;0;1;COLOR
Node;AmplifyShaderEditor.LerpOp;101;260.1581,-43.74419;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;97;626.5228,-673.5649;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;254;-89.41714,-236.6956;Float;False;Property;_Smoothness;Smoothness;11;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-664.4981,-1381.1;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;62;-88.8763,-500.0306;Float;True;Property;_BumpMap;BumpMap;3;1;[NoScaleOffset];None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;217;-54.78961,-161.1802;Float;False;218;0;1;FLOAT
Node;AmplifyShaderEditor.GetLocalVarNode;18;624.2745,22.64254;Float;False;17;0;1;FLOAT3
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;-1520.435,1371.92;Float;False;AmbientOcclusion;-1;True;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;938.3005,-293.7;Float;False;True;2;Float;ASEMaterialInspector;200;0;Standard;LDJ/Foliage/Tree Branch;False;False;False;False;False;False;False;False;True;False;False;False;True;False;False;False;True;Off;0;0;False;0;0;Custom;0.5;True;True;0;True;Opaque;AlphaTest;All;True;True;True;True;True;True;True;False;True;True;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;20.3;10;25;True;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;200;;0;-1;-1;-1;0;0;0;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;59;0
WireConnection;90;1;106;0
WireConnection;194;0;142;0
WireConnection;194;1;168;0
WireConnection;60;0;90;0
WireConnection;60;1;4;4
WireConnection;86;0;5;0
WireConnection;141;0;60;0
WireConnection;141;1;194;0
WireConnection;250;0;87;1
WireConnection;250;2;87;3
WireConnection;148;0;141;0
WireConnection;148;1;250;0
WireConnection;249;0;87;1
WireConnection;249;1;87;3
WireConnection;209;0;86;0
WireConnection;209;1;210;0
WireConnection;212;0;211;0
WireConnection;212;1;209;0
WireConnection;150;0;148;0
WireConnection;89;0;60;0
WireConnection;89;1;249;0
WireConnection;170;0;154;0
WireConnection;170;1;171;0
WireConnection;23;0;204;1
WireConnection;23;1;204;2
WireConnection;152;0;150;0
WireConnection;152;1;170;0
WireConnection;152;2;242;0
WireConnection;152;4;242;0
WireConnection;91;0;212;0
WireConnection;91;1;89;0
WireConnection;230;0;34;0
WireConnection;236;0;33;0
WireConnection;24;0;23;0
WireConnection;24;1;204;3
WireConnection;143;0;152;0
WireConnection;143;1;144;0
WireConnection;203;0;24;0
WireConnection;247;0;19;0
WireConnection;247;1;248;0
WireConnection;207;0;206;4
WireConnection;207;1;208;0
WireConnection;36;0;236;0
WireConnection;36;1;230;0
WireConnection;102;1;91;0
WireConnection;102;5;104;0
WireConnection;246;0;247;0
WireConnection;246;1;19;0
WireConnection;246;2;245;0
WireConnection;30;0;83;4
WireConnection;30;1;203;0
WireConnection;118;0;143;0
WireConnection;118;1;207;0
WireConnection;229;0;36;0
WireConnection;229;1;231;0
WireConnection;229;2;232;0
WireConnection;229;4;232;0
WireConnection;99;0;102;0
WireConnection;224;0;229;0
WireConnection;224;1;40;4
WireConnection;237;0;99;0
WireConnection;237;1;10;4
WireConnection;49;0;47;0
WireConnection;282;0;118;0
WireConnection;20;0;246;0
WireConnection;20;1;83;0
WireConnection;20;2;30;0
WireConnection;225;0;224;0
WireConnection;225;1;213;4
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;215;0;213;0
WireConnection;215;1;214;0
WireConnection;272;0;100;0
WireConnection;283;0;282;0
WireConnection;283;2;282;2
WireConnection;15;0;237;0
WireConnection;15;1;16;0
WireConnection;274;0;100;0
WireConnection;55;0;20;0
WireConnection;55;2;105;0
WireConnection;123;0;15;0
WireConnection;123;1;283;0
WireConnection;273;0;272;0
WireConnection;271;0;274;0
WireConnection;226;0;225;0
WireConnection;226;1;215;0
WireConnection;53;0;108;0
WireConnection;53;2;51;0
WireConnection;31;0;19;4
WireConnection;56;0;55;0
WireConnection;45;0;226;0
WireConnection;94;0;96;0
WireConnection;94;1;93;0
WireConnection;94;2;95;0
WireConnection;101;0;32;0
WireConnection;101;1;103;0
WireConnection;101;2;271;0
WireConnection;97;0;57;0
WireConnection;97;1;98;0
WireConnection;97;2;273;0
WireConnection;17;0;123;0
WireConnection;218;0;53;0
WireConnection;0;0;97;0
WireConnection;0;2;46;0
WireConnection;0;4;254;0
WireConnection;0;5;217;0
WireConnection;0;10;101;0
WireConnection;0;11;18;0
WireConnection;0;12;94;0
ASEEND*/
//CHKSM=E19304AB0E09B845FD05D2FC17E74B54A7D24EB1