#!/bin/sh

DATE=$(date -d '-1 day' +%Y%m%d)
DATEFORMAT=$(date '+%d/%m/%Y')

TITLE="${DATEFORMAT}"
DESCRIPTION=""

WEBCAMDIR="/var/www/html/webcam"
IMGDIR="${WEBCAMDIR}/images"
VIDDIR="${WEBCAMDIR}/videos"

cat ${IMGDIR}/webcam-*.jpg | /usr/bin/ffmpeg -v info -f image2pipe -r 30 -vcodec mjpeg -i - -vcodec libx264 -pix_fmt yuv420p ${VIDDIR}/${DATE}.mp4
/usr/bin/youtube-upload --title ${TITLE} --description ${DESCRIPTION} --location="=" ${VIDDIR}/${DATE}.mp4
mkdir -p ${IMGDIR}/${DATE}/
mv ${IMGDIR}/webcam-*.jpg ${IMGDIR}/${DATE}/

exit 0
