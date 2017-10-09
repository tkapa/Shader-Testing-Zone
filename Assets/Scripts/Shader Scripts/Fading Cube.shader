Shader "Object Fading/Rect Fading"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "LightMode" = "ForwardBase" }
		LOD 100

		//ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"
			#include "Lighting.cginc"
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				half3 wPos : TEXCOORD2;
				float2 uv : TEXCOORD0;
				SHADOW_COORDS(1) // put shadows data into TEXCOORD1
				fixed3 diff : COLOR0;
				fixed3 ambient : COLOR1;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half3 _CenterPos;
			half _MinXBound;
			half _MaxXBound;
			half _MinYBound;
			half _MaxYBound;
			half _FadeLength;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = v.uv;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				o.diff = nl * _LightColor0.rgb;
				o.ambient = ShadeSH9(half4(worldNormal, 1));
				// compute shadows data
				TRANSFER_SHADOW(o)
					return o;
			}

			half squareAlphaCalc(half3 i) {
				if (_MinXBound < i.x && _MaxXBound > i.x && _MinYBound < i.z && _MaxYBound > i.z)
					return 1;

				half xPos = i.x;
				half yPos = i.z;
				
				if (_MinXBound > xPos)
					xPos -= _MinXBound;
				else if (_MaxXBound < xPos)
					xPos -= _MaxXBound;
				else
					xPos = 1;

				if (_MinYBound > yPos)
					yPos -= _MinYBound;
				else if (_MaxYBound < yPos)
					yPos -= _MaxYBound;
				else
					yPos = 1;
			
				half hypot =sqrt((xPos*xPos)+(yPos*yPos));

				return clamp(1-hypot/_FadeLength, 0,1);
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				fixed3 lighting = i.diff * shadow + i.ambient;
				col.rgb *= lighting;
				col.a = squareAlphaCalc(i.wPos);
				return col;
			}
			ENDCG
		}
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}
