timedatectl set-timezone $TIMEZONE
timedatectl set-local-rtc 0

echo '==> Setting '$(timedatectl | grep 'Time zone:' | xargs)

echo '==> Resetting dnf cache'

dnf -q -y clean all
rm -rf /var/cache/dnf
dnf -q -y makecache &>/dev/null

echo '==> Installing Linux tools'

cp /vagrant/config/bashrc /home/vagrant/.bashrc
chown vagrant:vagrant /home/vagrant/.bashrc
dnf -q -y install nano tree zip unzip whois &>/dev/null

echo '==> Installing Git'

dnf -q -y install git &>/dev/null

echo '==> Installing Apache'

dnf -q -y install httpd &>/dev/null
usermod -a -G apache vagrant
chown -R root:apache /var/log/httpd
cp /vagrant/config/localhost.conf /etc/httpd/conf.d/localhost.conf
cp /vagrant/config/virtualhost.conf /etc/httpd/conf.d/virtualhost.conf
sed -i 's|GUEST_SYNCED_FOLDER|'$GUEST_SYNCED_FOLDER'|' /etc/httpd/conf.d/virtualhost.conf
sed -i 's|HOST_HTTP_PORT|'$HOST_HTTP_PORT'|' /etc/httpd/conf.d/virtualhost.conf

echo '==> Setting MariaDB 10.6 repository'

rpm --import --quiet https://mirror.rackspace.com/mariadb/yum/RPM-GPG-KEY-MariaDB
cp /vagrant/config/MariaDB.repo /etc/yum.repos.d/MariaDB.repo

echo '==> Installing MariaDB'

dnf -q -y install MariaDB-server MariaDB-client &>/dev/null

echo '==> Setting PHP 8.2 repository'

{
    rpm --import --quiet https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-9
    dnf -q -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    rpm --import --quiet https://rpms.remirepo.net/RPM-GPG-KEY-remi
    dnf -q -y install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
    dnf -q -y module enable php:remi-8.2
} &>/dev/null

echo '==> Installing PHP'

dnf -q -y --enablerepo=devel install aspell &>/dev/null
dnf -q -y install php php-cli php-common \
    php-bcmath php-devel php-gd php-imap php-intl php-ldap php-mcrypt php-mysqlnd php-opcache \
    php-pear php-pgsql php-pspell php-soap php-tidy php-xdebug php-xmlrpc php-yaml php-zip &>/dev/null
cp /etc/httpd/conf.modules.d/00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf~
cp /vagrant/config/00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
cp /vagrant/config/php.ini.htaccess /var/www/.htaccess
PHP_ERROR_REPORTING_INT=$(php -r 'echo '"$PHP_ERROR_REPORTING"';')
sed -i 's|PHP_ERROR_REPORTING_INT|'$PHP_ERROR_REPORTING_INT'|' /var/www/.htaccess

echo '==> Installing Adminer'

if [ ! -d /usr/share/adminer ]; then
    mkdir -p /usr/share/adminer/adminer-plugins
    curl -LsS https://www.adminer.org/latest-en.php -o /usr/share/adminer/latest-en.php
    curl -LsS https://raw.githubusercontent.com/vrana/adminer/master/plugins/login-password-less.php -o /usr/share/adminer/adminer-plugins/login-password-less.php
    curl -LsS https://raw.githubusercontent.com/vrana/adminer/master/plugins/dump-json.php -o /usr/share/adminer/adminer-plugins/dump-json.php
    curl -LsS https://raw.githubusercontent.com/vrana/adminer/master/plugins/pretty-json-column.php -o /usr/share/adminer/adminer-plugins/pretty-json-column.php
    curl -LsS https://raw.githubusercontent.com/vrana/adminer/master/designs/nicu/adminer.css -o /usr/share/adminer/adminer.css
fi
cp /vagrant/config/adminer.php /usr/share/adminer/adminer.php
cp /vagrant/config/adminer-plugins.php /usr/share/adminer/adminer-plugins.php
cp /vagrant/config/adminer.conf /etc/httpd/conf.d/adminer.conf
sed -i 's|HOST_HTTP_PORT|'$HOST_HTTP_PORT'|' /etc/httpd/conf.d/adminer.conf

echo '==> Installing Ruby & irb'

dnf module reset ruby -y &>/dev/null
dnf module enable ruby:"${RUBY_VERSION}" -y &>/dev/null
dnf install ruby ruby-devel rubygem-irb -y &>/dev/null

echo '==> Adding HTTP service to firewall'

setenforce Permissive
firewall-cmd --add-service=http --permanent &>/dev/null
firewall-cmd --reload &>/dev/null

echo '==> Testing Apache configuration'

if [ ! -L /etc/systemd/system/multi-user.target.wants/httpd.service ] ; then
    ln -s /usr/lib/systemd/system/httpd.service /etc/systemd/system/multi-user.target.wants/httpd.service
fi
apachectl configtest

echo '==> Starting Apache'

systemctl restart httpd
systemctl enable httpd

echo '==> Starting MariaDB'

if [ ! -L /etc/systemd/system/multi-user.target.wants/mariadb.service ] ; then
    ln -s /usr/lib/systemd/system/mariadb.service /etc/systemd/system/multi-user.target.wants/mariadb.service
fi
systemctl restart mariadb
systemctl enable mariadb
mysqladmin -u root password ""

echo
echo '==> Stack versions <=='

cat /etc/redhat-release
openssl version
curl --version | head -n1 | cut -d '(' -f 1
git --version
httpd -V | head -n1 | cut -d ' ' -f 3-
mysql -V
php -v | head -n1
python3 --version
ruby -v
