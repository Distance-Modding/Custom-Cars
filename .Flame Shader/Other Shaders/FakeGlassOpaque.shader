Shader "Custom/FakeGlassOpaque"
{
    Properties
    {
        _Tint ("Glass Tint (RGB)", Color) = (0.6, 0.8, 1.0, 1)

        _TintStrength ("Tint Strength", Range(0,2)) = 1.0
        _Smoothness ("Smoothness", Range(0,1)) = 0.95

        _FresnelPower ("Fresnel Power", Range(1,10)) = 4
        _FresnelStrength ("Fresnel Strength", Range(0,5)) = 2

        _BaseDarkness ("Base Darkness", Range(0,1)) = 0.02
        _Glow ("Glow", Range(0,1)) = 0.08
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        struct Input
        {
            float3 viewDir;
            float3 worldNormal;
            INTERNAL_DATA
        };

        fixed4 _Tint;

        half _Smoothness;
        half _TintStrength;

        half _FresnelPower;
        half _FresnelStrength;

        half _BaseDarkness;
        half _Glow;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 V = normalize(IN.viewDir);
            float3 N = normalize(IN.worldNormal);

            float fresnel =
                pow(
                    1.0 - saturate(dot(V, N)),
                    _FresnelPower
                );

            // Dark diffuse base
            o.Albedo = _Tint.rgb * _BaseDarkness;

            o.Metallic = 0.0;
            o.Smoothness = _Smoothness;
            o.Occlusion = 1.0;

            // Fresnel-driven edge glow
            o.Emission =
                _Tint.rgb *
                (
                    _Glow +
                    fresnel *
                    _TintStrength *
                    _FresnelStrength
                );
        }
        ENDCG
    }

    FallBack "Standard"
}
