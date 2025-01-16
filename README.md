# Custom-Cars

a repo made for all community cars using the [CustomCar](https://github.com/Distance-Modding/Mod.CustomCar) plugin created by Nico (ported to Centrifuge by [REHERC](https://github.com/REHERC)).

Please see CONTRIBUTING.md to learn how to add your own car to this repo.

## How Do I Install Custom Cars?
<details open><summary>[NEW] Thunderstore</summary>

1. Install either [Thunderstore app](https://www.overwolf.com/app/Thunderstore-Thunderstore_Mod_Manager) or [r2modman](https://r2modman.com/)
2. Find Distance in the game list and select it, then select or create a profile for it.
3. Select the Custom Car mod from the list of available mods.
   - You may also want to get the Mod Configuration Manager mod, which gives you in-game settings for any mods you have installed.
5. **Important:** Go into the Settings in Thunderstore or r2 and change the `Preloader.Entrypoint` to `UnityEngine.dll` instead of the default `UnityEngine.CoreModule.dll` or no mods will be loaded at all.
6. Again in Settings, find the `Browse profile folder` option, and click it.
7. In the profile folder, go into the `BepInEx\plugins\DistanceModdingTeam-Custom_Car_Mod\` folder, and create an `Assets` folder.
   - Cars downloaded from this GitHub repo need to be placed in this Assets folder (or a subfolder within Assets).

**A video guide can be found [here](https://www.youtube.com/watch?v=3mH3Zw7xzgA)**.
</details>

<details><summary>[OLD] Centrifuge</summary>

First, you'll need the Centrifuge modloader for Distance.
You can learn how to do that here:

- [(Text Tutorial)](https://github.com/Centrifuge-Modding-Framework/Centrifuge/wiki/How-to-Install)
- [(Video Tutorial)](https://www.youtube.com/watch?v=1svWX6mioKI)

Once you have Centrifuge installed you'll need to go [here](https://github.com/Distance-Modding/Mod.CustomCar/releases) and follow these steps:
1. Download the Distance.Custom.Car.zip file.
   * If you're using Centrifuge, you'll want to download the `Workflow-Automated Deployment [#3]` version from Sep 5, 2021, not the `BepInEx Build` version.
3. Extract the zip file into the same directory Centrifuge is installed in. (Centrifuge should be installed in your Distance_Data folder)
4. If asked to replace any files, replace them.
5. Congrats you have the mod installed! Open the game and check your garage to make sure you did everything right.

[There is a video tutorial for installing mods that uses the same steps in case you are still confused](https://www.youtube.com/watch?v=_dTqOPQ-RUQ)
</details>

Now the fun part. <br>
To add more custom cars, you can download them from here! Once downloaded, the files just need to be placed within the Assets folder. Don't know where that is? <br>

- Thunderstore: Settings -> Browse profile folder -> BepinEx -> plugins -> DistanceModdingTeam-Custom_Car_Mod
   - Inside the custom car mod folder, create an Assets folder. Any subfolders can be placed inside this Assets folder, and all car files should be somewhere within Assets.
- Centrifuge: Navigate to your Centrifuge folder then select Mods, Distance Custom Car, and there you should find the Assets folder.

<br>
How to download cars from this repository you ask? <br>
You can download cars invididually by navigating to their files and clicking the `Download` button. For example go to the [Corruptor's page](https://github.com/Distance-Modding/Custom-Cars/blob/main/Original%20Cars/Corruptor) and try downloading it. <br>
If you want to download this entire repository and organize the files locally, you can do so by selecting green `Code` dropdown button and then selecting `Download ZIP`

## How Do I Make Custom Cars?

Oh you want to make custom cars yourself? Have a look at the [Custom Car Wiki](https://github.com/larnin/CustomCar/wiki) for details on how to do that. <br>
If you would rather watch videos then here's a playlist of [Omegapus' Video Tutorial's](https://www.youtube.com/playlist?list=PLR498UPJ2bQYgqMnu66QPmULsltp3KvnC) <br>
**Please note that these guides were made when the old modloader called "Spectrum" existed, but they are still applicable to the modern modloader.**

## I'm having issues with the mod!
If your car looks like a mess of polygons like this: ![Good lord what is happening in there!?](/.github/assets/img/customcardents.png) You may need to enable Car Dents in your graphics settings.

If you're experiencing low fps whenever the Interceptor car opens its wings, try turning off motion blur in your graphics settings.

If you're having issues with a specific car tell us about on the [Issues](https://github.com/Distance-Modding/Custom-Cars/issues) page. Select the `New Issues` button and then select the `Get Started` button for Report Bug.

For any other issues head over to the [Distance Discord](https://discord.gg/distance) and go to the #plugins channel. You may find some help there.
