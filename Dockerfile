FROM xaamin/ubuntu

MAINTAINER "Benjamín Martínez Mateos" <bmxamin@gmail.com>

# Install Nginx
RUN add-apt-repository -y ppa:nginx/stable \
	&& apt-get -y update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y install nginx \
		libfcgi0ldbl \
	
	# Remove temp files	
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add bootstrap file
ADD start.sh /start.sh

# Add script to secure Nginx Installation with new SSL certificate
ADD secure.sh /secure.sh

# Add supervisor config file
ADD supervisord.conf /etc/supervisor/supervisord.conf

# Define mountable directories
VOLUME ["/shared"]

# Define working directory
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80 443

# Define default command.
CMD ["/bin/bash", "/start.sh"]