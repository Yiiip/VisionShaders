Shader "ImageEffectShaders/ScreenWaterDropEffectShader" {
	Properties
	{
		//主纹理
		_MainTex ("Texture", 2D) = "white" {}
		//屏幕水滴的素材图
		_ScreenWaterDropTex ("Texture", 2D) = "white" {}
		//X坐标上的水滴尺寸
		_SizeX ("SizeX", Range(0.0, 1.0)) = 1.0
		//Y坐标上的水滴尺寸
		_SizeY ("SizeY", Range(0.0, 1.0)) = 1.0
		//水滴的流动速度
		_DropSpeed ("Speed", Range(0.0, 10.0)) = 4.0
		//溶解度
		_Distortion ("_Distortion", Range(0.0, 1.0)) = 0.87
	}

	SubShader
	{
		Pass
		{
			Cull Off
			ZWrite Off
			ZTest Always
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _ScreenWaterDropTex;
			uniform float _DropSpeed;
			uniform float _SizeX;
			uniform float _SizeY;
			uniform float _Distortion;
			uniform float2 _MainTex_TexelSize;
			
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

			fixed4 frag(vertexOutput Input) : COLOR
			{
				//【1】获取顶点的坐标值
				float2 uv = Input.texcoord.xy;

				//【2】解决平台差异的问题。校正方向，若和规定方向相反，则将速度反向并加1
				#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
					_DropSpeed = 1 - _DropSpeed;
				#endif

				//【3】设置三层水流效果，按照一定的规律在水滴纹理上分别进行取样
				float3 rainTex1 = tex2D(_ScreenWaterDropTex, float2(uv.x * 1.15 * _SizeX, (uv.y * _SizeY * 1.10) + _Time.x * _DropSpeed * 0.180)).rgb / _Distortion;
				float3 rainTex2 = tex2D(_ScreenWaterDropTex, float2(uv.x * 1.25 * _SizeX, (uv.y * _SizeY * 1.20) + _Time.x * _DropSpeed * 0.250)).rgb / _Distortion;
				float3 rainTex3 = tex2D(_ScreenWaterDropTex, float2(uv.x * 0.90 * _SizeX, (uv.y * _SizeY * 1.25) + _Time.x * _DropSpeed * 0.150)).rgb / _Distortion;

				//【4】整合三层水流效果的颜色信息，存于finalRainTex中
				float2 finalRainTex = uv.xy - (rainTex1.xy - rainTex2.xy - rainTex3.xy) / 3;

				//【5】按照finalRainTex的坐标信息，在主纹理上进行采样
				float3 finalColor = tex2D(_MainTex, float2(finalRainTex.x, finalRainTex.y)).rgb;

				//【6】返回加上alpha分量的最终颜色值
				return fixed4(finalColor, 1.0);
			}

			ENDCG
		}
	}
}
