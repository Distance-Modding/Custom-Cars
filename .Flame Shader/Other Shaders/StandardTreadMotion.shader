Shader "Custom/StandardTreadMotion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}

        _TreadSpeed ("Tread Speed", Float) = 1.0
        _TreadDirection ("Tread Direction", Float) = 1.0

        _UScale ("U Scale", Float) = 1.0
        _VScale ("V Scale", Float) = 1.0

        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

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
            float3 worldPos;
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            /*
             * IMPORTANT:
             *
             * We use the mesh's original UV coordinates.
             * We do NOT generate UVs from each vertex's world position.
             *
             * This prevents the stretching/distortion that happens
             * on the curved sections of a continuous tank track.
             */

            float2 uv = IN.uv_MainTex;

            /*
             * Scale the original UVs.
             *
             * This changes the size of the tread texture without
             * changing the shape of the mesh's UV layout.
             */
            uv.x *= _UScale;
            uv.y *= _VScale;

            /*
             * Calculate the tank's forward direction.
             *
             * Unity's forward direction is local +Z.
             */
            float3 forward =
                normalize(
                    mul(
                        (float3x3)unity_ObjectToWorld,
                        float3(0,0,1)
                    )
                );

            /*
             * Get the tank object's world position.
             *
             * Unlike IN.worldPos, this is the SAME for every vertex.
             *
             * This is the important difference:
             *
             * OLD:
             *     every vertex got a different texture coordinate
             *
             * NEW:
             *     the entire tread gets one uniform texture offset
             */
            float3 objectPosition = float3(
                unity_ObjectToWorld._m03,
                unity_ObjectToWorld._m13,
                unity_ObjectToWorld._m23
            );

            /*
             * Determine where the tank is along its forward axis.
             */
            float movementPosition = dot(objectPosition, forward);

            /*
             * Convert the tank's position into a texture offset.
             *
             * The negative sign makes the tread appear to travel
             * underneath the vehicle when the vehicle moves forward.
             */
            float treadOffset =
                -movementPosition *
                _TreadSpeed *
                _TreadDirection;

            /*
             * Apply the movement to the ORIGINAL UV.
             *
             * frac() keeps the UV inside the 0-1 range while still
             * allowing the texture to repeat.
             */
            uv.x += treadOffset;

            /*
             * Sample the tread texture.
             */
            fixed4 c = tex2D(_MainTex, uv) * _Color;

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }

        ENDCG
    }

    FallBack "Standard"
}
