Shader "Custom/FakeGlassOpaque"
{
    Properties
    {
        _Tint ("Glass Tint (RGB)", Color) = (0.6, 0.8, 1.0, 1)
        _TintStrength ("Tint Strength", Range(0,2)) = 1.0

        _Smoothness ("Smoothness", Range(0,1)) = 1.0

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
        };

        fixed4 _Tint;
        half _Smoothness;
        float _TintStrength;

        float _FresnelPower;
        float _FresnelStrength;
        float _BaseDarkness;
        float _Glow;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 V = normalize(IN.viewDir);
            float3 N = normalize(o.Normal);

            float fresnel =
                pow(1.0 - saturate(dot(V, N)), _FresnelPower);

            float edgeBoost =
                lerp(1.0, 1.0 + _FresnelStrength, fresnel);

            // very dark base (prevents "colored plastic window" look)
            o.Albedo = _Tint.rgb * _BaseDarkness * edgeBoost;

            o.Smoothness = _Smoothness;
            o.Metallic = 0.0;

            // RGB tint shows mainly in reflections/glow, not base color
            o.Emission =
                _Tint.rgb *
                (_Glow + fresnel * _TintStrength);
        }
        ENDCG
    }

    FallBack "Standard"
}
