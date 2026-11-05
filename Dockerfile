FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       openssh-server sudo python3 ca-certificates \
    && useradd --create-home --shell /bin/bash ansible \
    && echo 'ansible:ansible' | chpasswd \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible \
    && visudo -cf /etc/sudoers.d/ansible \
    && mkdir -p /run/sshd \
    && printf 'PasswordAuthentication yes\nPermitRootLogin no\n' \
       > /etc/ssh/sshd_config.d/00-laboratorio.conf \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD ["sh", "-c", "ssh-keygen -A && exec /usr/sbin/sshd -D -e"]