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

First, run a PHP5 FPM container
```
    docker run -d --name example.dev --restart always -v ./shared/accounts/example.dev:/shared/accounts/example.dev xaamin/php-fpm
```

See **shared** directory inside this repository for sample structure. You must link to [xaamin/php-fpm](xaamin/php-fpm) docker container.
```
    docker run -d --name nginx.web --restart always --link example.dev -v ./shared:/shared xaamin/nginx
```

To replace the default SSL certificate use the following command.
```
    docker exec -it nginx.dev bash /secure.sh
```
Or inside the container execute `/secure.sh` script and fill properly information.

### Test PHP5 FPM upstream

```
    docker exec -it nginx.dev bash bash

    # Inside de container terminal issue

    SCRIPT_FILENAME=/shared/accounts/example.dev/www/index.php QUERY_STRING=VAR1 DOCUMENT_ROOT=/shared/accounts/example.dev/www REQUEST_METHOD=GET cgi-fcgi -bind -connect example.dev:9000
```

### Create new sites

You must need openssl installed locally. This scripts only runs in Linux and MacOS, if you are a windows user you should enter to your nginx container to create a site

```bash
# Lunux and MacOS
bash scripts/create-site.sh
````

```bash
# Windows
docker exec -it nginx bash /shared/scripts/create-site.sh
```
# Using docker composer

```
export HOST_USER_ID=$(id -u $(whoami)) && export HOST_GROUP_ID=$(id -g $(whoami)) && docker-compose up -d
```
