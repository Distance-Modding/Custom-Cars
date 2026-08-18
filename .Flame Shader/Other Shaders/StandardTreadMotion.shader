Shader "Custom/StandardTreadMotion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB) Alpha (A)", 2D) = "white" {}

        _NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalStrength ("Normal Strength", Range(0,2)) = 1.0

        _HeightMap ("Height Map", 2D) = "black" {}
        _HeightStrength ("Height Strength", Range(0,0.1)) = 0.02

        _TreadSpeed ("Tread Speed", Float) = 1.0
        _TreadDirection ("Tread Direction", Float) = 1.0

        _UScale ("U Scale", Float) = 1.0
        _VScale ("V Scale", Float) = 1.0

        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5

        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "RenderType"="TransparentCutout"
        }

        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows alphatest:_Cutoff

        sampler2D _MainTex;
        sampler2D _NormalMap;
        sampler2D _HeightMap;

        fixed4 _Color;

        half _Metallic;
        half _Glossiness;

        float _NormalStrength;
        float _HeightStrength;

        float _TreadSpeed;
        float _TreadDirection;

        float _UScale;
        float _VScale;

        struct Input
        {
            float2 uv_MainTex;

            /*
             * Tangent-space view direction.
             *
             * Used by the height/parallax mapping.
             */
            float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            /*
             * Start with the ORIGINAL UV coordinates
             * from the tread mesh.
             */
            float2 uv = IN.uv_MainTex;

            /*
             * Optional UV scaling.
             */
            uv.x *= _UScale;
            uv.y *= _VScale;

            /*
             * Get the tank's world-space position.
             */
            float3 objectPosition = float3(
                unity_ObjectToWorld._m03,
                unity_ObjectToWorld._m13,
                unity_ObjectToWorld._m23
            );

            /*
             * Get the tank's forward direction.
             *
             * Unity local +Z is forward.
             */
            float3 forward =
                normalize(
                    mul(
                        (float3x3)unity_ObjectToWorld,
                        float3(0,0,1)
                    )
                );

            /*
             * Determine the tank's position along
             * its forward axis.
             */
            float movementPosition =
                dot(objectPosition, forward);

            /*
             * Convert movement into a texture offset.
             *
             * Negative makes the tread appear to travel
             * underneath the tank when moving forward.
             */
            float treadOffset =
                -movementPosition *
                _TreadSpeed *
                _TreadDirection;

            /*
             * Move the tread texture without changing
             * the original UV layout.
             */
            uv.x += treadOffset;


            // =========================================================
            // HEIGHT / PARALLAX
            // =========================================================

            /*
             * Sample the height map.
             *
             * The height map is expected to be:
             *
             * Black = low
             * White = high
             */
            float height = tex2D(_HeightMap, uv).r;

            /*
             * Convert the height into a signed offset.
             *
             * Centering around 0 means the height map can
             * push the apparent surface both toward and
             * away from the camera.
             */
            float heightOffset =
                (height - 0.5) * _HeightStrength;

            /*
             * IN.viewDir is already in tangent space.
             *
             * Avoid division by extremely small Z values.
             */
            float viewZ = max(abs(IN.viewDir.z), 0.001);

            /*
             * Calculate a simple parallax offset.
             *
             * This changes where the texture is sampled,
             * rather than physically moving the tread mesh.
             */
            float2 parallaxOffset =
                (IN.viewDir.xy / viewZ) * heightOffset;

            /*
             * Apply height-map offset to the texture UV.
             */
            float2 finalUV = uv + parallaxOffset;


            // =========================================================
            // ALBEDO
            // =========================================================

            fixed4 c =
                tex2D(_MainTex, finalUV) *
                _Color;


            // =========================================================
            // NORMAL MAP
            // =========================================================

            /*
             * Sample the normal map.
             *
             * UnpackNormal converts Unity's normal-map
             * encoding into a tangent-space normal.
             */
            fixed3 normal =
                UnpackNormal(tex2D(_NormalMap, finalUV));

            /*
             * Adjust normal strength.
             *
             * Reconstructing Z after scaling XY keeps
             * the normal reasonably normalized.
             */
            normal.xy *= _NormalStrength;

            normal.z =
                sqrt(
                    saturate(
                        1.0 -
                        dot(normal.xy, normal.xy)
                    )
                );

            o.Normal = normal;


            // =========================================================
            // STANDARD MATERIAL
            // =========================================================

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Transparent/Cutout/VertexLit"
}
