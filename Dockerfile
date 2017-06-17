FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
RUN sed -e 's/httpredir.debian.org/debian.mirrors.ovh.net/g' -i /etc/apt/sources.list

ADD init.sh /init.sh

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
    && chmod +x /init.sh \
    && mv /var/lib/mailman /mailman \
    && mkdir /var/lib/mailman \
    && chown :list /var/lib/mailman \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mv /var/spool/postfix /postfixtemplate

ADD vhost.conf /etc/apache2/sites-enabled/mailman.conf
ADD mm_cfg.py /etc/mailman/mm_cfg.py.tpl

EXPOSE 80 25
VOLUME ["/var/lib/mailman", "/var/spool/postfix/"]
CMD ["/init.sh"]
