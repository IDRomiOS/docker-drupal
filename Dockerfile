FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y

# Install and setup system apps
RUN apt-get install nano supervisor bash-completion openssh-server -y

RUN mkdir /var/run/sshd
RUN chmod 755 /var/run/sshd

RUN echo root:root | chpasswd

RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN locale-gen zh_TW zh_TW.UTF-8 en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN alias ls='ls --color=auto'
RUN alias ll='ls -halF'



# Install and configure Apache
RUN apt-get install apache2 -y
# ADD settings/apache2/localhost.conf /etc/apache2/sites-available/localhost.conf
# RUN a2ensite localhost
# RUN a2dissite 000-default
# RUN a2enmod usertrack
# RUN a2enmod rewrite
# RUN a2enmod proxy_http

# Install MySQL
# RUN apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y

# Install PHP
# RUN apt-get install php5 libapache2-mod-php5 php5-mcrypt

# Install phpMyAdmin
# RUN apt-get install phpmyadmin apache2-utils

# RUN apt-get install openssh-server^ -y
# RUN apt-get install lamp-server^ -y
# RUN apt-get install tomcat-server^ -y

# # Make sure root user is added to apache group
# RUN usermod -a -G www-data root

# #PHP Config
# COPY config/php/php.ini /etc/php5/apache2/

# # Install SASS and Compass
# RUN apt-get install ruby1.9.1 -y
# RUN apt-get install ruby1.9.1-dev -y
# RUN gem update rdoc
# RUN apt-get install build-essential -y
# RUN gem install sass -v 3.2.19
# RUN gem install compass -v 0.12.6

# # Install Varnish & Memcached
# RUN apt-get install php-pear varnish memcached -y
# RUN pecl install memcache

# ADD config/varnish/default.vcl /etc/varnish/default.vcl
# ENV VARNISH_BACKEND_PORT 8088
# ENV VARNISH_BACKEND_IP 0.0.0.0
# ENV VARNISH_PORT 80

# # Install Apache Solr
# RUN apt-get install openjdk-7-jdk -y
# RUN mkdir /usr/java
# RUN ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default
# RUN apt-get install solr-tomcat -y

# # www

EXPOSE 22 80 3306

ADD settings/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
