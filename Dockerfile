FROM xaamin/ubuntu:20.04

MAINTAINER "Benjamín Martínez Mateos" <xaamin@outlook.com>

# Install Nginx
RUN cd /tmp/ \
    && wget http://nginx.org/keys/nginx_signing.key \
    && DEBIAN_FRONTEND=noninteractive apt-key add nginx_signing.key \
    && rm -f nginx_signing.key \
    && sh -c "echo 'deb http://nginx.org/packages/ubuntu/ '$(lsb_release -cs)' nginx' > /etc/apt/sources.list.d/nginx.list" \
    && sh -c "echo 'deb-src http://nginx.org/packages/ubuntu/ '$(lsb_release -cs)' nginx' >> /etc/apt/sources.list.d/nginx.list" \
    && apt -y update \
    && DEBIAN_FRONTEND=noninteractive apt -y install \
        nginx \
        libfcgi0ldbl \
    # Remove temp files
    && apt clean \
    && apt -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add bootstrap file
ADD /root/scripts /root/scripts

# Add supervisor config file
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Define working directory
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80 443

# Define default command.
CMD ["/bin/bash", "/root/scripts/bootstrap.sh"]