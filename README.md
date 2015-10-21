## Nginx
Docker container to run [NGINX](http://nginx.org/)

### Base docker image
* [xaamin/ubuntu](https://registry.hub.docker.com/r/xaamin/ubuntu)

### Installation
* Install [Docker](https://www.docker.com)
* Pull from [Docker Hub](https://hub.docker.com/r/xaamin/nginx) `docker pull xaamin/nginx`

### Manual build
* Build an image from Dockerfile `docker build -t xaamin/nginx https://github.com/xaamin/nginx.git`

### Volumes
You must provide a volume mounted on **/data** containing the same structure as data directory

### Usage
See **data** directory inside this repository for sample structure. You must link to [xaamin/php-fpm](xaamin/php-fpm) docker container named as **php-fpm**.
```	
	docker run --rm -it --link php-fpm.box:php-fpm xaamin/nginx
```

To replace the default SSL certificate use the following on Linux's terminal.
```
	sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(pdw)/data/ssl/nginx.key -out $(pdw)/data/ssl/nginx.crt
```
Or inside the container execute `/secure.bash` script and fill properly information.