FROM alpine:3.15

MAINTAINER dongjiang (dongjiang1989@126.com)

EXPOSE 80 443 1180 11443

RUN     apk update \
    &&  apk add bash bind-tools busybox-extras curl \
                iproute2 iputils jq mtr \
                net-tools nginx openssl \
                perl-net-telnet procps tcpdump tcptraceroute wget util-linux \
    &&  mkdir /certs /docker \
    &&  chmod 700 /certs \
    &&  openssl req \
        -x509 -newkey rsa:2048 -nodes -days 3650 \
        -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY index.html /usr/share/nginx/html/


COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /docker/entrypoint.sh


CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

ENTRYPOINT ["/bin/sh", "/docker/entrypoint.sh"]
