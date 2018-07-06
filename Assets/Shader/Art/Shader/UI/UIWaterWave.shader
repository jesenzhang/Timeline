// create by yaokang@cyou-inc.com
// craete date 2018.6.13
// UITextureË®²¨

Shader "LDJ/UI/UIWaterWave" 
{
    Properties {
        _MainTexture ("MainTexture", 2D) = "white" {}
         _Mask ("Mask", 2D) = "white" {}
        _OffsetTexture ("NoiseTexture", 2D) = "bump" {}
        _Offset ("Intensity", Range(0, 1)) = 0
        _horizontal("HorizontalSpeed",float) = 0
        _vertical("VerticalSpeed",float) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector" = "True"
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        Pass {
			Cull Off
            Lighting Off
            ZWrite Off
            Fog { Mode Off }
            Offset -1, -1
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform float4 _TimeEditor;
            uniform float _horizontal;
            uniform float _vertical;
            uniform sampler2D _MainTexture; 
            uniform half4 _MainTexture_ST;
            uniform sampler2D _Mask; 
            uniform half4 _Mask_ST;
            uniform sampler2D _OffsetTexture;
            uniform half4 _OffsetTexture_ST;
            uniform fixed _Offset;
            uniform fixed _Alpha;
			
            struct appdata 
            {
                float4 vertex : POSITION;
                half2 uv0 : TEXCOORD0;
				fixed4 color : COLOR;
            };
            struct v2f 
            {
                float4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
				half2 uv1 : TEXCOORD1;
				fixed4 color : COLOR;
            };
            v2f vert (appdata v) 
            {
                v2f o = (v2f)0;
                o.uv0 = v.uv0;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.uv1 = v.uv0 + half2(((_Time.g * _horizontal)+1)/2,((_Time.g * _vertical)+1)/2);
				o.color = v.color;
                return o;
            }
            fixed4 frag(v2f i) : COLOR 
            {
                fixed3 _MaskTex = tex2D(_Mask, TRANSFORM_TEX(i.uv0, _Mask));
                fixed3 _OffsetTexture_var = tex2D(_OffsetTexture,TRANSFORM_TEX(i.uv1, _OffsetTexture))*2-1;
                half2 mainTextureUV = (i.uv0+_OffsetTexture_var.rg*_Offset * _MaskTex.r);
                fixed4 _MainTexture_var = tex2D(_MainTexture,TRANSFORM_TEX(mainTextureUV, _MainTexture));
                return _MainTexture_var*i.color;
                
            }
            ENDCG
        }
    }
}
