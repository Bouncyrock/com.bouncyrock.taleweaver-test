// Upgrade NOTE: upgraded instancing buffer 'TaleweaverBaseShader' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Taleweaver/BaseShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_GlossMultiply("GlossMultiply", Float) = 1
		_NormalScale("NormalScale", Float) = 1
		_MainTex("MainTex", 2D) = "gray" {}
		[Normal]_BumpMap("BumpMap", 2D) = "bump" {}
		_MetallicGlossMap("MetallicGlossMap", 2D) = "gray" {}
		_BasePaintLayer("BasePaintLayer", 2D) = "black" {}
		_baseIndex("_baseIndex", Int) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.0
		#pragma multi_compile_instancing
		#pragma exclude_renderers d3d9 gles xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _BumpMap;
		uniform float _NormalScale;
		uniform sampler2D _BasePaintLayer;
		uniform sampler2D _MainTex;
		uniform sampler2D G_BaseColorPalette;
		uniform sampler2D _MetallicGlossMap;
		uniform float _GlossMultiply;
		uniform float _Cutoff = 0.5;

		UNITY_INSTANCING_BUFFER_START(TaleweaverBaseShader)
			UNITY_DEFINE_INSTANCED_PROP(float4, _BumpMap_ST)
#define _BumpMap_ST_arr TaleweaverBaseShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _BasePaintLayer_ST)
#define _BasePaintLayer_ST_arr TaleweaverBaseShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr TaleweaverBaseShader
			UNITY_DEFINE_INSTANCED_PROP(float4, _MetallicGlossMap_ST)
#define _MetallicGlossMap_ST_arr TaleweaverBaseShader
			UNITY_DEFINE_INSTANCED_PROP(int, _baseIndex)
#define _baseIndex_arr TaleweaverBaseShader
		UNITY_INSTANCING_BUFFER_END(TaleweaverBaseShader)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _BumpMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BumpMap_ST_arr, _BumpMap_ST);
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST_Instance.xy + _BumpMap_ST_Instance.zw;
			float4 _BasePaintLayer_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BasePaintLayer_ST_arr, _BasePaintLayer_ST);
			float2 uv_BasePaintLayer = i.uv_texcoord * _BasePaintLayer_ST_Instance.xy + _BasePaintLayer_ST_Instance.zw;
			int _baseIndex_Instance = UNITY_ACCESS_INSTANCED_PROP(_baseIndex_arr, _baseIndex);
			int clampResult181 = clamp( _baseIndex_Instance , 0 , 1 );
			float4 lerpResult152 = lerp( float4( float3(0.5,0.5,0) , 0.0 ) , tex2D( _BasePaintLayer, uv_BasePaintLayer ) , (float)clampResult181);
			float4 break151 = lerpResult152;
			float3 appendResult155 = (float3(break151.r , break151.g , 1.0));
			float3 temp_cast_2 = (1.0).xxx;
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), _NormalScale ) , ( ( appendResult155 * 2.0 ) - temp_cast_2 ) );
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float2 appendResult188 = (float2(0.5 , ( _baseIndex_Instance / 32.0 )));
			float4 temp_output_183_0 = ( tex2D( G_BaseColorPalette, appendResult188 ) * float4( 0.3113208,0.3113208,0.3113208,0 ) );
			float4 lerpResult170 = lerp( tex2D( _MainTex, uv_MainTex ) , temp_output_183_0 , break151.b);
			o.Albedo = lerpResult170.rgb;
			o.Emission = ( ( temp_output_183_0 * break151.b ) * float4( 0.2641509,0.2641509,0.2641509,0 ) ).rgb;
			float4 _MetallicGlossMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetallicGlossMap_ST_arr, _MetallicGlossMap_ST);
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST_Instance.xy + _MetallicGlossMap_ST_Instance.zw;
			float4 tex2DNode6 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = tex2DNode6.r;
			float temp_output_81_0 = ( tex2DNode6.a * _GlossMultiply );
			float lerpResult175 = lerp( temp_output_81_0 , ( temp_output_81_0 * 1.3 ) , break151.b);
			o.Smoothness = lerpResult175;
			o.Alpha = 1;
			clip( 1.0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17700
520;658;2572;1180;1480.491;1067.104;1.844574;True;True
Node;AmplifyShaderEditor.IntNode;179;-2153.932,-1304.56;Inherit;False;InstancedProperty;_baseIndex;_baseIndex;7;0;Create;True;0;0;False;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-1732.383,-1615.242;Inherit;False;Constant;_Float4;Float 4;12;0;Create;True;0;0;False;0;32;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;153;-1571.518,-1365.916;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;0.5,0.5,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;181;-1754.942,-1277.411;Inherit;False;3;0;INT;0;False;1;INT;0;False;2;INT;1;False;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;150;-1910.343,-919.3757;Inherit;True;Property;_BasePaintLayer;BasePaintLayer;6;0;Create;False;0;0;False;0;-1;None;ab35eb92597625e4393a1e942dea10e0;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;185;-1508.432,-1621.841;Inherit;False;2;0;INT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;189;-1481.383,-1768.242;Inherit;False;Constant;_Float6;Float 6;12;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;-1326.801,-1286.806;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;188;-1258.983,-1628.442;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;151;-1089.792,-1280.788;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexturePropertyNode;5;-854.2803,122.8091;Float;True;Property;_MetallicGlossMap;MetallicGlossMap;5;0;Create;True;0;0;False;0;None;ef3c3eea3d86ec24095e12997f31d832;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1196.125,-968.4213;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;184;-1009.66,-1678.741;Inherit;True;Global;G_BaseColorPalette;G_BaseColorPalette;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;155;-932.9099,-1021.751;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-903.7289,-770.2499;Inherit;False;Constant;_Float1;Float 1;10;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-543.0013,111.2194;Inherit;True;Property;_MetalicSampler;MetalicSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-215.6947,317.8576;Float;False;Property;_GlossMultiply;GlossMultiply;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-351.2347,-0.9308773;Float;False;Property;_NormalScale;NormalScale;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-616.9974,-79.94337;Float;True;Property;_BumpMap;BumpMap;4;1;[Normal];Create;True;0;0;False;0;None;15992c2f6609cb84a81ebb7dc82dc48b;True;bump;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-333.1937,-1223.466;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3113208,0.3113208,0.3113208,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-973.8044,-358.2664;Float;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;None;f487223fd4a36f94988615eab7ef0049;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;3.921889,219.2876;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-656.7289,-929.2499;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-628.5879,-793.7246;Inherit;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;19.00129,504.0477;Inherit;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;False;0;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;286.7576,339.7365;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-137.5278,-78.7149;Inherit;True;Property;_NormalSampler;NormalSampler;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;168;-435.6187,-902.4583;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-80.33755,-893.5624;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-692.8678,-343.2946;Inherit;True;Property;_MainSampler;MainSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;190;1146.183,6.437921;Inherit;False;Constant;_Float3;Float 3;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;123.4709,-449.5933;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.2641509,0.2641509,0.2641509,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;175;489.5883,241.6646;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-1450.592,-624.8704;Inherit;False;Property;_PaintAmount;PaintAmount;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;158;384.7823,-98.6288;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;170;314.4913,-703.9345;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1333.92,-308.9407;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Taleweaver/BaseShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;8;d3d11_9x;d3d11;glcore;gles3;metal;vulkan;xboxone;ps4;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;181;0;179;0
WireConnection;185;0;179;0
WireConnection;185;1;186;0
WireConnection;152;0;153;0
WireConnection;152;1;150;0
WireConnection;152;2;181;0
WireConnection;188;0;189;0
WireConnection;188;1;185;0
WireConnection;151;0;152;0
WireConnection;184;1;188;0
WireConnection;155;0;151;0
WireConnection;155;1;151;1
WireConnection;155;2;156;0
WireConnection;6;0;5;0
WireConnection;183;0;184;0
WireConnection;81;0;6;4
WireConnection;81;1;82;0
WireConnection;165;0;155;0
WireConnection;165;1;166;0
WireConnection;174;0;81;0
WireConnection;174;1;173;0
WireConnection;4;0;3;0
WireConnection;4;5;64;0
WireConnection;168;0;165;0
WireConnection;168;1;167;0
WireConnection;177;0;183;0
WireConnection;177;1;151;2
WireConnection;2;0;1;0
WireConnection;176;0;177;0
WireConnection;175;0;81;0
WireConnection;175;1;174;0
WireConnection;175;2;151;2
WireConnection;158;0;4;0
WireConnection;158;1;168;0
WireConnection;170;0;2;0
WireConnection;170;1;183;0
WireConnection;170;2;151;2
WireConnection;0;0;170;0
WireConnection;0;1;158;0
WireConnection;0;2;176;0
WireConnection;0;3;6;1
WireConnection;0;4;175;0
WireConnection;0;10;190;0
ASEEND*/
//CHKSM=756293A89E5AD6F7A5CB77292F245B9BB6746BD0