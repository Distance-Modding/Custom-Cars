Shader "Custom/StandardTransparentEmission"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color Tint", Color) = (1,1,1,1)
        _Alpha ("Transparency", Range(0,1)) = 1

        // Unlimited saturation input
        _Saturation ("Saturation", Float) = 1

        _EmissionColor ("Emission Color", Color) = (0,0,0)
        _EmissionPower ("Emission Power", Range(0,5)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        // Double-sided for Trail Renderer
        Cull Off      

        // Alpha blending
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        sampler2D _MainTex;
        float4 _Color;
        float _Alpha;

        float _Saturation;

        float3 _EmissionColor;
        float _EmissionPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 tex = tex2D(_MainTex, IN.uv_MainTex);
            float4 col = tex * _Color;

            // ---------- SATURATION ADJUSTMENT (unlimited) ----------
            float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));
            col.rgb = lerp(gray.xxx, col.rgb, _Saturation);

            // Albedo
            o.Albedo = col.rgb;

            // Transparency
            o.Alpha = col.a * _Alpha;

            // Emission
            o.Emission = _EmissionColor * _EmissionPower;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
