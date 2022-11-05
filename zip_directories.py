"""This program zips all the directories, minus the blacklisted ones for a release
this was made with python 3.10, using only standard libraries so you should be able 
to install python and run this command. 
"""

import os
import shutil

directory_blacklist = [".git", ".github"]

def create_zip_directory(directory:str) -> None:
        """Uses shutil to archive the entire specified directory
        Parameters
        ----------
        directory:str  the directory to be zipped"""
        zip_dir = os.path.join(os.getcwd(), "zipped")
        file_path = os.path.join(zip_dir, directory)
        folder_path = os.path.join(os.getcwd(), directory)
        shutil.make_archive(file_path, "zip", folder_path)


def main():
  #create a fresh subdirectory to store zip files in, each time the program is ran
  zip_dir = os.path.join(os.getcwd() , "zipped")
  if(os.path.exists(zip_dir)):
        shutil.rmtree(zip_dir)
  os.mkdir(zip_dir) 

  #get all the directories in the project, remove black listed directories
  files = os.listdir()
  dirs = [ d for d in files if os.path.isdir(d) and d not in directory_blacklist]

  #create a zip archive of each directory
  for directory in dirs:
        create_zip_directory(directory)


if __name__ =="__main__":
        main()
