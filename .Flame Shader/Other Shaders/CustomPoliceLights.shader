Shader "Custom/PoliceLights"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _RedColor ("Red Light", Color) = (1, 0, 0, 1)
        _BlueColor ("Blue Light", Color) = (0, 0.2, 1, 1)
        _Intensity ("Light Intensity", Float) = 3
        _Speed ("Flash Speed", Float) = 4
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        fixed4 _RedColor;
        fixed4 _BlueColor;
        float _Intensity;
        float _Speed;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);

            o.Albedo = tex.rgb;

            // Alternates between red and blue.
            float flash = sin(_Time.y * _Speed);

            float redAmount  = saturate(flash);
            float blueAmount = saturate(-flash);

            fixed3 emission =
                (_RedColor.rgb * redAmount +
                 _BlueColor.rgb * blueAmount) * _Intensity;

            o.Emission = emission;
            o.Alpha = tex.a;
        }

        ENDCG
    }

    FallBack "Standard"
}
