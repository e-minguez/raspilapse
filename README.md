# raspilapse
raspilapse is a set of script to create a webcam using raspberry pi camera pics, and at the end of the day, create a timelapse with all that day images and upload it to youtube automatically.

As the raspberry is located at home, I didn't want to NAT ports or whatever, instead, I've used a cheap VPS to upload the pics to it to serve as a webcam, and to create the timelapse.
The raspberry pi mounts a remote directory using sshfs instead using its own storage (better sd life)

## Requisites
* raspberry pi
* raspberry pi camera
* raspbian
* sshfs
* ImageMagick

### VPS requisites
* [youtube-upload](https://github.com/tokland/youtube-upload)
* pi user
* Apache running

## Installation in the raspberry
You need to:
* Create a /home/pi/pics director
```
mkdir -p /home/pi/pics
```
* Setup a crontab at boot like 
```
@reboot /home/pi/webcam.sh
```
## Installation in VPS
You need to:
* Create a /var/www/html/webcam folder
```
mkdir -p /var/www/html/webcam/{images,videos}
```
* Change user/group to the "pi" user
```
chown -R pi:pi /var/www/html/webcam
```
* Create a crontab entry for the pi user:
```
@daily /home/pi/upload_timelapse.sh
```
* Run youtube-upload to configure the token, etc. once

## How it works
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

## Results
[Some timelapse](https://www.youtube.com/watch?v=56wNbNZc83I)
