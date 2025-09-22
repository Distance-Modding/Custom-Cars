Shader "Custom/Flame" {
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
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            // Enable transparency and render both sides of the trail
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off // Disable backface culling to render both sides

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // Texture for each flame frame
            sampler2D _Flame1, _Flame2, _Flame3, _Flame4, _Flame5, _Flame6;
            float _Speed;
            float _Loop;
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag(v2f i) : COLOR
            {
                // Calculate the time-based animation index
                float time = _Time.y * _Speed;
                float index = fmod(time, _Loop); // This loops between 0 and _Loop (6 frames)

                // Use the calculated index to select one of the flame textures
                half4 col = half4(0, 0, 0, 0);
                if (index < 1.0) col = tex2D(_Flame1, i.uv);
                else if (index < 2.0) col = tex2D(_Flame2, i.uv);
                else if (index < 3.0) col = tex2D(_Flame3, i.uv);
                else if (index < 4.0) col = tex2D(_Flame4, i.uv);
                else if (index < 5.0) col = tex2D(_Flame5, i.uv);
                else col = tex2D(_Flame6, i.uv);

                // Apply the color tint and handle transparency
                col *= _Color;

                // If the texture is fully transparent (alpha = 0), discard the fragment
                if (col.a < 0.01) discard;

                return col;
            }
            ENDCG
        }
    }
}
