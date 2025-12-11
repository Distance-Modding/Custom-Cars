Shader "Custom/StandardTransparentEmission"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Primary Color", Color) = (1,1,1,1)       // linked to color changer primary/secondary
        _EmitColor ("Glow Color", Color) = (1,1,1)        // linked to color changer glow
        _Alpha ("Transparency", Range(0,1)) = 1

        _Saturation ("Saturation", Float) = 1
        _EmissionPower ("Emission Power", Range(0,5)) = 1
    }

    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade vertex:vert

        sampler2D _MainTex;
        float4 _Color;          // primary/secondary color from garage
        float3 _EmitColor;      // glow color from garage
        float _Alpha;
        float _Saturation;
        float _EmissionPower;

        struct Input
        {
            float2 uv_MainTex;
            float4 color : COLOR;  // vertex color from Trail Renderer
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input,o);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            // Sample texture
            float4 tex = tex2D(_MainTex, IN.uv_MainTex);

            // Blend vertex color with material primary color (optional: can override with _Color fully)
            float3 col = tex.rgb * _Color.rgb;

            // Unlimited saturation
            float gray = dot(col, float3(0.299, 0.587, 0.114));
            col = lerp(gray.xxx, col, _Saturation);

            // Albedo and alpha
            o.Albedo = col;
            o.Alpha = tex.a * _Alpha;

            // Emission: texture * glow color * emission power
            float3 emissionTex = tex.rgb;
            o.Emission = emissionTex * _EmitColor * _EmissionPower;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
