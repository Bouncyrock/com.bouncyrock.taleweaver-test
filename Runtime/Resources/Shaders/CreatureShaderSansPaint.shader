// Upgrade NOTE: upgraded instancing buffer 'TaleweaverCreatureShaderSansPaint' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Taleweaver/CreatureShaderSansPaint"
{
	Properties
	{
		_GlossMultiply("GlossMultiply", Float) = 1
		_DrawID("DrawID", Float) = 0
		_MainTex("MainTex", 2D) = "gray" {}
		[Normal]_BumpMap("BumpMap", 2D) = "bump" {}
		_MetallicGlossMap("MetallicGlossMap", 2D) = "gray" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
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
		uniform sampler2D _MainTex;
		uniform sampler2D _MetallicGlossMap;
		uniform float _GlossMultiply;

		UNITY_INSTANCING_BUFFER_START(TaleweaverCreatureShaderSansPaint)
			UNITY_DEFINE_INSTANCED_PROP(float4, _BumpMap_ST)
#define _BumpMap_ST_arr TaleweaverCreatureShaderSansPaint
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr TaleweaverCreatureShaderSansPaint
			UNITY_DEFINE_INSTANCED_PROP(float4, _MetallicGlossMap_ST)
#define _MetallicGlossMap_ST_arr TaleweaverCreatureShaderSansPaint
			UNITY_DEFINE_INSTANCED_PROP(float, _DrawID)
#define _DrawID_arr TaleweaverCreatureShaderSansPaint
		UNITY_INSTANCING_BUFFER_END(TaleweaverCreatureShaderSansPaint)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _BumpMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_BumpMap_ST_arr, _BumpMap_ST);
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST_Instance.xy + _BumpMap_ST_Instance.zw;
			o.Normal = UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), 1.0 );
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float _DrawID_Instance = UNITY_ACCESS_INSTANCED_PROP(_DrawID_arr, _DrawID);
			float4 lerpResult136 = lerp( tex2DNode2 , tex2DNode2 , _DrawID_Instance);
			o.Albedo = lerpResult136.rgb;
			float4 _MetallicGlossMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MetallicGlossMap_ST_arr, _MetallicGlossMap_ST);
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST_Instance.xy + _MetallicGlossMap_ST_Instance.zw;
			float4 tex2DNode6 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = tex2DNode6.r;
			o.Smoothness = ( tex2DNode6.a * _GlossMultiply );
			float clampResult141 = clamp( ( pow( tex2DNode6.g , 3.0 ) * 2.0 ) , 0.0 , 1.0 );
			o.Occlusion = clampResult141;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17700
1084;869;2572;1174;1122.705;614.1691;1.3;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;5;-724.9861,63.40166;Float;True;Property;_MetallicGlossMap;MetallicGlossMap;5;0;Create;True;0;0;False;0;None;None;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;6;-335.3634,81.35589;Inherit;True;Property;_MetalicSampler;MetalicSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;138;430.0276,345.5799;Inherit;False;670.2142;209;Comment;3;141;140;139;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;137;687.575,-369.2964;Inherit;False;562.3202;208.3538;This is to keep Line of Sight working;2;135;136;Line Of Sight;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;139;480.0274,405.6259;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-738.6826,-398.7983;Float;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;None;None;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;689.8834,410.9384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;100.1601,313.642;Float;False;Property;_GlossMultiply;GlossMultiply;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;755.9675,-265.4326;Inherit;False;InstancedProperty;_DrawID;DrawID;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-160.0779,-10.76983;Float;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-998.1301,-95.52061;Float;True;Property;_BumpMap;BumpMap;4;1;[Normal];Create;True;0;0;False;0;None;None;True;bump;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;2;-394.9846,-341.5986;Inherit;True;Property;_MainSampler;MainSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-7.349107,-83.709;Inherit;True;Property;_NormalSampler;NormalSampler;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;418.5157,191.3858;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;136;1066.828,-337.9216;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;141;925.3423,395.5799;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1491.236,-97.27568;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Taleweaver/CreatureShaderSansPaint;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;8;d3d11_9x;d3d11;glcore;gles3;metal;vulkan;xboxone;ps4;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;139;0;6;2
WireConnection;140;0;139;0
WireConnection;2;0;1;0
WireConnection;4;0;3;0
WireConnection;4;5;64;0
WireConnection;81;0;6;4
WireConnection;81;1;82;0
WireConnection;136;0;2;0
WireConnection;136;1;2;0
WireConnection;136;2;135;0
WireConnection;141;0;140;0
WireConnection;0;0;136;0
WireConnection;0;1;4;0
WireConnection;0;3;6;1
WireConnection;0;4;81;0
WireConnection;0;5;141;0
ASEEND*/
//CHKSM=A3D19E593B720303AB08784A82F87A5DD7300178