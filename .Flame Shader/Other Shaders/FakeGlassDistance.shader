Shader "Custom/Distance/FakeGlassRealistic"
{
    Properties
    {
        _Color ("Primary Glass Tint", Color) = (0.6, 0.8, 1.0, 1)
        _Color2 ("Secondary Tint Layer", Color) = (1,1,1,1)

        _EmitColor ("Glow Color", Color) = (0,0,0)
        _ReflectColor ("Reflection Tint", Color) = (1,1,1)

        _Smoothness ("Smoothness", Range(0,1)) = 0.98
        _Opacity ("Glass Darkness", Range(0,1)) = 0.15

        _FresnelPower ("Fresnel Power", Range(1,10)) = 5
        _FresnelStrength ("Fresnel Strength", Range(0,5)) = 1.5

        _GlowIntensity ("Glow Intensity", Range(0,3)) = 0.2
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

        fixed4 _Color;
        fixed4 _Color2;
        fixed3 _EmitColor;
        fixed3 _ReflectColor;

        half _Smoothness;
        half _Opacity;
        half _FresnelPower;
        half _FresnelStrength;
        half _GlowIntensity;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 V = normalize(IN.viewDir);
            float3 N = normalize(IN.worldNormal);

            float fresnel =
                pow(1.0 - saturate(dot(N, V)), _FresnelPower);

            // BASE TINT (Distance primary/secondary)
            float3 baseTint =
                lerp(_Color.rgb, _Color2.rgb, 0.3);

            o.Albedo = baseTint * _Opacity;

            o.Metallic = 0.0;
            o.Smoothness = _Smoothness;

            // EMISSION (glow + edge light)
            float3 glow = _EmitColor * _GlowIntensity;

            float3 edge = _ReflectColor * fresnel * _FresnelStrength;

            o.Emission = glow + edge;

            o.Occlusion = 1.0;
        }
        ENDCG
    }

    FallBack "Standard"
}
