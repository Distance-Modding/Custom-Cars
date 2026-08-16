Shader "Custom/StandardTreadMotion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB) Alpha (A)", 2D) = "white" {}

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

        fixed4 _Color;

        half _Metallic;
        half _Glossiness;

        float _TreadSpeed;
        float _TreadDirection;

        float _UScale;
        float _VScale;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            /*
             * Start with the ORIGINAL UV coordinates
             * from the tread mesh.
             *
             * We do not calculate UVs from world position.
             * This prevents stretching and distortion around
             * the curved sections of the continuous tread.
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

            /*
             * Sample the texture.
             */
            fixed4 c = tex2D(_MainTex, uv) * _Color;

            /*
             * Alpha is handled by:
             *
             * #pragma surface ... alphatest:_Cutoff
             *
             * Pixels below the cutoff are discarded.
             *
             * This prevents the RGB information inside
             * transparent parts of the texture from showing.
             */

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Transparent/Cutout/VertexLit"
}
