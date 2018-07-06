Shader "Custom/TestShader"
{
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}   // Textrue2D 貼圖 (公開)
		_Color("Color", Color) = (1,1,1,1)
			_Scale("Scale", float) = 1      // Shader Scale (float)數值輸入(公開)
			_Speed("Speed", float) = 1      // Shader Speed (float)數值輸入(公開)
			_Frequency("Frequency", float) = 1    // Shader Frequency (float)數值輸入(公開)
	}
	SubShader{
		//Tags{ "RenderType" = "Opaque" }
		LOD 200

			CGPROGRAM
#pragma surface surf Lambert vertex:vert

			sampler2D _MainTex;
		float _Scale, _Speed, _Frequency;
		float _WaveAmplitude1, _WaveAmplitude2, _WaveAmplitude3, _WaveAmplitude4, _WaveAmplitude5, _WaveAmplitude6, _WaveAmplitude7, _WaveAmplitude8;
		float _OffsetX1, OffsetZ1;
		float _OffsetX2, OffsetZ2;
		float _OffsetX3, OffsetZ3;
		float _OffsetX4, OffsetZ4;
		float _OffsetX5, OffsetZ5;
		float _OffsetX6, OffsetZ6;
		float _OffsetX7, OffsetZ7;
		float _OffsetX8, OffsetZ8;
		half4 _Color;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v) {

			half offsetvert = (v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z);

			half value1 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX1) + (v.vertex.z*OffsetZ1));
			half value2 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX2) + (v.vertex.z*OffsetZ2));
			half value3 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX3) + (v.vertex.z*OffsetZ3));
			half value4 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX4) + (v.vertex.z*OffsetZ4));
			half value5 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX5) + (v.vertex.z*OffsetZ5));
			half value6 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX6) + (v.vertex.z*OffsetZ6));
			half value7 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX7) + (v.vertex.z*OffsetZ7));
			half value8 = _Scale*sin(_Time.w*_Speed*_Frequency + offsetvert + (v.vertex.x*_OffsetX8) + (v.vertex.z*OffsetZ8));

			v.vertex.y += value1 * _WaveAmplitude1;
			v.normal.y += value1 * _WaveAmplitude1;

			v.vertex.y += value2 * _WaveAmplitude2;
			v.normal.y += value2 * _WaveAmplitude2;

			v.vertex.y += value3 * _WaveAmplitude3;
			v.normal.y += value3 * _WaveAmplitude3;

			v.vertex.y += value4 * _WaveAmplitude4;
			v.normal.y += value4 * _WaveAmplitude4;

			v.vertex.y += value5 * _WaveAmplitude5;
			v.normal.y += value5 * _WaveAmplitude5;

			v.vertex.y += value6 * _WaveAmplitude6;
			v.normal.y += value6 * _WaveAmplitude6;

			v.vertex.y += value7 * _WaveAmplitude7;
			v.normal.y += value7 * _WaveAmplitude7;

			v.vertex.y += value8 * _WaveAmplitude8;
			v.normal.y += value8 * _WaveAmplitude8;

		}

		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = _Color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
