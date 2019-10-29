// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SamplingDistance ("Sampling Distance", float) = 2.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Stencil
            {
                Ref 1
                Comp NotEqual
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                half2 coordV : TEXCOORD0;
                half2 coordH : TEXCOORD1;
                float4 vertex : SV_POSITION;
                half2 offsetV: TEXCOORD2;
                half2 offsetH: TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _MainTex_TexelSize;
            float _SamplingDistance;
            float waightSum = 0;
            static const float pi = 3.14159265;
            static const int samplingCount = 13;
            static const int sigma = 2;
            static const half weight[samplingCount] = { 0.002, 0.009, 0.027, 0.065, 0.121, 0.176, 0.2, 0.176, 0.121, 0.065, 0.027, 0.009, 0.002 };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                half2 uv = TRANSFORM_TEX(v.uv, _MainTex);

                // サンプリングポイントのオフセット
                o.offsetV = _MainTex_TexelSize.xy * half2(0.0, 1.0) * _SamplingDistance;
                o.offsetH = _MainTex_TexelSize.xy * half2(1.0, 0.0) * _SamplingDistance;

                // サンプリング開始ポイントのUV座標
                o.coordV = uv - o.offsetV * ((samplingCount - 1) * 0.5);
                o.coordH = uv - o.offsetH * ((samplingCount - 1) * 0.5);

                return o;
            }
            
            half4 frag (v2f i) : SV_Target
            {
                half4 col = 0;

                // 垂直方向
                for (int j = 0; j < samplingCount; j++){
                    col += tex2D(_MainTex, i.coordV) * weight[j] * 0.5;
                    
                    // offset分だけサンプリングポイントをずらす
                    i.coordV += i.offsetV;
                }

                // 水平方向
                for (int j = 0; j < samplingCount; j++){
                    col += tex2D(_MainTex, i.coordH) * weight[j] * 0.5;
                    i.coordH += i.offsetH;
                }

                return col;
            }
            ENDCG
        }
    }
}