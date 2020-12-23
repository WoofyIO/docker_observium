#!/bin/sh

cp /config/config.php /opt/observium/config.php
rsyslogd
cat /config/hosts >> /etc/hosts
tail -F /var/log/syslog