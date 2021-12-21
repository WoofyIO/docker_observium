#!/bin/sh

cp /config/config.php /opt/observium/config.php
cron -f -l 8 -L /dev/stdout &
rsyslogd &
cat /config/hosts >> /etc/hosts
tail -F /var/log/syslog &
apachectl -D FOREGROUND