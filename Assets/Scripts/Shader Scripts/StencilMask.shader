Shader "Stencil/Mask"{

	SubShader{
		
		Stencil{
			Ref 1
			Comp Always
			Pass Replace
		}

		Tags{
			"Queue"="Geometry-1"
		}

		ColorMask 0 
		ZWrite Off

		Pass{}
	}

}
