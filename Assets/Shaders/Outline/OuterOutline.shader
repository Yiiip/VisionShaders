// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Outline/OuterOutline" 
{
	Properties
	{
		_OutlineColor("Outline Color", Color) = (1,0,0,1)
		_OutlineWidth("Outline width", Range(0.0, 0.3)) = 0.1
		_MainTex ("Base (RGB)", 2D) = "white" { }
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}
		//LOD 200

		Pass
		{
			Cull Front
			ZWrite On

			CGPROGRAM
				#include "UnityCG.cginc"
				#pragma vertex vert
				#pragma fragment frag

				half _OutlineWidth;
				fixed4 _OutlineColor;

				struct V2F
				{
					float4 pos : SV_POSITION;
				};

				V2F vert(appdata_base IN)
				{
					V2F o;

					IN.vertex.xyz += IN.normal * _OutlineWidth;
					o.pos = UnityObjectToClipPos(IN.vertex);
					return o;
				}

				fixed4 frag(V2F IN) : COLOR
				{
					return _OutlineColor;
				}
			ENDCG
		}

		Pass
		{
			SetTexture [_MainTex]
            {
                Combine Primary * Texture
            }
		}
	}

	Fallback "Diffuse"
}