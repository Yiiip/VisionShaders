Shader "HelloShaders/BasicTextureWithAlphaShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "balck" {}
		_TintColor("TintColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_RepeatNum("RepeatNum", Int) = 1 //平铺重复数量，且需要精灵贴图的高级选项"Wrap Mode"设置为"Repeat"才有效果。
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
			// Blend SrcAlpha One
			// Blend SrcAlpha Zero
			// Blend OneMinusSrcAlpha Zero
			// Blend OneMinusSrcAlpha One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0; //左下角uv(0,0)
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
			int _RepeatNum;

			float4 frag (v2f i) : SV_Target
			{
				float4 texColor = tex2D(_MainTex, i.uv * _RepeatNum);
				float4 tint = texColor * _TintColor;
				float4 color = tint;

				float4 coloredUv = texColor * float4(i.uv.x, i.uv.y, 0.0, _TintColor.a);
				// float4 color = tint + coloredUv;
				
				return color;
			}
			ENDCG
		}
	}
	Fallback "VertexLit"
}
