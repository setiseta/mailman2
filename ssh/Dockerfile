from tclavier/mailman2
run apt-get update \
    && apt-get install -y \
      ssh \
      vim \
    && apt-get clean

run sed -e 's/.*PasswordAuthentication.*/PasswordAuthentication no/g' -i /etc/ssh/sshd_config

add authorized_keys /root/.ssh/authorized_keys
run chmod 600 /root/.ssh/authorized_keys
run mkdir /var/run/sshd && \
    chmod 0755 /var/run/sshd

add create_lists /root/
run chmod +x /root/*

cmd ["/usr/sbin/sshd", "-D"]
