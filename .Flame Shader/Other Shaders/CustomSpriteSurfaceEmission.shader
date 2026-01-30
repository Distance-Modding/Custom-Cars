Shader "Custom/SpriteSurfaceEmission"
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _EmissionColor ("Emission Color", Color) = (1,1,1,1)
        _EmissionMap ("Emission Map", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        sampler2D _MainTex;
        fixed4 _Color;

        // Emission
        sampler2D _EmissionMap;
        fixed4 _EmissionColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_EmissionMap;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            // Transparency
            o.Alpha = c.a;

            // Emission: use the emission texture * color
            fixed4 e = tex2D(_EmissionMap, IN.uv_EmissionMap) * _EmissionColor;
            o.Emission = e.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
