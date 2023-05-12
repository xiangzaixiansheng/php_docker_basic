# php_docker_basic
php服务迁移，docker 基础镜像



docker build -t php-test .


user  nginx;
启动nginx需要 useradd -s /sbin/nologin -M nginx
是出于安全性考虑，还是用独立权限的账户运行（root权限太大，web渗透的时候可利用的机会太多了）




nginx -c /etc/nginx/nginx.conf -s reload


查找 php的ini配置文件 php.ini
php --ini |grep Loaded