// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Taleweaver/CreatureShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "gray" {}
		[Normal]_BumpMap("BumpMap", 2D) = "bump" {}
		_MetallicGlossMap("MetallicGlossMap", 2D) = "gray" {}
		_PaintNoiseGloss("PaintNoiseGloss", 2D) = "white" {}
		_PaintNoiseBump("PaintNoiseBump", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 4.0
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#pragma exclude_renderers d3d9 gles xbox360 psp2 n3ds wiiu 
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _PaintNoiseBump;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;
		uniform sampler2D _PaintNoiseGloss;


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackNormal( xNorm ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackNormal( yNorm ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackNormal( zNorm ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 _Vector1 = float2(1,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			float3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3x3 objectToTangent = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 triplanar147 = TriplanarSamplingSNF( _PaintNoiseBump, ase_vertex3Pos, ase_vertexNormal, 1.0, _Vector1, 5.0, 0 );
			float3 tanTriplanarNormal147 = mul( objectToTangent, triplanar147 );
			o.Normal = BlendNormals( UnpackScaleNormal( tex2D( _BumpMap, uv_BumpMap ), 1.0 ) , tanTriplanarNormal147 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode6 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = tex2DNode6.r;
			float4 triplanar144 = TriplanarSamplingSF( _PaintNoiseGloss, ase_vertex3Pos, ase_vertexNormal, 1.0, _Vector1, 5.0, 0 );
			float clampResult150 = clamp( ( tex2DNode6.a + ( triplanar144.x - 0.5 ) ) , 0.0 , 0.9 );
			o.Smoothness = clampResult150;
			float clampResult156 = clamp( ( pow( tex2DNode6.g , 3.0 ) * 2.0 ) , 0.0 , 0.9 );
			o.Occlusion = clampResult156;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17700
780;428;2753;1599;219.8882;124.9967;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;141;-872.3919,483.5737;Inherit;False;1523.459;697.9467;Comment;6;146;147;145;144;142;143;Added Paint Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;47.60561,-80.2617;Float;True;Property;_MetallicGlossMap;MetallicGlossMap;3;0;Create;True;0;0;False;0;None;b6de7de437033b64b9b6c9f95d7c5bb5;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;142;-279.3919,757.2363;Inherit;False;Constant;_Vector1;Vector 0;10;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;143;-359.4501,957.5944;Inherit;True;Property;_PaintNoiseGloss;PaintNoiseGloss;4;0;Create;False;0;0;False;0;None;7eba2d27831c9ab4bb547fbfbe2a05a1;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TriplanarNode;144;-34.71217,962.3103;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;5;False;3;FLOAT2;2,2;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;153;680.0979,41.9082;Inherit;False;670.2142;209;Comment;3;156;155;154;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;6;262.2275,-80.3075;Inherit;True;Property;_MetalicSampler;MetalicSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;146;435.2194,983.3876;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;104.5136,-200.4332;Float;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;154;730.0979,101.9543;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-114.8511,-272.6517;Float;True;Property;_BumpMap;BumpMap;2;1;[Normal];Create;True;0;0;False;0;None;e603772bf8cd2bf4782408c1171db78a;False;bump;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;145;-391.4582,534.2897;Inherit;True;Property;_PaintNoiseBump;PaintNoiseBump;5;0;Create;False;0;0;False;0;None;b18bf99c32cc1504a9a61f9ba551bf1b;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;868.0145,347.414;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;36.9091,-471.4617;Float;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;None;69539ef8e510eb44da95919b06288bb7;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;4;259.2415,-273.3723;Inherit;True;Property;_NormalSampler;NormalSampler;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;147;97.06181,638.6528;Inherit;True;Spherical;Object;True;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;5;False;3;FLOAT2;2,2;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;939.9532,107.2668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;148;812.2665,-217.0468;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;156;1179.312,91.90826;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;150;1002.179,346.3021;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;257.6065,-471.262;Inherit;True;Property;_MainSampler;MainSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1491.236,-97.27568;Float;False;True;-1;4;ASEMaterialInspector;0;0;Standard;Taleweaver/CreatureShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;8;d3d11_9x;d3d11;glcore;gles3;metal;vulkan;xboxone;ps4;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;144;0;143;0
WireConnection;144;3;142;0
WireConnection;6;0;5;0
WireConnection;146;0;144;1
WireConnection;154;0;6;2
WireConnection;149;0;6;4
WireConnection;149;1;146;0
WireConnection;4;0;3;0
WireConnection;4;5;64;0
WireConnection;147;0;145;0
WireConnection;147;3;142;0
WireConnection;155;0;154;0
WireConnection;148;0;4;0
WireConnection;148;1;147;0
WireConnection;156;0;155;0
WireConnection;150;0;149;0
WireConnection;2;0;1;0
WireConnection;0;0;2;0
WireConnection;0;1;148;0
WireConnection;0;3;6;1
WireConnection;0;4;150;0
WireConnection;0;5;156;0
ASEEND*/
//CHKSM=64C337A42218FF47F0EB3FA8B8DFE5F74652C630