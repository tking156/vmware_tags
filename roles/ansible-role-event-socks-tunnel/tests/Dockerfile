FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server && mkdir /root/.ssh && \
        chmod 0700 /root/.ssh && mkdir /var/run/sshd

COPY id_rsa.pub /root/.ssh/authorized_keys

RUN chmod 0600 /root/.ssh/authorized_keys

EXPOSE 22
ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
