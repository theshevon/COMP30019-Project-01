﻿//UNITY_SHADER_NO_UPGRADE

Shader "Unlit/WaterShader"
{
    SubShader
    {

        Tags { "RenderType"="Transparent" }

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct vertIn
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
            };

            struct vertOut
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
            };

            // Implementation of the vertex shader
            // Builds the object
            vertOut vert(vertIn v)
            {
                
                // Displace the original vertex in view space
                float4 displacement = float4(0.0f, sin((2*_Time.y + v.vertex.x)), 0.0f, 0.0f);
                v.vertex += displacement;
                vertOut o;
                o.vertex += v.vertex;
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
                o.color = v.color;
                return o;
            }
            
            // Implementation of the fragment shader
            // Colours in the object
            fixed4 frag(vertOut v) : SV_Target
            {
                return v.color;
            }
            ENDCG
        }
    }
}
