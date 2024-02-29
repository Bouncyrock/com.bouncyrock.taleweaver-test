// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FringedGroundShader"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "gray" {}
		[Normal]_BumpMap("BumpMap", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float4 appendResult26 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float mulTime13 = _Time.y * 0.03;
			float simplePerlin2D12 = snoise( ( appendResult26 + mulTime13 ).xy*2.0 );
			simplePerlin2D12 = simplePerlin2D12*0.5 + 0.5;
			float temp_output_16_0 = ( distance( ase_worldPos , float3( 0,0,0 ) ) + ( simplePerlin2D12 * 0.17 ) );
			clip( 3.0 - temp_output_16_0);
			float clampResult20 = clamp( ( temp_output_16_0 - ( 3.0 - 0.1 ) ) , 0.0 , 1.0 );
			float4 clampResult18 = clamp( ( tex2D( _MainTex, uv_MainTex ) + pow( clampResult20 , 0.5 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Albedo = clampResult18.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=17700
1233;591;2053;1323;1879.779;555.0886;1;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;11;-1998.833,-62.40278;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1754.133,197.2973;Inherit;False;1;0;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-1717.733,48.17228;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1561.133,109.5972;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;12;-1415.133,104.5972;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1209.133,109.5972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.17;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;10;-1207.133,-62.40279;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1365.063,-255.145;Inherit;False;Constant;_Range;Range;2;0;Create;True;0;0;False;0;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1420.063,-181.1449;Inherit;False;Constant;_FringeThickness;Fringe Thickness;2;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;29;-1196.063,-177.1449;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1037.134,-62.40279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-878.5839,33.53697;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;3.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;5;-1227.928,-492.7872;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;None;False;gray;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ClampOpNode;20;-736.5843,34.43706;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-996.9919,-492.8154;Inherit;True;Property;_MainSampler;MainSampler;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;25;-588.5835,34.83719;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;9;-564.7333,-272.403;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;4;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-256.1603,-134.4873;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-406.1981,76.61145;Float;True;Property;_BumpMap;BumpMap;1;1;[Normal];Create;True;0;0;False;0;None;None;True;bump;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;6;-174.7285,75.8399;Inherit;True;Property;_NormalSampler;NormalSampler;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;18;-108.2449,-117.0881;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;131,-28;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FringedGroundShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;11;1
WireConnection;26;1;11;3
WireConnection;14;0;26;0
WireConnection;14;1;13;0
WireConnection;12;0;14;0
WireConnection;17;0;12;0
WireConnection;10;0;11;0
WireConnection;29;0;27;0
WireConnection;29;1;28;0
WireConnection;16;0;10;0
WireConnection;16;1;17;0
WireConnection;19;0;16;0
WireConnection;19;1;29;0
WireConnection;20;0;19;0
WireConnection;7;0;5;0
WireConnection;25;0;20;0
WireConnection;9;0;7;0
WireConnection;9;1;27;0
WireConnection;9;2;16;0
WireConnection;21;0;9;0
WireConnection;21;1;25;0
WireConnection;6;0;8;0
WireConnection;18;0;21;0
WireConnection;0;0;18;0
WireConnection;0;1;6;0
ASEEND*/
//CHKSM=680C14167D687B2EDD0793F1317714C6EF5E8B6E