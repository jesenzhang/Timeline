Shader "Dissolve/Dissolve_Normal" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_Amount ("Amount", Range (0, 1)) = 0.5
	_StartAmount("StartAmount", float) = 0.1
	_Illuminate ("Illuminate", Range (0, 1)) = 0.5
	_Tile("Tile", float) = 1
	_DissColor ("DissColor", Color) = (1,1,1,1)
	_ColorAnimate ("ColorAnimate", vector) = (1,1,1,1)
	_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	_DissolveSrc ("DissolveSrc", 2D) = "white" {}

}
SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	cull off
	
	
CGPROGRAM
#pragma target 3.0
#pragma surface surf Lambert addshadow



sampler2D _MainTex;
sampler2D _DissolveSrc;

fixed4 _Color;
half4 _DissColor;
half _Amount;
static half3 Color = float3(1,1,1);
half4 _ColorAnimate;
half _Illuminate;
half _Tile;
half _StartAmount;



struct Input {
	float2 uv_MainTex;
	float2 uvDissolveSrc;
};

void vert (inout appdata_full v, out Input o) {}

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = tex.rgb * _Color.rgb;
	
	float ClipTex = tex2D (_DissolveSrc, IN.uv_MainTex/_Tile).r ;
	float ClipAmount = ClipTex - _Amount;
	float Clip = 0;
if (_Amount > 0)
{
	if (ClipAmount <0)
	{
		Clip = 1; //clip(-0.1);
	
	}
	 else
	 {
	
		if (ClipAmount < _StartAmount)
		{
			if (_ColorAnimate.x == 0)
				Color.x = _DissColor.x;
			else
				Color.x = ClipAmount/_StartAmount;
          
			if (_ColorAnimate.y == 0)
				Color.y = _DissColor.y;
			else
				Color.y = ClipAmount/_StartAmount;
          
			if (_ColorAnimate.z == 0)
				Color.z = _DissColor.z;
			else
				Color.z = ClipAmount/_StartAmount;

			o.Albedo  = (o.Albedo *((Color.x+Color.y+Color.z))* Color*((Color.x+Color.y+Color.z)))/(1 - _Illuminate);
		
		}
	 }
 }

 
if (Clip == 1)
{
clip(-0.1);
}

   
	//////////////////////////////////
	//
	o.Gloss = tex.a;
	o.Alpha = tex.a * _Color.a;
	
}
ENDCG
}

FallBack "Specular"
}
