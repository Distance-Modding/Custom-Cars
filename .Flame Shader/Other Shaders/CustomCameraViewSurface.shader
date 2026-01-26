Shader "Custom/CameraViewSurface"
{
    Properties
    {
        _MainTex ("Camera RenderTexture", 2D) = "black" {}
        _EmissionColor ("Emission Tint", Color) = (1,1,1,1)
        _EmissionStrength ("Brightness", Range(0.1, 5)) = 1
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
            fixed4 col = tex2D(_MainTex, IN.uv_MainTex);

            // Exposure-style brightness (prevents white blowout)
            float brightness = _EmissionStrength;
            col.rgb = 1.0 - exp(-col.rgb * brightness);

            // Screen-like surface (not affected by scene lighting)
            o.Albedo = 0;
            o.Metallic = 0.0;
            o.Smoothness = 0.0;

            // Emission comes from the camera texture
            o.Emission = col.rgb * _EmissionColor.rgb;
        }
        ENDCG
    }

    FallBack "Standard"
}
