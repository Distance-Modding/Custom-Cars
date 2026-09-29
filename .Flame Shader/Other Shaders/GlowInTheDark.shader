Shader "Custom/GlowInTheDark"
{
    Properties
    {
        _Color ("Base Color", Color) = (0.851, 0.851, 0.851, 1)
        _EmissionColor ("Emission Color", Color) = (0.745, 0.992, 0.718, 1)
        _EmissionStrength ("Emission Strength", Range(0, 10)) = 1

        _ShadowThreshold ("Shadow Threshold", Range(0, 1)) = 0.99

        // Light intensity at which the shader considers
        // the Directional Light to be "off".
        _LightOffThreshold ("Light Off Threshold", Range(0, 0.1)) = 0.001
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf ShadowGlow fullforwardshadows
        #pragma target 3.0

        fixed4 _Color;
        fixed4 _EmissionColor;

        float _EmissionStrength;
        float _ShadowThreshold;
        float _LightOffThreshold;

        struct Input
        {
            float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
            o.Alpha = _Color.a;
        }

        half4 LightingShadowGlow(
            SurfaceOutput s,
            half3 lightDir,
            half atten)
        {
            half NdotL = saturate(
                dot(s.Normal, lightDir)
            );

            /*
             * _LightColor0 contains the Directional Light's
             * color multiplied by its intensity.
             *
             * When intensity is normal:
             *     lightBrightness > threshold
             *
             * When intensity is 0:
             *     lightBrightness = 0
             */
            half lightBrightness = max(
                max(_LightColor0.r, _LightColor0.g),
                _LightColor0.b
            );

            /*
             * 1 = Directional Light is effectively OFF
             * 0 = Directional Light is ON
             */
            half lightIsOff = 1.0 - step(
                _LightOffThreshold,
                lightBrightness
            );

            /*
             * Normal shadow detection.
             *
             * atten = 1 → lit
             * atten = 0 → shadow
             */
            half shadowAmount = 1.0 - atten;

            half shadowGlow = smoothstep(
                _ShadowThreshold,
                1.0,
                shadowAmount
            );

            /*
             * If the light is OFF:
             *     glow everywhere.
             *
             * If the light is ON:
             *     only glow in shadows.
             */
            half glow = max(
                shadowGlow,
                lightIsOff
            );

            half4 result;

            /*
             * Normal lighting.
             *
             * When light intensity is zero this naturally
             * becomes zero.
             */
            result.rgb =
                s.Albedo *
                _LightColor0.rgb *
                NdotL *
                atten;

            /*
             * Emission.
             */
            result.rgb +=
                _EmissionColor.rgb *
                glow *
                _EmissionStrength;

            result.a = s.Alpha;

            return result;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
