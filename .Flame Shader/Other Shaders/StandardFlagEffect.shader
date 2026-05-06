Shader "StandardFlagEffect_FixedClean_v2"
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

        // ✅ Premultiplied alpha (more stable in Unity 5.x)
        Blend One OneMinusSrcAlpha
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
            float2 uv = IN.uv_MainTex;

            // ✅ Kill broken / stretched triangles
            float2 dx = ddx(uv);
            float2 dy = ddy(uv);
            float stretchAmount = max(length(dx), length(dy));
            if (stretchAmount > 0.5)
            {
                clip(-1);
            }

            float t = uv.x;

            // ✅ Safe stretch (no divide-by-zero, preserves sign)
            float stretch = max(abs(_UVStretch), 0.01) * sign(_UVStretch);
            uv.x = (uv.x + _UVPosition) / stretch;

            // ✅ Wave
            float wave = sin(_Time.y * _WaveSpeed + uv.x * 12.0);
            float waveStrength = _WaveAmount;
            uv.y += wave * waveStrength * t;

            // ✅ HARD CLIP UVs (prevents black edge sampling)
            clip(uv.x);
            clip(1.0 - uv.x);
            clip(uv.y);
            clip(1.0 - uv.y);

            fixed4 tex = tex2D(_MainTex, uv);

            // ✅ Fade shaping
            float pull = pow(1.0 - t, _EdgeSharpness) * _PullStrength;
            float finalFade = pull * _Fade;

            float alpha = tex.a * _Color.a * finalFade;

            // Soft threshold instead of harsh clip
            alpha = smoothstep(0.02, 0.05, alpha);

            // ✅ DO NOT multiply color by fade (prevents black trail)
            float3 col = tex.rgb * _Color.rgb;

            // ✅ Premultiply for stable blending
            col *= alpha;

            o.Albedo = col;
            o.Alpha = alpha;

            // ✅ Stable emission (not killed by alpha)
            o.Emission = tex.rgb * _EmissionColor.rgb * _EmissionStrength * finalFade;

            o.Metallic = 0;
            o.Smoothness = 0;
        }
        ENDCG
    }
}
