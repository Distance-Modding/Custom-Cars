Shader "Custom/StandardTreadMotion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}

        _ZScale ("Motion Scale", Float) = 1.0

        _UStretchFix ("U Stretch Fix", Range(0.1, 5)) = 1.0
        _VStretchFix ("V Stretch Fix", Range(0.1, 5)) = 1.0

        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;

        fixed4 _Color;
        half _Metallic;
        half _Glossiness;

        float _ZScale;
        float _UStretchFix;
        float _VStretchFix;

        struct Input
        {
            float3 worldPos;
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 worldPos = IN.worldPos;

            // stable forward direction from object
            float3 forward = normalize(mul((float3x3)unity_ObjectToWorld, float3(0,0,1)));

            // motion along tank direction
            float motion = dot(worldPos, forward);

            float2 uv;

            uv.x = motion * _ZScale;
            uv.y = IN.uv_MainTex.y;

            uv.x *= _UStretchFix;
            uv.y *= _VStretchFix;

            fixed4 c = tex2D(_MainTex, uv) * _Color;

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Standard"
}
