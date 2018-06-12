# 9000 - nginx
# 9001 - websocketify
# 5901 - tigervnc

# based on ubuntu 16.04 LTS
FROM ubuntu:xenial
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    USER_PASSWD='' \
    DEBIAN_FRONTEND=noninteractive

RUN groupadd user && useradd -m -g user user

ADD https://bintray.com/artifact/download/tigervnc/stable/ubuntu-16.04LTS/amd64/tigervncserver_1.7.1-1ubuntu1_amd64.deb /tmp/tigervnc.deb

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        python git \
        ca-certificates wget curl locales \
        sudo nginx xterm jq \
        xorg openbox supervisor vim && \
    # tigervnc
    (dpkg -i /tmp/tigervnc.deb || apt-get -f -y install) && \
    locale-gen en_US.UTF-8 && \
    # novnc
    mkdir -p /app/src && \
    git clone --depth=1 https://github.com/novnc/noVNC.git /app/src/novnc && \
    git clone --depth=1 https://github.com/novnc/websockify.git /app/src/websockify && \
    apt-get autoremove -y && \
    apt-get clean

# copy files
COPY files/supervisord.conf /etc/supervisord.conf
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/passwd /home/user/.vnc/passwd
COPY files/start.sh /start.sh

RUN mkdir -p /etc/vnc && echo 'openbox-session' > /etc/vnc/xstartup \
 && chmod 0600 /home/user/.vnc/passwd && chown -R user: /home/user/.vnc

RUN sed -i 's|<div id="noVNC_status_bar">|<div id="noVNC_status_bar" style="display:none;">|g' /app/src/novnc/vnc_lite.html

EXPOSE 9000

CMD ["/usr/bin/supervisord","-j","/tmp/supervisord.pid","-l","/home/user/supervisord.log","-c","/etc/supervisord.conf"]
