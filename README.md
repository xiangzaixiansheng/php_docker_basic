# php_docker_basic
php服务迁移，docker 基础镜像 主要使用nginx+php-fpm 启动的服务



编译镜像

```shell
docker build -t php-test .
```

防止镜像退出的小命令

```
tail -f /dev/null
```

nginx 相关命令

```shell
# nginx重启
/usr/sbin/nginx -c /etc/nginx/nginx.conf -s reload
```

查找php的配置文件php.ini

```
php --ini |grep Loaded
```



dockerFile相关

```shell
# 安装扩展
RUN docker-php-ext-install bcmath bz2 calendar exif gd gettext intl \
    mysqli opcache pdo pdo_mysql readline sockets tidy

#docker-php-ext-enable的主要用途是生成扩展相应的配置文件到 /usr/local/etc/php/conf.d/docker-php-ext-{extName}.ini 方便 php 加载扩展。

RUN pecl install redis-3.1.5 && \
    pecl install memcached-3.0.4 && \
    pecl install mcrypt-1.0.1 && \
    pecl install zlib zip && \
    pecl install radius-1.3.0 && \
    docker-php-ext-enable redis memcached zip mcrypt
```



nginx的配置文件

nginx.conf和nginx-v2.conf都可以正常使用