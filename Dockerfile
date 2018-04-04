FROM xaamin/ubuntu:16.04

MAINTAINER "Benjamín Martínez Mateos" <xaamin@outlook.com>

# Install Nginx
RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
        nginx \
        libfcgi0ldbl \
    # Remove temp files
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add bootstrap file
ADD /root/.scripts /root/.scripts

# Add supervisor config file
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Define mountable directories
VOLUME ["/shared"]

# Define working directory
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80 443

# Define default command.
CMD ["/bin/bash", "/root/.scripts/bootstrap.sh"]