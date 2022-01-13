# NAS Music DB
A simple MP3 Database which not required complicated installation

![Snímek z 2021-04-27 19-15-32](https://user-images.githubusercontent.com/33415849/116286995-2a324980-a790-11eb-97dd-9734f75ef0b7.png)


## Instalation
Install Apache on your server 
>  sudo apt-get install apache2

Then Copy this Application to the *Web server root dir* (*/var/www*) and upload music or create a symlink to a folder named **"music"**

## Creating a music database
Before run script, you have to installed **exiftool**. 
> sudo apt-get install exiftool

Then you can run the script to create a database.
> ./scanMusic.sh

*You can run it regularly with a cron.*
