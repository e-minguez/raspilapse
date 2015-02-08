#!/bin/bash

PORT=
USER=
HOST=
CUSTOMTEXT="minWicam"

WIDTH=640
HEIGHT=480
QUALITY=90
TEMP=/dev/shm/testpic.jpg
SSHFSOPTS="auto_cache,reconnect,no_readahead,Ciphers=arcfour"
SSHFSMP="/home/pi/pics"
SSHFSRP="/var/www/html/webcam/images/"
SLEEP=30
BINDIR="/usr/bin"

trap ctrl_c INT
ctrl_c() {
    /bin/fusermount -u ${SSHFSMP}
        echo "webcam CTRL-C'ed"
    exit 1
}
die() {
    >&2 echo "${1}"
    logger "webcam - ${1}"
    exit $2
}

logger "webcam started"
sleep 60
${BINDIR}/sshfs -p ${PORT} -o ${SSHFSOPTS} ${USER}@${HOST}:${SSHFSRP} ${SSHFSMP} || die "Not connected" 3

while true
do
    OLDFILE=${SSHFSMP}/webcam-$(date +%Y%m%d%H%M%S).jpg
    ${BINDIR}/raspistill -w ${WIDTH} -h ${HEIGHT} -q ${QUALITY} -o ${TEMP} -n
    DATENOW=$(date '+%H:%M:%S %d/%m/%Y')
    cp ${SSHFSMP}/webcam.jpg ${OLDFILE}
    ${BINDIR}/convert ${TEMP} -fill white -undercolor '#00000080' -gravity SouthEast -annotate +0+5 " ${CUSTOMTEXT} ${DATENOW} " ${SSHFSMP}/webcam.jpg
    sleep ${SLEEP}
done

exit 0
