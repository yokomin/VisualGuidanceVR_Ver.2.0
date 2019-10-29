// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "UI/Mask"
{

    SubShader
    {
        Tags
        {
            "Queue"= "AlphaTest+110"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
        }

        Stencil {
            Ref 2 // リファレンス値
            Comp Always  // 常にステンシルテストをパスさせます。
            Pass Replace    // リファレンス値をバッファに書き込みます。
        }

        Cull Off
        ColorMask 0
		ZWrite On

        Pass
        {
        }
    }
}
