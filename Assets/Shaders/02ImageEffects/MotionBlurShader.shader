Shader "ImageEffectShaders/MotionBlurShader"
{
	Properties
	{
		_MainTex("主纹理 (RGB)", 2D) = "white" {}
		_Value ("Value1", Range(0.0, 1.0)) = 0.0
		_Value2 ("CenterX", Range(0.0, 1.0)) = 0.5
		_Value3 ("CenterY", Range(0.0, 1.0)) = 0.5
		_IterationNumber("迭代次数", Range(1, 100)) = 16 
	}

	SubShader
	{	
		Pass
		{
			ZTest Always

			CGPROGRAM

			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform float _Value;
			uniform float _Value2;
			uniform float _Value3;
			uniform int _IterationNumber;

			struct vertexInput
			{
				float4 vertex : POSITION;//顶点位置
				float4 color : COLOR;//颜色值
				float2 texcoord : TEXCOORD0;//一级纹理坐标
			};

			struct vertexOutput
			{
				half2 texcoord : TEXCOORD0;//一级纹理坐标
				float4 vertex : SV_POSITION;//像素位置
				fixed4 color : COLOR;//颜色值
			};


			vertexOutput vert(vertexInput Input)
			{
				vertexOutput Output;

				Output.vertex = UnityObjectToClipPos(Input.vertex);
				Output.texcoord = Input.texcoord;
				Output.color = Input.color;

				return Output;
			}

			float4 frag(vertexOutput i) : COLOR
			{
				//【1】设置中心坐标
				float2 center = float2(_Value2, _Value3);
				//【2】获取纹理坐标的x，y坐标值
				float2 uv = i.texcoord.xy;
				//【3】纹理坐标按照中心位置进行一个偏移
				uv -= center;
				//【4】初始化一个颜色值
				float4 color = float4(0.0, 0.0, 0.0, 0.0);
				//【5】将Value乘以一个系数
				_Value *= 0.085;
				//【6】设置坐标缩放比例的值
				float scale = 1;

				//【7】进行纹理颜色的迭代
				for (int j = 1; j < _IterationNumber; ++j)
				{
					//将主纹理在不同坐标采样下的颜色值进行迭代累加
					color += tex2D(_MainTex, uv * scale + center);
					//坐标缩放比例依据循环参数的改变而变化
					scale = 1 + (float(j * _Value));
				}

				//【8】将最终的颜色值除以迭代次数，取平均值
				color /= (float)_IterationNumber;

				//【9】返回最终的颜色值
				return  color;
			}

			ENDCG
		}
	}
}
