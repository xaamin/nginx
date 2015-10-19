## Nginx
Docker container to run [NGINX](http://nginx.org/)

### Base docker image
* [xaamin/php](https://registry.hub.docker.com/r/xaamin/ubuntu)

### Installation
* Install [Docker](https://www.docker.com)
* Pull from [Docker Hub](https://hub.docker.com/r/xaamin/nginx) `docker pull xaamin/nginx`

### Manual build
* Build an image from Dockerfile `docker build -t xaamin/nginx https://github.com/xaamin/nginx.git`

### Volumes
You must provide a volume mounted on **/data** containing PHP projects inside **sites** directory

### Usage
See **data** directory inside this repository for sample structure. You must link to [xaamin/php-fpm](xaamin/php-fpm) docker container named as **php-fpm.box**.

```	
	docker run --rm -it --link php-fpm.box:php-fpm.box -v /path/to/php/projects:/data xaamin/nginx
```