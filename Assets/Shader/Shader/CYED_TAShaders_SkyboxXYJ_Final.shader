//2015_07_24//
//CYED_TAShader_SkyboxXYJ By KK/

Shader "TAShaders/SkyboxXYJ" 
{
    Properties 
    {
        _Trans ("透明度" , range(0.0 , 1.0 )) = 1.0
        _MainTex ("天空贴图(RGB)", 2D) = "white" {}
        _SkyCol ("天空颜色" , Color) = (1,1,1,1) 
        _SkyIllumLevel ("天空亮度" , range(0.0 , 2.0 )) = 1.0
              
        _CloudTex ("星云贴图(RGB) 透明(A)", 2D) = "black" {}
        _CloudCol ("星云颜色" , Color) = (1,1,1,1)
        _CloudIllumLevel ("星云亮度", range (0,2.0)) = 1 
        _CloudHeight ("星云高度", range (0,0.5)) = 1     
        _CloudSpeed ("星云位移速度(XY)", Vector) = (0.01,0.03,0,0)
    }

    SubShader 
    {
        Tags { "Queue"="Background" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Lighting Off
        Cull Front
        LOD 400
			
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _CloudTex; 
        sampler2D _MainTex;

        fixed _Trans;
        fixed _SkyIllumLevel;
        fixed _CloudIllumLevel;
        fixed4 _CloudSpeed; 
        fixed _CloudHeight;  

        fixed4 _SkyCol;
        fixed4 _CloudCol;

        struct Input 
        {
            half2 uv_CloudTex;
            half2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {            
            fixed4 MainTex = tex2D(_MainTex, IN.uv_MainTex);

            IN.uv_CloudTex.x += _Time.g * _CloudSpeed.x;
            IN.uv_CloudTex.y += _CloudHeight + _Time.g * _CloudSpeed.y;
                      
            fixed4 CloudTex = tex2D( _CloudTex, IN.uv_CloudTex);
            CloudTex.xyz *= _CloudCol;
            CloudTex.xyz *= CloudTex.a;           
           
            o.Albedo = (CloudTex * _CloudIllumLevel);
            o.Emission = (MainTex.xyz * _SkyIllumLevel * _SkyCol);
            o.Alpha = _Trans;          
        }
    ENDCG    
    }

Fallback "TLStudio/Opaque/UnLit"

}