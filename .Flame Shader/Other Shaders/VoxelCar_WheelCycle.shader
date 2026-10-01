Shader "Custom/VoxelCar_WheelCycle"
{
    Properties
    {
        _Wheel01 ("Wheel Frame 1", 2D) = "white" {}
        _Wheel02 ("Wheel Frame 2", 2D) = "white" {}
        _Wheel03 ("Wheel Frame 3", 2D) = "white" {}
        _Wheel04 ("Wheel Frame 4", 2D) = "white" {}

        _Color ("Color", Color) = (1,1,1,1)

        _FrameSize ("Distance Per Frame", Float) = 0.5

        [Toggle] _Reverse ("Reverse Animation", Float) = 0

        _Metallic ("Metallic", Range(0,1)) = 0
        _Glossiness ("Smoothness", Range(0,1)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _Wheel01;
        sampler2D _Wheel02;
        sampler2D _Wheel03;
        sampler2D _Wheel04;

        fixed4 _Color;

        float _FrameSize;
        float _Reverse;

        half _Metallic;
        half _Glossiness;

        struct Input
        {
            float2 uv_Wheel01;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            /*
             * Get the object's world-space Z position.
             */
            float objectZ = unity_ObjectToWorld._m23;

            /*
             * Distance between animation frames.
             */
            float frameSize = max(_FrameSize, 0.001);

            /*
             * Calculate the current frame.
             */
            float frame = floor(objectZ / frameSize);

            /*
             * Loop between 0, 1, 2 and 3.
             */
            frame = fmod(frame, 4.0);

            /*
             * Handle negative Z positions.
             */
            if (frame < 0.0)
            {
                frame += 4.0;
            }

            /*
             * Reverse the animation if enabled.
             *
             * Normal:
             * 0 → 1 → 2 → 3
             *
             * Reversed:
             * 0 → 3 → 2 → 1
             */
            if (_Reverse > 0.5)
            {
                frame = 3.0 - frame;
            }

            /*
             * Shared UV coordinates.
             */
            float2 uv = IN.uv_Wheel01;

            fixed4 color;

            /*
             * Hard frame selection.
             */
            if (frame < 1.0)
            {
                color = tex2D(_Wheel01, uv);
            }
            else if (frame < 2.0)
            {
                color = tex2D(_Wheel02, uv);
            }
            else if (frame < 3.0)
            {
                color = tex2D(_Wheel03, uv);
            }
            else
            {
                color = tex2D(_Wheel04, uv);
            }

            color *= _Color;

            o.Albedo = color.rgb;
            o.Alpha = color.a;

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
        }

        ENDCG
    }

    FallBack "Diffuse"
}
