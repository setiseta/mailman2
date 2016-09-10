from debian
env DEBIAN_FRONTEND noninteractive
run apt-get update \
    && apt-get install -y \
      apache2 \
      ca-certificates \
      exim4 \
      mailman \
    && apt-get clean

add vhost.conf /etc/apache2/sites-enabled/mailman.conf
#run rm /etc/apache2/sites-enabled/000-default.conf
run a2enmod cgid

add update-exim4.conf.conf /etc/exim4/update-exim4.conf.conf

add start /usr/local/bin/start
run chmod +x /usr/local/bin/start
expose 80 25
cmd ["/usr/local/bin/start"]
