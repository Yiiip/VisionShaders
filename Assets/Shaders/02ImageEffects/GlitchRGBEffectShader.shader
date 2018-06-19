Shader "ImageEffectShaders/GlitchRGBEffectShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_GlitchX("Glitch X", Range(-1.0, 1.0)) = 0.0
		_GlitchY("Glitch Y", Range(-1.0, 1.0)) = 0.0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Tags
		{
			"Queue" = "Overlay"
		}

		Pass
		{
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			uniform sampler2D _MainTex;
			uniform float _GlitchX;
			uniform float _GlitchY;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed2 glitch = fixed2(_GlitchX, _GlitchY) / 50;

				fixed4 mainTexColor = tex2D(_MainTex, i.uv);
				fixed4 mainTexColorGlitchX = tex2D(_MainTex, i.uv + glitch);
				fixed4 mainTexColorGlitchY = tex2D(_MainTex, i.uv - glitch);

				return fixed4(mainTexColorGlitchX.r, mainTexColor.g, mainTexColorGlitchY.b, mainTexColor.a);
			}
			ENDCG
		}
	}
}
