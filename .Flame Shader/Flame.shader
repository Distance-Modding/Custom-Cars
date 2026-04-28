Shader "Custom/Flame_AlphaSharp"
{
    Properties
    {
        _Flame1 ("Flame 1", 2D) = "white" {}
        _Flame2 ("Flame 2", 2D) = "white" {}
        _Flame3 ("Flame 3", 2D) = "white" {}
        _Flame4 ("Flame 4", 2D) = "white" {}
        _Flame5 ("Flame 5", 2D) = "white" {}
        _Flame6 ("Flame 6", 2D) = "white" {}
        _Flame7 ("Flame 7", 2D) = "white" {}
        _Flame8 ("Flame 8", 2D) = "white" {}

        _Speed ("Animation Speed", Float) = 1.0
        _Loop ("Loop Duration (unused but kept)", Float) = 8.0

        _FrameCount ("Active Frames", Range(1, 8)) = 8

        _Color ("Flame Color", Color) = (1, 1, 1, 1)
        _Intensity ("Flame Intensity", Float) = 1.0
    }

    SubShader
    {
        Tags { "Queue"="Transparent+1" "RenderType"="Transparent" }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _Flame1, _Flame2, _Flame3, _Flame4;
            sampler2D _Flame5, _Flame6, _Flame7, _Flame8;

            float _Speed;
            float _Loop;
            float4 _Color;
            float _Intensity;
            float _FrameCount;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 SampleFrame(int idx, float2 uv)
            {
                if (idx == 0) return tex2D(_Flame1, uv);
                if (idx == 1) return tex2D(_Flame2, uv);
                if (idx == 2) return tex2D(_Flame3, uv);
                if (idx == 3) return tex2D(_Flame4, uv);
                if (idx == 4) return tex2D(_Flame5, uv);
                if (idx == 5) return tex2D(_Flame6, uv);
                if (idx == 6) return tex2D(_Flame7, uv);
                return tex2D(_Flame8, uv);
            }

            half4 frag(v2f i) : SV_Target
            {
                float frames = max(1.0, floor(_FrameCount));

                float time = _Time.y * _Speed;

                // loop only across active frames
                float animTime = fmod(time, frames);

                float frameIndex = floor(animTime);
                float nextFrame = min(frameIndex + 1.0, frames - 1.0);
                float t = frac(animTime);

                half4 col1 = SampleFrame((int)frameIndex, i.uv);
                half4 col2 = SampleFrame((int)nextFrame, i.uv);

                half4 col = lerp(col1, col2, t);

                col *= _Color * _Intensity;

                if (col.a < 0.01)
                    discard;

                return col;
            }

            ENDCG
        }
    }
}
