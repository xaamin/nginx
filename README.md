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
You must provide a volume mounted on **/shared** containing the same structure as shared directory

### Usage
See **shared** directory inside this repository for sample structure. You must link to [xaamin/php-fpm](xaamin/php-fpm) docker container named as **php-fpm**.
```	
	docker run -d --name nginx.server --restart always --link php-fpm:php-fpm -v /path/to/shared/path:/shared xaamin/nginx
```

To replace the default SSL certificate use the following command.
```
	docker exec -it nginx.dev bash /secure.sh
```
Or inside the container execute `/secure.sh` script and fill properly information.