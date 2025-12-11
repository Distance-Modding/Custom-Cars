Shader "Custom/StandardEmissionPulse"
{
    Properties
    {
        _Color ("Albedo Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionIntensity ("Emission Intensity", Range(0,5)) = 1.0

        _PulseSpeed ("Pulse Speed", Range(0.1, 10)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        fixed4 _Color;
        fixed4 _EmissionColor;
        float _EmissionIntensity;
        float _PulseSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            // === PULSING EMISSION ===
            // Sine wave 0 → 1
            float emissionPulse = (sin(_Time.y * _PulseSpeed) * 0.5 + 0.5);

            // Final emission
            o.Emission = _EmissionColor.rgb * _EmissionIntensity * emissionPulse;
        }
        ENDCG
    }

    FallBack "Standard"
}
