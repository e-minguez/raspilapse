# raspilapse
raspilapse is a set of script to create a webcam using raspberry pi camera pics, and at the end of the day, create a timelapse with all that day images and upload it to youtube automatically.

## Requisites
* raspberry pi
* raspberry pi camera
* raspbian
* sshfs
* youtube-upload https://github.com/tokland/youtube-upload

## Usage
As the raspberry is located at home, I didn't want to NAT ports or whatever, instead, I've used a cheap VPS to upload the pics to it to serve as a webcam, and to create the timelapse.
The raspberry pi mounts a remote directory using sshfs instead using its own storage (better sd life)

The process will be:
* Mount a sshfs from the VPS /var/www/html/webcam/images/ to /home/pi/pics
Then, loop through:
* raspistill takes a picture and save it to /dev/shm (in memory filesystem)
* Using ImageMagick it adds some info to the pic (Some info and date), and save the modified image to the sshfs /home/pi/pics
* Sleep some seconds
* Rename the old picture to a name with the date (webcam-xx.jpg)

On the VPS, daily:
* Create a timelapse with all the "webcam-xx.jpg" files
* Save it to a custom folder to store all the daily timelapses
* Upload it to youtube using youtube-upload
* Move the webcam-xx.jpg files to a custom "date" folder
