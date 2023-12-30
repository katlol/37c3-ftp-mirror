#!/bin/bash
# this file takes 1 argument, the FTP url,
# it is then responsible for mirroring the FTP
# to the $RCLONE_REMOTE

# ensure RCLONE_REMOTE is set
if [[ -z "$RCLONE_REMOTE" ]]; then
    echo "RCLONE_REMOTE is not set"
    exit 1
fi
# if COMMAND is not set, set it to sync
COMMAND=${COMMAND:-sync}

# if COMMAND is not sync, set REMOTE to empty
# otherwise, $RCLONE_REMOTE/$1
if [[ "$COMMAND" != "sync" ]]; then
    REMOTE=""
    EXCLUDE=""
else
    REMOTE="$RCLONE_REMOTE/$1"
    EXCLUDE="--exclude-from=exclude.txt --progress"
fi

rclone \
$COMMAND \
:ftp: \
--ftp-host=$1 \
--ftp-user=anonymous \
--ftp-pass=$(rclone obscure dummy) \
$EXCLUDE \
--transfers=20 \
--checkers=200 \
--ftp-concurrency=221 \
$REMOTE
