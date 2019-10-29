﻿Shader "Custom/Mask" {

	SubShader{
		// Render the mask after regular geometry, but before masked geometry and
		// transparent things.

		Tags{ 
			"Queue" = "AlphaTest+110" 
		}

		// Don't draw in the RGBA channels; just the depth buffer

		Stencil
		{
			Ref 1
			Comp Always
			Pass Replace
		}

		ColorMask 0
		ZWrite On

		// Do nothing specific in the pass:

		Pass{}
	}
}
