
#!/bin/sh

if [ -n "$WORKSPACE" ]; then
  sed -i "s#root /src;#root $WORKSPACE;#g" /etc/nginx/nginx.conf
  chown www-data.www-data -R $WORKSPACE /var/lib/nginx/tmp/
fi

php-fpm --force-stderr --daemonize
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi

nginx -g "daemon on;"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

while sleep 5; do
  ps aux |grep php-fpm |grep -q -v grep
  FPM_STATUS=$?
  ps aux |grep nginx |grep -q -v grep
  NGINX_STATUS=$?

  if [ $FPM_STATUS -ne 0 -o $NGINX_STATUS -ne 0 ]; then
    echo "[Process]One of the processes has already exited."
    exit 1
  fi
done

tail -f /dev/null