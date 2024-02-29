// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PersonLoader2"
{
	Properties
	{
		_DisplaceAmount("DisplaceAmount", Float) = 0
		_Random("Random", Float) = 50
		_positionOffset("positionOffset", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "UnityStandardBRDF.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
			};

			uniform float _Random;
			uniform float _DisplaceAmount;
			uniform samplerCUBE _SkyTexture;
			uniform float _positionOffset;
			inline float Dither4x4Bayer( int x, int y )
			{
				const float dither[ 16 ] = {
			 1,  9,  3, 11,
			13,  5, 15,  7,
			 4, 12,  2, 10,
			16,  8, 14,  6 };
				int r = y * 4 + x;
				return dither[r] / 16; // same # of instructions as pre-dividing due to compiler magic
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime128 = _Time.y * 7.0;
				float lerpResult140 = lerp( _DisplaceAmount , ( _DisplaceAmount * 1.3 ) , 0.0);
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord.xyz = ase_worldNormal;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord1.xyz = ase_worldPos;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( ( ( sin( ( ( v.vertex.xyz * _Random ) + mulTime128 ) ) * lerpResult140 ) + float3( 0,0,0 ) ) + float3( 0,0,0 ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float3 ase_worldNormal = i.ase_texcoord.xyz;
				float3 ase_worldPos = i.ase_texcoord1.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldReflection = reflect(-ase_worldViewDir, ase_worldNormal);
				float clampResult111 = clamp( ( _positionOffset + i.ase_texcoord2.xyz.y ) , 0.0 , 1.0 );
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				ase_worldViewDir = Unity_SafeNormalize( ase_worldViewDir );
				float dotResult96 = dot( normalizedWorldNormal , ase_worldViewDir );
				float clampResult110 = clamp( pow( ( 1.0 - dotResult96 ) , 2.0 ) , 0.0 , 1.0 );
				float4 screenPos = i.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 clipScreen165 = ase_screenPosNorm.xy * _ScreenParams.xy;
				float dither165 = Dither4x4Bayer( fmod(clipScreen165.x, 4), fmod(clipScreen165.y, 4) );
				clip( ( dither165 + -0.4 ) - 0.01);
				
				
				finalColor = ( ( texCUBE( _SkyTexture, ase_worldReflection ) * ( clampResult111 * clampResult110 ) ) * 1.2 );
				return finalColor;
			}
			ENDCG
		}
	}
}
/*ASEBEGIN
Version=17700
850;855;2572;1180;-732.2667;903.6687;1;True;True
Node;AmplifyShaderEditor.WorldNormalVector;93;588.5614,-442.4998;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;94;609.9865,-276.86;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;96;827.309,-419.3469;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;100;-90.33237,-373.4867;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;98;665.3357,-660.1883;Inherit;False;Property;_positionOffset;positionOffset;2;0;Create;True;0;0;False;0;0;0.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;101;945.9886,-418.956;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;664.4427,241.9993;Inherit;True;Property;_Random;Random;1;0;Create;True;0;0;False;0;50;500;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;1068.641,235.3075;Inherit;False;Constant;_Float6;Float 6;7;0;Create;True;0;0;False;0;7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;1091.782,-417.8062;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;867.9475,-655.3148;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;838.4201,173.9075;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;128;1208.385,238.0777;Inherit;False;1;0;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;1233.474,332.5757;Inherit;False;Property;_DisplaceAmount;DisplaceAmount;0;0;Create;True;0;0;False;0;0;-0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldReflectionVector;108;796.7795,-961.8501;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;110;1234.641,-418.343;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;109;787.9135,-1194.01;Inherit;True;Global;_SkyTexture;_SkyTexture;3;0;Create;True;0;0;False;0;None;None;False;white;LockedToCube;Cube;-1;0;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.ClampOpNode;111;1146.335,-654.6987;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;1446.104,175.2364;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;172;1434.301,536.402;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1435.47,437.5748;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;1411.313,-528.8845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;113;1245.912,-984.8105;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;139;1600.544,175.1977;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;140;1630.87,408.3748;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;1952.742,13.91086;Inherit;False;Constant;_Float8;Float 8;4;0;Create;True;0;0;False;0;-0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;1679.138,-803.1416;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;116;2045.547,-382.2693;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DitheringNode;165;1939.126,-76.27384;Inherit;False;0;False;3;0;FLOAT;0;False;1;SAMPLER2D;;False;2;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;1754.589,176.2021;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0.1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;1909.425,176.0552;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;162;2143.12,-37.43343;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;2225.196,-400.1575;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClipNode;149;2390.452,-278.4382;Inherit;False;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0.01;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;2051.896,175.2976;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;2652.001,-146.0413;Float;False;True;-1;2;ASEMaterialInspector;100;1;PersonLoader2;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;96;0;93;0
WireConnection;96;1;94;0
WireConnection;101;0;96;0
WireConnection;105;0;101;0
WireConnection;104;0;98;0
WireConnection;104;1;100;2
WireConnection;127;0;100;0
WireConnection;127;1;123;0
WireConnection;128;0;171;0
WireConnection;110;0;105;0
WireConnection;111;0;104;0
WireConnection;132;0;127;0
WireConnection;132;1;128;0
WireConnection;133;0;126;0
WireConnection;114;0;111;0
WireConnection;114;1;110;0
WireConnection;113;0;109;0
WireConnection;113;1;108;0
WireConnection;139;0;132;0
WireConnection;140;0;126;0
WireConnection;140;1;133;0
WireConnection;140;2;172;0
WireConnection;115;0;113;0
WireConnection;115;1;114;0
WireConnection;145;0;139;0
WireConnection;145;1;140;0
WireConnection;146;0;145;0
WireConnection;162;0;165;0
WireConnection;162;1;173;0
WireConnection;119;0;115;0
WireConnection;119;1;116;0
WireConnection;149;0;119;0
WireConnection;149;1;162;0
WireConnection;152;0;146;0
WireConnection;15;0;149;0
WireConnection;15;1;152;0
ASEEND*/
//CHKSM=B7AD6A5985F22939FE23F910EA4CD32C533DB5C7