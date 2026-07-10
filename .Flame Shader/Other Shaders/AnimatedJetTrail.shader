Shader "Custom/AnimatedJetTrail"
{
    Properties
    {
        _MainTex ("Trail Texture", 2D) = "white" {}
        _NoiseTex ("Warp Texture", 2D) = "white" {}


        _ColorCount ("Number of Colors", Range(2,8)) = 2

        _Color1 ("Color 1", Color) = (0.5,0,1,1)
        _Color2 ("Color 2", Color) = (1,1,0,1)
        _Color3 ("Color 3", Color) = (1,0,0,1)
        _Color4 ("Color 4", Color) = (1,1,1,1)
        _Color5 ("Color 5", Color) = (0,1,1,1)
        _Color6 ("Color 6", Color) = (0,1,0,1)
        _Color7 ("Color 7", Color) = (1,0,1,1)
        _Color8 ("Color 8", Color) = (0,0,1,1)


        _ColorSpeed ("Color Speed", Range(0.01,5)) = 0.5
        _ColorSpread ("Color Spread", Range(0,2)) = 1


        _UVOffsetX ("UV Offset X", Range(-1,1)) = 0
        _UVOffsetY ("UV Offset Y", Range(-1,1)) = 0

        _UVScaleX ("UV Scale X", Float) = 1
        _UVScaleY ("UV Scale Y", Float) = 1


        _WarpScale ("Warp Scale", Float) = 2
        _WarpSpeed ("Warp Speed", Float) = 0.25
        _WarpStrength ("Warp Strength", Range(0,1)) = 0.15


        _Brightness ("Brightness", Float) = 1
        _Alpha ("Alpha", Range(0,1)) = 1
    }


    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }


        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
        ZWrite Off


        CGPROGRAM

        #pragma surface surf Lambert alpha:fade


        sampler2D _MainTex;
        sampler2D _NoiseTex;


        fixed4 _Color1;
        fixed4 _Color2;
        fixed4 _Color3;
        fixed4 _Color4;
        fixed4 _Color5;
        fixed4 _Color6;
        fixed4 _Color7;
        fixed4 _Color8;


        float _ColorCount;

        float _ColorSpeed;
        float _ColorSpread;


        float _UVOffsetX;
        float _UVOffsetY;

        float _UVScaleX;
        float _UVScaleY;


        float _WarpScale;
        float _WarpSpeed;
        float _WarpStrength;


        float _Brightness;
        float _Alpha;



        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
            float4 color : COLOR;
        };



        float2 RotateUV90(float2 uv)
        {
            return float2(
                1.0 - uv.y,
                uv.x
            );
        }



        fixed4 GetColor(int id)
        {
            if(id == 0) return _Color1;
            if(id == 1) return _Color2;
            if(id == 2) return _Color3;
            if(id == 3) return _Color4;
            if(id == 4) return _Color5;
            if(id == 5) return _Color6;
            if(id == 6) return _Color7;

            return _Color8;
        }



        void surf(Input IN, inout SurfaceOutput o)
        {

            //
            // Main UV
            //
            float2 uv = IN.uv_MainTex;


            uv *= float2(_UVScaleX, _UVScaleY);

            uv += float2(_UVOffsetX, _UVOffsetY);


            uv = RotateUV90(uv);



            //
            // Warp
            //
            float2 warpUV =
                RotateUV90(IN.uv_NoiseTex);


            warpUV *= _WarpScale;


            //
            // Direction flipped for forward-moving trail
            //
            warpUV.y -= _Time.y * _WarpSpeed;



            fixed4 warp =
                tex2D(_NoiseTex, warpUV);



            uv +=
                (warp.rg - 0.5)
                * _WarpStrength;



            fixed4 tex =
                tex2D(_MainTex, uv);



            //
            // Continuous color path:
            // A -> B -> C -> D -> A
            //
            // Direction flipped to match forward trail
            //
            float trailPos =
                1.0 -
                RotateUV90(IN.uv_MainTex).y;



            float colorPosition =
                (_Time.y * _ColorSpeed)
                +
                (trailPos * _ColorSpread);



            colorPosition =
                frac(colorPosition)
                *
                _ColorCount;



            int indexA =
                (int)floor(colorPosition);



            int indexB =
                indexA + 1;



            if(indexB >= (int)_ColorCount)
            {
                indexB = 0;
            }



            float blend =
                frac(colorPosition);



            fixed3 colorA =
                GetColor(indexA).rgb;


            fixed3 colorB =
                GetColor(indexB).rgb;



            fixed3 finalColor =
                lerp(
                    colorA,
                    colorB,
                    blend
                );



            o.Albedo =
                tex.rgb *
                finalColor *
                _Brightness;



            o.Alpha =
                tex.a *
                _Alpha *
                IN.color.a;

        }


        ENDCG
    }
}
