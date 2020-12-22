FROM ubuntu:latest

ARG SVN_USER
ARG SVN_PASS

ENV TZ=America/Los_Angeles

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y cron libapache2-mod-php7.4 php7.4-cli php7.4-mysql php7.4-mysqli php7.4-gd php7.4-json \
    php-pear rsyslog snmp fping mysql-client python3-mysqldb rrdtool subversion whois mtr-tiny \
    ipmitool graphviz imagemagick apache2 python3-pymysql python-is-python3 && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/observium && cd /opt && \ 
    svn --username ${SVN_USER} --password ${SVN_PASS} --trust-server-cert --non-interactive co http://svn.observium.org/svn/observium/trunk observium && \
    cd observium && \
    mkdir -p /config/rrd && touch /config/config.php && ln -s /config/rrd rrd && ln -s /config/config.php config.php && \
    rm -Rf /opt/observium/.svn && \
    phpenmod mcrypt && \
    a2dismod mpm_event && \
    a2enmod mpm_prefork && \
    a2enmod php7.4 && \
    a2enmod rewrite

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY 30-observium.conf /etc/rsyslog.d/30-observium.conf
COPY rsyslog.conf /etc/rsyslog.conf
COPY observium_cron.conf /etc/cron.d/observium

ADD start.sh /

RUN chmod +x /start.sh
RUN sed -i 's/\r//' /start.sh

EXPOSE 80 514

CMD ["/start.sh"]

