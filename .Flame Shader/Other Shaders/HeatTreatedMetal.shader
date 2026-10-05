Shader "Custom/HeatTreatedMetal"
{
    Properties
    {
        _MainTex ("Base Metal", 2D) = "white" {}
        _Color ("Base Color", Color) = (0.35, 0.38, 0.42, 1)

        _Metallic ("Metallic", Range(0,1)) = 1
        _Smoothness ("Smoothness", Range(0,1)) = 0.88

        [Header(Heat Discoloration)]
        _Heat ("Heat", Range(0,1)) = 0.65
        _HeatContrast ("Heat Contrast", Range(0.1,5)) = 1.6
        _HeatScale ("Heat Scale", Range(0.1,10)) = 2.0

        [Header(Heat Colors)]
        _Gold ("Straw / Gold", Color) = (1.0, 0.48, 0.04, 1)
        _Purple ("Purple", Color) = (0.38, 0.03, 0.55, 1)
        _Blue ("Hot Blue", Color) = (0.02, 0.18, 1.0, 1)
        _Cyan ("Cyan", Color) = (0.02, 0.8, 1.0, 1)

        [Header(Iridescence)]
        _Iridescence ("Iridescence", Range(0,2)) = 1.0
        _IriPower ("Iridescence Power", Range(0.1,10)) = 2.5
        _IriScale ("Iridescence Scale", Range(0.1,10)) = 3.0

        [Header(Variation)]
        _NoiseTex ("Heat Variation", 2D) = "gray" {}
        _NoiseStrength ("Variation Strength", Range(0,1)) = 0.18
        _NoiseScale ("Variation Scale", Range(0.1,20)) = 5.0

        [Header(Reflection)]
        _ReflectionStrength ("Reflection Strength", Range(0,2)) = 1.0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        LOD 300

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _NoiseTex;

        fixed4 _Color;

        half _Metallic;
        half _Smoothness;

        half _Heat;
        half _HeatContrast;
        half _HeatScale;

        fixed4 _Gold;
        fixed4 _Purple;
        fixed4 _Blue;
        fixed4 _Cyan;

        half _Iridescence;
        half _IriPower;
        half _IriScale;

        half _NoiseStrength;
        half _NoiseScale;

        half _ReflectionStrength;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;

            float3 worldNormal;
            float3 viewDir;
        };

        // ------------------------------------------------------------
        // Simple 3-color / 4-color gradient
        // ------------------------------------------------------------

        fixed3 HeatGradient(float t)
        {
            fixed3 c;

            if (t < 0.33)
            {
                c = lerp(
                    _Gold.rgb,
                    _Purple.rgb,
                    saturate(t / 0.33)
                );
            }
            else if (t < 0.66)
            {
                c = lerp(
                    _Purple.rgb,
                    _Blue.rgb,
                    saturate((t - 0.33) / 0.33)
                );
            }
            else
            {
                c = lerp(
                    _Blue.rgb,
                    _Cyan.rgb,
                    saturate((t - 0.66) / 0.34)
                );
            }

            return c;
        }

        // ------------------------------------------------------------
        // Surface
        // ------------------------------------------------------------

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 baseTex = tex2D(_MainTex, IN.uv_MainTex);

            fixed3 baseColor =
                baseTex.rgb *
                _Color.rgb;

            // Normalize vectors
            float3 N = normalize(IN.worldNormal);
            float3 V = normalize(IN.viewDir);

            // --------------------------------------------------------
            // Fresnel
            // --------------------------------------------------------

            float ndv = saturate(dot(N, V));

            float fresnel =
                pow(
                    1.0 - ndv,
                    _IriPower
                );

            // --------------------------------------------------------
            // Heat positioning
            //
            // Combining Fresnel with a second directional term keeps
            // the effect from looking like a simple edge glow.
            // --------------------------------------------------------

            float heatPosition =
                fresnel * _IriScale;

            heatPosition *= _HeatScale;

            heatPosition +=
                _Heat * 0.75;

            // --------------------------------------------------------
            // Procedural surface variation
            // --------------------------------------------------------

            float2 noiseUV =
                IN.uv_NoiseTex *
                _NoiseScale;

            float noise =
                tex2D(
                    _NoiseTex,
                    noiseUV
                ).r;

            heatPosition +=
                (noise - 0.5) *
                _NoiseStrength;

            // Contrast
            heatPosition =
                saturate(
                    (heatPosition - 0.5) *
                    _HeatContrast +
                    0.5
                );

            // --------------------------------------------------------
            // Heat coloration
            // --------------------------------------------------------

            fixed3 heatColor =
                HeatGradient(heatPosition);

            // --------------------------------------------------------
            // Mix heat coloration with the actual metal
            // --------------------------------------------------------

            float heatAmount =
                saturate(
                    _Heat *
                    (0.35 + fresnel * _Iridescence)
                );

            fixed3 finalColor =
                lerp(
                    baseColor,
                    baseColor * heatColor,
                    heatAmount
                );

            // --------------------------------------------------------
            // Slight additive interference color
            //
            // This helps produce the bright electric blue edge that
            // real heat-treated titanium often develops.
            // --------------------------------------------------------

            fixed3 interference =
                heatColor *
                fresnel *
                _Iridescence *
                0.35;

            finalColor += interference;

            // --------------------------------------------------------
            // Output
            // --------------------------------------------------------

            o.Albedo = finalColor;

            o.Metallic =
                _Metallic;

            o.Smoothness =
                _Smoothness;

            o.Occlusion = 1.0;

            o.Alpha = baseTex.a;
        }

        ENDCG
    }

    FallBack "Standard"
}
