Shader "StandardFlagEffect_FixedClean"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionStrength ("Emission Strength", Range(0,5)) = 1.0

        _UVStretch ("UV Stretch", Range(-1,5)) = 1.0
        _UVPosition ("UV Position", Range(-10,10)) = 0

        _PullStrength ("Pull Strength", Range(0,2)) = 1.0
        _EdgeSharpness ("Edge Sharpness", Range(0.5,5)) = 2.0

        _Fade ("Fade", Range(0,1)) = 1.0

        _WaveAmount ("Wave Amount", Range(0,1)) = 0.2
        _WaveSpeed ("Wave Speed", Range(0,10)) = 3.0
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        float4 _Color;

        float4 _EmissionColor;
        float _EmissionStrength;

        float _UVStretch;
        float _UVPosition;

        float _PullStrength;
        float _EdgeSharpness;
        float _Fade;

        float _WaveAmount;
        float _WaveSpeed;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 🔥 NEW: kill stretched/broken trail triangles
            float2 dx = ddx(IN.uv_MainTex);
            float2 dy = ddy(IN.uv_MainTex);
            float stretchAmount = max(length(dx), length(dy));

            // threshold tweakable if needed
            if (stretchAmount > 0.5)
            {
                clip(-1);
            }

            float2 uv = IN.uv_MainTex;

            float t = uv.x;

            float stretch = _UVStretch;
            stretch = (abs(stretch) < 0.01) ? 0.01 : stretch;

            uv.x = (uv.x + _UVPosition) / stretch;

            float wave = sin(_Time.y * _WaveSpeed + IN.uv_MainTex.x * 12.0);
            float waveStrength = pow(_WaveAmount, 1.2);

            uv.y += wave * waveStrength * t;

            float2 sampleUV = saturate(uv);

            fixed4 tex = tex2D(_MainTex, sampleUV);

            float pull = pow(1.0 - t, _EdgeSharpness) * _PullStrength;
            float finalFade = pull * _Fade;

            float alpha = tex.a * _Color.a * finalFade;

            clip(alpha - 0.02);

            float3 col = tex.rgb * _Color.rgb * finalFade;

            o.Albedo = col;
            o.Alpha = alpha;

            o.Emission = col * _EmissionColor.rgb * _EmissionStrength * alpha;

            o.Metallic = 0;
            o.Smoothness = 0;
        }
        ENDCG
    }
}
