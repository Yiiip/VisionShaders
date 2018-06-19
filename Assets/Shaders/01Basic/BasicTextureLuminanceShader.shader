Shader "HelloShaders/BasicTextureLuminanceShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TintColor("TintColor", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
		}
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

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
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float4 _TintColor;

			float4 frag (v2f i) : SV_Target
			{
				float4 texColor = tex2D(_MainTex, i.uv);
				float lum = texColor.r * 0.3 + texColor.g * 0.59 + texColor.b * 0.11;
				float4 grayscale = float4(lum, lum, lum, texColor.a);

				return grayscale * _TintColor;
			}
			ENDCG
		}
	}
}
