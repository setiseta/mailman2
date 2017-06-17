FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN sed -e 's/httpredir.debian.org/debian.mirrors.ovh.net/g' -i /etc/apt/sources.list

ADD start /usr/local/bin/start

RUN apt-get update \
    && apt-get install -y \
      apache2 \
      ca-certificates \
      postfix \
      locales \
      mailman \
      rsync \
    && apt-get clean \
    && a2dissite 000-default \
    && a2enmod cgid \
    && chmod +x /usr/local/bin/start \
    && mv /var/lib/mailman /mailman \
    && mkdir /var/lib/mailman \
    && chown :list /var/lib/mailman

ADD vhost.conf /etc/apache2/sites-enabled/mailman.conf
ADD mm_cfg.py /etc/mailman/mm_cfg.py.tpl

EXPOSE 80 25
ENV MM_PASSWORD=password
VOLUME ["/var/lib/mailman"]
CMD ["/usr/local/bin/start"]
