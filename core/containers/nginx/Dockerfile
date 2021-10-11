FROM nginxproxymanager/nginx-full

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /var/cache/nginx/client_temp