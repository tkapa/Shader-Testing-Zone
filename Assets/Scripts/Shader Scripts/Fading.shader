// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Object Fading/Radial Fading"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" "LightMode"="ForwardBase"}
		LOD 100

		//ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

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
				float3 wPos : TEXCOORD2;
				float2 uv : TEXCOORD0;
				SHADOW_COORDS(1) // put shadows data into TEXCOORD1
				fixed3 diff : COLOR0;
				fixed3 ambient : COLOR1;
				float4 pos : SV_POSITION;
			};


			sampler2D _MainTex;
			float4 _MainTex_ST;
			float3 _CenterPos;
			half _MinRadius;
			half _MaxRadius;

			v2f vert(appdata v)
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

			float alphaCalc(float3 i) {

				float dist = distance(i.xz, _CenterPos.xz);

				if (dist < _MinRadius)
					return 1;

				return clamp((1 - (dist - _MinRadius) / (_MaxRadius - _MinRadius)), 0, 1);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed shadow = SHADOW_ATTENUATION(i);
				fixed3 lighting = i.diff * shadow + i.ambient;
				col.rgb *= lighting;
				col.a = alphaCalc(i.wPos);
				return col;
			}
			ENDCG
		}
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}
