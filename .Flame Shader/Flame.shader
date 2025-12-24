Shader "Custom/Flame_AlphaSharp" {
    Properties {
        _Flame1 ("Flame 1", 2D) = "white" {}
        _Flame2 ("Flame 2", 2D) = "white" {}
        _Flame3 ("Flame 3", 2D) = "white" {}
        _Flame4 ("Flame 4", 2D) = "white" {}
        _Flame5 ("Flame 5", 2D) = "white" {}
        _Flame6 ("Flame 6", 2D) = "white" {}
        _Speed ("Animation Speed", Float) = 1.0
        _Loop ("Loop Duration", Float) = 6.0
        _Color ("Flame Color", Color) = (1, 1, 1, 1)
        _Intensity ("Flame Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "Queue"="Transparent+1" "RenderType"="Transparent" }

        Pass
        {
            // Standard alpha blending for crisp, non-emissive flames
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _Flame1, _Flame2, _Flame3, _Flame4, _Flame5, _Flame6;
            float _Speed;
            float _Loop;
            float4 _Color;
            float _Intensity;

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                float time = _Time.y * _Speed;
                float index = fmod(time, _Loop);

                half4 col;
                if (index < 1.0) col = tex2D(_Flame1, i.uv);
                else if (index < 2.0) col = tex2D(_Flame2, i.uv);
                else if (index < 3.0) col = tex2D(_Flame3, i.uv);
                else if (index < 4.0) col = tex2D(_Flame4, i.uv);
                else if (index < 5.0) col = tex2D(_Flame5, i.uv);
                else col = tex2D(_Flame6, i.uv);

                // Apply color and intensity
                col *= _Color * _Intensity;

                if (col.a < 0.01)
                    discard;

                return col;
            }
            ENDCG
        }
    }
}
