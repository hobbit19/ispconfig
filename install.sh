# 2. Update Your Linux Installation
apt-get update && apt-get upgrade -y

# 3. Change the Default Shell
dpkg-reconfigure dash

# 4. Disable AppArmor
service apparmor stop

update-rc.d -f apparmor remove

apt-get remove apparmor apparmor-utils -y

# 5. Synchronize the System Clock
apt-get -y install ntp ntpdate

# 6. Install Postfix, Dovecot, MariaDB, phpMyAdmin, rkhunter, Binutils
service sendmail stop; update-rc.d -f sendmail remove

apt-get -y install postfix postfix-mysql postfix-doc mariadb-client mariadb-server openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo

cp ./files/master.cf /etc/postfix/master.cf

service postfix restart

cp ./files/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

service mysql restart

mysql_secure_installation

service mysql restart

# 7. Install Amavisd-new, SpamAssassin, And ClamAV
apt-get -y install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl postgrey

service spamassassin stop

update-rc.d -f spamassassin remove

cp ./files/clamd.conf /etc/clamav/clamd.conf

service clamav-freshclam restart

service clamav-daemon start


# 7.1 Install Metronome XMPP Server (optional)
apt-get -y install git lua5.1 liblua5.1-0-dev lua-filesystem libidn11-dev libssl-dev lua-zlib lua-expat lua-event lua-bitop lua-socket lua-sec luarocks luarocks

luarocks install lpc

# Add a shell user for Metronome.
adduser --no-create-home --disabled-login --gecos 'Metronome' metronome

# Download Metronome to the /opt directory and compile it.
cd /opt; git clone https://github.com/maranda/metronome.git metronome

cd ./metronome; ./configure --ostype=debian --prefix=/usr

make

make install

# 8. Install Nginx, PHP5 (PHP-FPM), and Fcgiwrap
apt-get install nginx

service apache2 stop
update-rc.d -f apache2 remove
service nginx start
apt-get -y install php7.0-fpm
apt-get -y install php7.0-opcache php7.0-fpm php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap php7.0-cli php7.0-cgi php-pear php-auth php7.0-mcrypt mcrypt imagemagick libruby php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring
phpenmod mcrypt
phpenmod mbstring

apt-get -y install php-apcu
cp ./files/php-fpm.ini /etc/php/7.0/fpm/php.ini
service php7.0-fpm reload
apt-get -y install fcgiwrap

# 8.2 Install phpMyAdmin
apt-get -y install phpmyadmin php-mbstring php-gettext

service nginx reload

# 8.3 Install HHVM (HipHop Virtual Machine)
apt-get -y install software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
add-apt-repository "deb http://dl.hhvm.com/ubuntu xenial main"
apt-get update
apt-get -y install hhvm

# 8.4. Install Let's Encrypt
apt-get -y install letsencrypt


9. Install Mailman
apt-get -y install mailman

newlist mailman

cp ./files/aliases /etc/aliases

newaliases
service postfix restart
service mailman start

# 10. Install PureFTPd And Quota
apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool

cp ./files/pure-ftpd-common /etc/default/pure-ftpd-common

echo 1 > /etc/pure-ftpd/conf/TLS

mkdir -p /etc/ssl/private/

apt-get install -y openssl

openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

chmod 600 /etc/ssl/private/pure-ftpd.pem

service pure-ftpd-mysql restart

cp ./files/fstab /etc/fstab

mount -o remount /

quotacheck -avugm

quotaon -avug

# 11. Install BIND DNS Server
apt-get -y install bind9 dnsutils haveged

systemctl enable haveged
service haveged start

# 12. Install Vlogger, Webalizer, And AWStats
apt-get -y install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl

cp ./files/awstats /etc/cron.d/awstats

# 13. Install Jailkit
apt-get -y install build-essential autoconf automake1.11 libtool flex bison debhelper binutils

cd /tmp
wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz
tar xvfz jailkit-2.19.tar.gz
cd jailkit-2.19
./debian/rules binary

cd ..
dpkg -i jailkit_2.19-1_*.deb
rm -rf jailkit-2.19*

# 14. Install fail2ban
apt-get -y install fail2ban

cp ./files/jail.local /etc/fail2ban/jail.local
cp ./files/pureftpd.conf /etc/fail2ban/filter.d/pureftpd.conf
cp ./files/dovecot-pop3imap.conf /etc/fail2ban/filter.d/dovecot-pop3imap.conf

echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf

service fail2ban restart

apt-get install ufw

# 15. Install Roundcube Webmail
apt-get -y install roundcube roundcube-core roundcube-mysql roundcube-plugins roundcube-plugins-extra javascript-common libjs-jquery-mousewheel php-net-sieve tinymce

cp ./files/config.inc.php /etc/roundcube/config.inc.php

ln -s /usr/share/roundcube /usr/share/squirrelmail

service nginx reload

# 16. Install ISPConfig 3.1
service apache2 stop

update-rc.d -f apache2 remove

service nginx restart

cd /tmp 
wget -O ispconfig.tar.gz https://git.ispconfig.org/ispconfig/ispconfig3/repository/archive.tar.gz?ref=stable-3.1
tar xfz ispconfig.tar.gz
cd ispconfig3*/install/
php -q install.php