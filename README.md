<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [php_docker_basic](#php_docker_basic)
  - [一、服务相关](#%E4%B8%80%E6%9C%8D%E5%8A%A1%E7%9B%B8%E5%85%B3)
  - [二、服务迁移相关](#%E4%BA%8C%E6%9C%8D%E5%8A%A1%E8%BF%81%E7%A7%BB%E7%9B%B8%E5%85%B3)
    - [2.1 首先需要确认php相关配置](#21-%E9%A6%96%E5%85%88%E9%9C%80%E8%A6%81%E7%A1%AE%E8%AE%A4php%E7%9B%B8%E5%85%B3%E9%85%8D%E7%BD%AE)
  - [三、说明：](#%E4%B8%89%E8%AF%B4%E6%98%8E)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# php_docker_basic
php服务迁移，docker 基础镜像 主要使用nginx+php-fpm 启动的服务



## 一、服务相关

编译镜像

```shell
docker build -t php-test .
docker build -t php-test:v1.0 .

# 指定编译的平台
docker build --platform linux/x86_64 -t php-test:v1.0 .
```

防止镜像退出的小命令(在shell脚本中增加)

```
tail -f /dev/null
```

nginx 相关命令

```shell
# nginx重启
/usr/sbin/nginx -c /etc/nginx/nginx.conf -s reload

# 检测nginx配置文件是否有问题
/usr/sbin/nginx -t
```



## 二、服务迁移相关

### 2.1 首先需要确认php相关配置

迁移相关,查看原有linux环境安装的依赖包
通过**pear list 和 pecl list**
安装相关依赖

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

查找php的配置文件php.ini

```
php --ini |grep Loaded
日志文件的名字
error_log = php_errors.log
是否打开日志
log_errors = On
```



## 三、说明：



1、nginx的配置文件nginx.conf和nginx-v2.conf都可以正常使用

2、因为要迁移的服务php版本比较低，所以如果使用高版本可以参考php7文件夹下面的docker镜像


安装radius扩展并不需要配置，只需要在Dockerfile中安装好radius扩展即可。以下是一个示例Dockerfile：

FROM php:7.4-fpm
RUN apt-get update \
    && apt-get install -y libssl-dev \
    && pecl install radius \
    && docker-php-ext-enable radius
这个Dockerfile中，我们先安装了libssl-dev，这是radius扩展所需要的依赖包。然后使用pecl命令安装radius扩展，并使用docker-php-ext-enable命令启用该扩展。

注意：radius扩展需要在php.ini中配置radius服务器的IP地址和端口号。可以在运行容器时通过 -e 参数设置环境变量，例如：

复制
docker run -e RADIUS_SERVER=192.168.0.1 -e RADIUS_PORT=1812 my-php-app
在PHP代码中，可以使用 radius_config() 函数来配置radius服务器信息，例如：

复制
$radius_config = array(
    'host' => $_ENV['RADIUS_SERVER'],
    'port' => $_ENV['RADIUS_PORT'],
    'secret' => 'myradiussecret',
);
radius_config($radius_config);