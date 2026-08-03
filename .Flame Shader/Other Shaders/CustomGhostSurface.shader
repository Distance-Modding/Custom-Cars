Shader "Custom/GhostSurface"
{
    Properties
    {
        _MainTex ("Ghost Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "gray" {}

        _Tint ("Ghost Tint", Color) = (0.8,0.95,1,1)

        _EmissionColor ("Emission Color", Color) = (0.6,0.9,1,1)
        _EmissionIntensity ("Emission Intensity", Range(0,10)) = 2

        _DistortAmount ("Distortion", Range(0,0.1)) = 0.02
        _NoiseScale ("Noise Scale", Float) = 3
        _NoiseSpeed ("Noise Speed", Float) = 0.25

        _PulseSpeed ("Pulse Speed", Float) = 2

        _RimColor ("Rim Color", Color) = (0.7,0.95,1,1)
        _RimPower ("Rim Power", Range(1,8)) = 4
        _RimIntensity ("Rim Intensity", Range(0,5)) = 2

        _VertexAmount ("Vertex Wobble", Range(0,0.03)) = 0.004

        _Glossiness ("Smoothness", Range(0,1)) = 0
        _Metallic ("Metallic", Range(0,1)) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off
        Cull Back

        CGPROGRAM
        #pragma surface surf Standard alpha:fade vertex:vert fullforwardshadows

        sampler2D _MainTex;
        sampler2D _NoiseTex;

        half _Glossiness;
        half _Metallic;

        fixed4 _Tint;

        fixed4 _EmissionColor;
        float _EmissionIntensity;

        float _DistortAmount;
        float _NoiseScale;
        float _NoiseSpeed;

        float _PulseSpeed;

        fixed4 _RimColor;
        float _RimPower;
        float _RimIntensity;

        float _VertexAmount;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        void vert(inout appdata_full v)
        {
            float wave =
                sin(_Time.y * 2 + v.vertex.y * 8) *
                cos(_Time.y * 1.5 + v.vertex.x * 6);

            v.vertex.xyz +=
                v.normal *
                wave *
                _VertexAmount;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float2 uv = IN.uv_MainTex;

            float2 noise1 =
                tex2D(_NoiseTex,
                    uv * _NoiseScale +
                    _Time.y * _NoiseSpeed).rg;

            float2 noise2 =
                tex2D(_NoiseTex,
                    uv * (_NoiseScale * 0.6) -
                    _Time.y * (_NoiseSpeed * 0.55)).rg;

            float2 distortion =
                (noise1 + noise2 - 1.0) *
                _DistortAmount;

            uv += distortion;

            fixed4 ghost =
                tex2D(_MainTex, uv) *
                _Tint;

            o.Albedo = ghost.rgb;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;

            float rim =
                1.0 -
                saturate(dot(normalize(IN.viewDir), o.Normal));

            rim = pow(rim, _RimPower);

            // Texture emission + rim emission
            o.Emission =
                (ghost.rgb * _EmissionColor.rgb * _EmissionIntensity) +
                (_RimColor.rgb * rim * _RimIntensity);

            float pulse =
                sin(_Time.y * _PulseSpeed) *
                0.08 +
                0.92;

            o.Alpha = ghost.a * pulse;
        }

        ENDCG
    }

    FallBack "Transparent/Diffuse"
}
