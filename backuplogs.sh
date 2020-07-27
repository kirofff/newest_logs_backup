#!/bin/bash

# Backup logs securely @LogServer
# by KiRoFF

find /var/www/logfiles/ -type f ! -name "*.gz" | sort -h > /tmp/logsforgz
ls -d -1 -t /var/www/logfiles/*.* | head -30 | sort -h > /tmp/logsnewest
comm -3 --nocheck-order /tmp/logsforgz /tmp/logsnewest > /tmp/readyforgz
cat /tmp/readyforgz | xargs -n1 gzip

find /var/www/logfiles/ -type f -name "*.gz" -mtime +182 | sort -h > /tmp/logsforsync
rsync -vR --remove-source-files --files-from=/tmp/logsforsync / root@192.168.198.203:/LOGSTORAGE/29/ >> /var/log/backuplogs.log
