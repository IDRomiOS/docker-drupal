FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN apt-get update && apt-get upgrade -y

# Install and setup system apps
RUN apt-get install -y bash-completion curl git nano php-pear supervisor wget
COPY settings/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ssh /root/.ssh
COPY ssh /gitconfig/.gitconfig

# Install and setup SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo root:root | chpasswd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Install and setup Apache
RUN apt-get install -y apache2
RUN usermod -a -G www-data root
COPY settings/localsite.conf /etc/apache2/sites-available/localsite.conf
RUN mkdir -p /var/run/apache2 /var/lock/apache2
RUN a2dissite 000-default
RUN a2ensite localsite
RUN a2enmod rewrite
RUN a2enmod usertrack
RUN a2enmod proxy_http

# Install PHP
RUN apt-get -y install libapache2-mod-php5 php5 php5-curl
COPY settings/php.ini /etc/php5/apache2/php.ini

# Install MySQL
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y libapache2-mod-auth-mysql mysql-client mysql-server php5-mysql

# Install phpMyAdmin
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/app-password password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/app-password-confirm password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password root" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
RUN /etc/init.d/mysql start && apt-get install -y phpmyadmin
RUN echo "\n# Include PHPMyAdmin configuration\nInclude /etc/phpmyadmin/apache.conf\n" >> /etc/apache2/apache2.conf

# Install Drush
RUN pear channel-discover pear.drush.org
RUN pear install drush/drush
COPY settings/drushrc.php /etc/drush/drushrc.php

# Install Memcached
RUN apt-get install -y memcached
RUN pecl install memcache

# Install SASS and Compass
# RUN apt-get install -y ruby1.9.1 -y
# RUN gem install sass
# RUN gem install compass

# # Install Apache Solr
# RUN apt-get install openjdk-7-jdk -y
# RUN mkdir /usr/java
# RUN ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default
# RUN apt-get install solr-tomcat -y

# Drupal
ENV DRUPAL_GIT git@git.internetdevels.com:lab/suicideinfo.git
RUN rm -rf /var/www/html && git clone $DRUPAL_GIT /var/www/html
# WORKDIR /var/www
# RUN drush dl drupal
# RUN rm -rf html && mv drupal* html
# WORKDIR /var/www/html
# RUN /etc/init.d/mysql start \
#   && mysql -uroot -proot -e"CREATE DATABASE IF NOT EXISTS drupalsite;" \
#   && drush si minimal -y --db-url=mysql://root:root@localhost/drupalsite --account-pass=admin

# Run server
EXPOSE 22 80 3306
VOLUME ["/var/www/html"]
CMD ["/usr/bin/supervisord"]
