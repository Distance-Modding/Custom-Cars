Shader "Custom/CameraViewSurface"
{
    Properties
    {
        _MainTex ("Camera RenderTexture", 2D) = "black" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard
        #pragma target 3.0

        sampler2D _MainTex;

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
        }
        ENDCG
    }

    FallBack "Diffuse"
}
