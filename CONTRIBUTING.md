# Contributing
Firstly, check out the [Custom-Cars/Original Cars](Custom-Cars/Original Cars) folder. Cars are sorted into their applicable folders and then are credited in the README.md with this format:
CarName (Creator)

In order to add your own cars to this repo, you first must make a github account and join the [Distance-Modding](https://github.com/Distance-Modding) organization. That way, you will have access to editing this repo and will be able to add your own car to any folder with the Add File button. You will also be able to edit the README.md in the folder to credit yourself or any others who worked on that car.

Don't want to join the Distance-Modding organization?
Here is an alternative method to add your own car to the repo:
1. Download and install [git](https://git-scm.com/) if you don't already have it.
2. Log in to Github and Fork the repo by clicking the Fork button in the top right corner.
3. Click the green `Clone or download` button, and copy the link.
4. Clone the new repo.
   * Windows:
      1. Open any folder in explorer.
	    2. Hold shift and right-click any empty part of the folder.
	    3. Hit either "Open PowerShell window here" or "Open command window here" depending on your version of Windows.
	    4. Type in `git clone ` and paste the link (ctrl+v) and hit enter (full command should look something like `git clone https://github.com/YourName/Custom-Cars.git`).
	    5. Don't close the window, you'll need it again later.
   <!--* Mac-->
	 <!--* Linux-->
5. When the repo is done being cloned, place your custom car inside your desired directory.
6. Go back to the console window and type `cd Custom-Cars` and hit enter.
7. Type `git add .` and hit enter.
8. Type `git commit -m "Adding my own custom car"` and hit enter (or use whatever message you want after the `-m`).
9. Type `git push origin master` and hit enter.
   * At this point, you will likely be asked to login to Github.
10. Once the push has finished, create a Pull Request (PR) and click on `compare across forks`.
11. In the `head repository` drop-down, select `YourName/Custom-Cars`.
12. Hit the green `Create pull request` button, and then on the next page, the green `Create pull request` button again.
