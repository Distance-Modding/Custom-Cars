Shader "Custom/TransparentEmissionStandard"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGBA)", 2D) = "white" {}

        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Smoothness ("Smoothness", Range(0,1)) = 0.5

        _EmissionColor ("Emission Color", Color) = (0,0,0,0)
        _EmissionMap ("Emission Map", 2D) = "black" {}

        _EmissionIntensity ("Emission Intensity", Range(0, 10)) = 1
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }

        LOD 300

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _EmissionMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_EmissionMap;
        };

        fixed4 _Color;
        fixed4 _EmissionColor;

        half _Metallic;
        half _Smoothness;
        half _EmissionIntensity;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo + alpha
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            // PBR values
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;

            // Emission
            fixed4 e = tex2D(_EmissionMap, IN.uv_EmissionMap);
            o.Emission = e.rgb * _EmissionColor.rgb * _EmissionIntensity;
        }
        ENDCG
    }

    FallBack "Standard"
}
