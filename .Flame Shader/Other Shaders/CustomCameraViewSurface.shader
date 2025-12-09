Shader "Custom/CameraViewSurface"
{
    Properties
    {
        _MainTex ("Camera RenderTexture", 2D) = "black" {}
        _EmissionColor ("Emission Color", Color) = (0,0,0,0)
        _EmissionStrength ("Emission Strength", Range(0,5)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _EmissionColor;
        float _EmissionStrength;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float4 col = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = col.rgb;
            o.Smoothness = 0.0;
            o.Metallic = 0.0;

            // Apply emission
            o.Emission = _EmissionColor.rgb * _EmissionStrength;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
