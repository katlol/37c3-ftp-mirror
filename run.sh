#!/bin/bash

FTP_URL="https://ccc.nekomimi.pw/ftplist.html"
# example line:
# <p><a href="ftp://151.217.25.140">151.217.25.140</a> <span class="g">FTP supported</span></p>

# ensure RCLONE_REMOTE is set
if [[ -z "$RCLONE_REMOTE" ]]; then
    echo "RCLONE_REMOTE is not set"
    exit 1
fi

GREP="grep"
# If we are on a Mac, use the GNU grep
if [[ $(uname) == "Darwin" ]]; then
    GREP="ggrep"
fi

# get ftp list
FTP_LIST=$(curl -s $FTP_URL | $GREP -oP '(?<=href=")[^"]+(?=")' | $GREP -oP '(?<=ftp://)[^"]+')

# in parallel (8 at a time), run the mirror command
parallel -j 8 --eta --progress --results _local_mirror_results --joblog _local_mirror_log.txt --resume-failed ./mirror.sh ::: $FTP_LIST

# to try, let's run one at a time
for FTP in $FTP_LIST; do
    echo "Mirroring $FTP"
    ./mirror.sh $FTP
done
