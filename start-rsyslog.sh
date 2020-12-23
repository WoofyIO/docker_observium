#!/bin/sh

cp /config/config.php /opt/observium/config.php
rsyslogd
tail -F /var/log/syslog