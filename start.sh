#!/bin/sh

cron -f -l 8 -L /dev/stdout &
rsyslogd &
apachectl -D FOREGROUND