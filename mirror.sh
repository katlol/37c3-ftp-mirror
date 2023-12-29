#!/bin/bash
# this file takes 1 argument, the FTP url,
# it is then responsible for mirroring the FTP
# to the $RCLONE_REMOTE

# ensure RCLONE_REMOTE is set
if [[ -z "$RCLONE_REMOTE" ]]; then
    echo "RCLONE_REMOTE is not set"
    exit 1
fi

rclone \
sync \
--progress \
:ftp: \
--ftp-host=$1 \
--ftp-user=anonymous \
--ftp-pass=$(rclone obscure dummy) \
--exclude="*transmission-incomplete*" \
--exclude="*.part.*" \
--exclude="*.partial.*" \
--exclude="*.mkv" \
$RCLONE_REMOTE/$1
