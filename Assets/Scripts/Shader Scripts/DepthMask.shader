Shader "Custom/Mask" {
	SubShader{
		Tags{ "RenderType" = "Transparent" "Queue" = "Geometry+1"}

		ColorMask 0
		ZWrite On
		ZTest LEqual
		Lighting Off
		Pass{
		}
	}
}
