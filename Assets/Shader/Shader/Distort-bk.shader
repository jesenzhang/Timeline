// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Distort-bk" {
 Properties {
  _NoiseTex ("絮乱图", 2D) = "white" {}           // 絮乱图
  _AreaTex ("区域图(Alpha)：白色为显示区域，透明为不显示区域", 2D) = "white" {} // 区域图
  _MoveSpeed  ("絮乱图移动速度", range (0,1.5)) = 1        // 絮乱图移动速度
  _MoveForce  ("絮乱图叠加后移动强度", range (0,0.1)) = 0.1      // 絮乱图叠加强度，多张运动纹理叠加后再相乘的系数
 }

 Category {
  // 【渲染队列】在透明物体前，类型为【透明】
  Tags { "Queue"="Transparent+1" "RenderType"="Transparent" }
  // 最终透明混合 = 贴图RGB*贴图A + 背景RGB*(1-贴图A)
  // 透明混合【源的A值】【1-SrcAlpha】
  Blend SrcAlpha OneMinusSrcAlpha   // 该写法为最常用最真实的透明混合显示，半透明图的正常显示
  // GEuqal 点的alpha值大于等于0.01时渲染
  AlphaTest Greater .01     // 在PS区域图时，不显示的地方透明度为0即可。
  // 关闭剔除，关闭灯光，不记录深度
  Cull Off Lighting Off ZWrite Off
 
  SubShader {
   GrabPass {       
    Name "BASE"//在后续的通道中可以使用给定的名字来引用这个纹理。当你在1个场景中有多个对象使用grab pass 时候，这样做会提高效率。
    Tags { "LightMode" = "Always" }
    }

   Pass {
    Name "BASE"
    Tags { "LightMode" = "Always" }
   
    CGPROGRAM
    #pragma vertex vert
    #pragma fragment frag
    #pragma fragmentoption ARB_precision_hint_fastest
    #include "UnityCG.cginc"

    struct appdata_t {
     float4 vertex : POSITION; // 输入的模型坐标顶点信息
     float2 texcoord: TEXCOORD0; // 输入的模型纹理坐标集
    };

    struct v2f {
     float4 vertex : POSITION; // 输出的顶点信息
     float4 uvgrab : TEXCOORD0; // 输出的纹理做标集0
     float2 uvmain : TEXCOORD1; // 输出的纹理坐标集1
    };

    float _MoveSpeed;  // 声明絮乱图移动速度
    float _MoveForce;  // 声明运动强度
    float4 _NoiseTex_ST; // 絮乱图采样
    float4 _AreaTex_ST;  // 区域图采样

    sampler2D _NoiseTex; // 絮乱图样本对象
    sampler2D _AreaTex;  // 区域图样本对象
    sampler2D _GrabTexture; // 全屏幕纹理的样本对象，由GrabPass赋值

    v2f vert (appdata_t v)
    {
     v2f o;
     // 从模型坐标-世界坐标-视坐标-（视觉平截体乘以投影矩阵并进行透视除法）-剪裁坐标
     o.vertex = UnityObjectToClipPos(v.vertex);
     // 将裁剪坐标中的【顶点信息】进行换算给uvgrab赋值
     #if UNITY_UV_STARTS_AT_TOP  // Direct3D类似平台scale为-1；OpenGL类似平台为1。
     float scale = -1.0;
     #else
     float scale = 1.0;
     #endif
     o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
     o.uvgrab.zw = o.vertex.zw;

     // 区域图纹理：获取输入的纹理坐标集，并且使用_MainTex_ST采样图，支持在视检器调节缩放和偏移值
     o.uvmain = TRANSFORM_TEX(v.texcoord, _AreaTex);
     return o;
    }

    half4 frag( v2f i ) : COLOR
    {
     // 控制【UV的运动】，这样在进行采样时，offsetColor1拿到的颜色也是运动的。
     half4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz * _MoveSpeed);// 将xy与xz交叉位移
     half4 offsetColor2 = tex2D(_NoiseTex, i.uvmain - _Time.yx * _MoveSpeed);// 将xy与yx交叉位移
     // 将【正在移动的絮乱图纹理信息】的rg用于给uvgrab累加，加2个col就会出现2个絮乱图纹理
     i.uvgrab.x += ((offsetColor1.r + offsetColor2.r) - 1) * _MoveForce; // 叠加强度
     i.uvgrab.y += ((offsetColor1.g + offsetColor2.g) - 1) * _MoveForce;

     // 本来只会显示物体背后的屏幕纹理(视觉上该物体透明了)
     // 但是上面给x,y叠加了运动的rg值，所以就形成透明絮乱图运动的效果
     half4 noiseCol = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
     // 屏幕纹理不需要透明，所以设置为1。
     noiseCol.a = 1;
     // 对区域图进行采样。
     half4 areaCol = tex2D(_AreaTex, i.uvmain);
     // 纹理相乘：区域纹理RBG都为1，区域纹理A为O的像素将不会显示
     // 即可达到絮乱图在区域图中才显示的效果。
     return  noiseCol * areaCol;
    }
    ENDCG
   }//end pass 
  }//end subshader

  // 用于老式显卡
  SubShader {
   Blend DstColor Zero
   Pass {
    Name "BASE"
    SetTexture [_MainTex] { combine texture }
   }
  }
 }
}
配合粒子的发射，就可以在刀光上实现热扭曲效果等。
