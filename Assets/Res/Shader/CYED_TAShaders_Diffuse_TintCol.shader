Shader "TAShaders/Diffuse_TintColor" {
Properties {
    _Color ("主色调", Color) = (1,1,1,1)
    _MainTex ("固有色 (RGB)", 2D) = "white" {}
}
SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 600

CGPROGRAM
#pragma surface surf Lambert noforwardadd nodynlightmap

sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float2 uv_MainTex;
};

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
    o.Albedo = c.rgb;
    o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/VertexLit"
}
