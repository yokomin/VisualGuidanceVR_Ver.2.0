// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "UI/Gaussian"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _SamplingDistance ("Sampling Distance", float) = 1.0
    }

    Category
    {
        SubShader
        {
            Tags
            {
                "Queue"="Transparent"
                "IgnoreProjector"="True"
                "RenderType"="Opaque"
            }

            Stencil {
                Ref 1 // リファレンス値
                Comp Greater // ピクセルのリファレンス値がバッファの値より大きい場合のみレンダリングします。
            }

            Cull Off

            GrabPass {}

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
                
                struct appdata_t
                {
                    half4 vertex : POSITION;
                    half2 uv : TEXCOORD0;
                    half4 color : COLOR;
                };

                struct v2f
                {
                    half2 coordV : TEXCOORD0;
                    half2 coordH : TEXCOORD1;
                    float4 vertex : SV_POSITION;
                    half2 offsetV: TEXCOORD2;
                    half2 offsetH: TEXCOORD3;
                    half4 uvgrab : TEXCOORD4;
                    half4 color : COLOR;
                };

                sampler2D _GrabTexture;
                float4 _GrabTexture_ST;
                half4 _GrabTexture_TexelSize;
                float _SamplingDistance;
                float waightSum = 0;
                static const float pi = 3.14159265;
                static const int samplingCount = 13;
                static const int sigma = 2;
                static const half weight[samplingCount] = { 0.002, 0.009, 0.027, 0.065, 0.121, 0.176, 0.2, 0.176, 0.121, 0.065, 0.027, 0.009, 0.002 };

                v2f vert(appdata_t v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uvgrab = ComputeGrabScreenPos(o.vertex);
                    o.color = v.color;

                    half2 uv = TRANSFORM_TEX(v.uv, _GrabTexture);

                    // サンプリングポイントのオフセット
                    o.offsetV = _GrabTexture_TexelSize.xy * half2(0.0, 1.0) * _SamplingDistance;
                    o.offsetH = _GrabTexture_TexelSize.xy * half2(1.0, 0.0) * _SamplingDistance;

                    // サンプリング開始ポイントのUV座標
                    o.coordV = o.uvgrab - o.offsetV * ((samplingCount - 1) * 0.5);
                    o.coordH = o.uvgrab - o.offsetH * ((samplingCount - 1) * 0.5);

                    return o;
                }

                half4 blur(v2f i, half w, half kx, half ky)
                {
                    return tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(half4(i.uvgrab.x + _GrabTexture_TexelSize.x * kx * _SamplingDistance * i.color.a, i.uvgrab.y + _GrabTexture_TexelSize.y * ky * _SamplingDistance * i.color.a, i.uvgrab.z, i.uvgrab.w))) * w;
                } 

                half4 frag(v2f i) : SV_Target
                {
                    half4 col = 0;

                    // 垂直方向
                    for (int j = 0; j < samplingCount; j++){
                        col += tex2D(_GrabTexture, i.coordV) * weight[j] * 0.5;

                        i.coordV += i.offsetV;
                    }

                    // 水平方向
                    for (int j = 0; j < samplingCount; j++){
                        col += tex2D(_GrabTexture, i.coordH) * weight[j] * 0.5;
                        
                        i.coordH += i.offsetH;
                    }

                    return col;
                }
                ENDCG
            }

        }
    }
}
