﻿// Shader script to colour and light the vertices of mesh representing land
// for COMP30019 Project 01.
// The code used in the application of Phong's illumination model is attributed  
// to Alexandre Mutel (SharpDX), Jeremy Nicholson (UoM), Chris Ewin (UoM) & 
// Alex Zable (UoM).
//
// Written by Brendan Leung & Wenzhen Yue, September 2018.

Shader "Unlit/LandShader"
{
    Properties
    {   
        // Light-related properties.
        _PointLightColor ("Point Light Color", Color) = (0, 0, 0)
        _PointLightPosition ("Point Light Position", Vector) = (0.0, 0.0, 0.0)
        
        // Land surface-related properties.
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _BlendFactor ("Blend Factor", range(0,1)) = 0.7

    }
    SubShader
    {
        
        Tags {"RenderType"="Opaque"}
        
        Pass
        {              
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            // declarations
            uniform float3 _PointLightColor;
            uniform float3 _PointLightPosition;
            uniform sampler2D _MainTex;
            float _BlendFactor;           

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 worldVertex : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };  
          
            v2f vert(appdata v)
            {
                v2f o;
                
                // Transform vertex in world coordinates to camera coordinates.
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                                   
                // Convert vertex position and corresponding normal into world coordinates.
                float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);
                float3 worldNormal = normalize(mul(transpose((float3x3)unity_WorldToObject), v.normal.xyz));
                
                o.worldVertex = worldVertex;
                o.worldNormal = worldNormal;
                
                o.uv = v.uv;
                                
                return o;
            }
            
            fixed4 frag(v2f v) : SV_Target
            {
                // Blend texture and vertex colours.
                v.color = (tex2D(_MainTex, v.uv) * _BlendFactor) + (v.color * (1.0f - _BlendFactor));
                                
                float3 interpolatedNormal = normalize(v.worldNormal);
                                
                // Calculate ambient RGB intensities.
                float Ka = 1;
                float3 amb = v.color.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb * Ka;

                // Calculate diffuse RBG reflections, we save the results of L.N because we will use it again
                // (when calculating the reflected ray in our specular component).
                float fAtt = 1;
                float Kd = 1;
                float3 L = normalize(_PointLightPosition - v.worldVertex.xyz);
                float LdotN = dot(L, v.worldNormal.xyz);
                float3 dif = fAtt * _PointLightColor.rgb * Kd * v.color.rgb * saturate(LdotN);
                
                // Combine Phong's illumination model components - as the land would not be glossy, the 
                // specular component has been disregarded.
                float4 returnColor = (0.0f, 0.0f, 0.0f, 0.0f);
                returnColor.rgb += amb.rgb + dif.rgb;
                returnColor.a = v.color.a;

                return returnColor;
            }
            ENDCG
        }
    }
}
