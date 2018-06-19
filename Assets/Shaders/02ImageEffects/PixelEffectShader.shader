// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ImageEffectShaders/PixelEffectShader" {
	Properties
	{
		//主纹理
		_MainTex("Texture", 2D) = "white" {}
		//封装的变量值
		_Params("PixelNumPerRow (X) Ratio (Y)", Vector) = (80, 1, 1, 1.5)
	}

	SubShader
	{
		Cull Off
		ZWrite Off
		ZTest Always

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;//顶点位置
				float2 uv : TEXCOORD0;//一级纹理坐标
			};

			//顶点着色器输出结构
			struct vertexOutput
			{
				float4 vertex : SV_POSITION;//像素位置
				float2 uv : TEXCOORD0;//一级纹理坐标
			};

			vertexOutput vert(vertexInput   v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			half4 _Params;

			half4 PixelateOperation(sampler2D tex, half2 uv, half scale, half ratio)
			{
				//【1】计算每个像素块的尺寸
				half PixelSize = 1.0 / scale;
				//【2】取整计算每个像素块的坐标值，ceil函数，对输入参数向上取整
				half coordX = PixelSize * ceil(uv.x / PixelSize);
				half coordY = (ratio * PixelSize)* ceil(uv.y / PixelSize / ratio);
				//【3】组合坐标值
				half2 coord = half2(coordX,coordY);
				//【4】返回坐标值
				return half4(tex2D(tex, coord).xyzw);
			}

			fixed4 frag(vertexOutput  Input) : COLOR
			{
				return PixelateOperation(_MainTex, Input.uv, _Params.x, _Params.y);
			}

			ENDCG
		}
	}
}
