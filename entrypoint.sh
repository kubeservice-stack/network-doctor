#!/bin/sh

WEB_ROOT=/usr/share/nginx/html
MOUNT_CHECK=$(mount | grep ${WEB_ROOT})
HOSTNAME=$(hostname)

if [ -z "${MOUNT_CHECK}" ] ; then
  echo "The directory ${WEB_ROOT} is not mounted."
  echo "Therefore, over-writing the default index.html file with some useful information:"

  CONTAINER_IP=$(ip -j route get 1 | jq -r '.[0] .prefsrc')

  echo -e "WBITT Network MultiTool (with NGINX) - ${HOSTNAME} - ${CONTAINER_IP} - HTTP: ${HTTP_PORT:-80} , HTTPS: ${HTTPS_PORT:-443} . (Formerly praqma/network-multitool)" | tee  ${WEB_ROOT}/index.html 
else
  echo "The directory ${WEB_ROOT} is a volume mount."
  echo "Therefore, will not over-write index.html"
  echo "Only logging the container characteristics:"
  echo -e "WBITT Network MultiTool (with NGINX) - ${HOSTNAME} - ${CONTAINER_IP} - HTTP: ${HTTP_PORT:-80} , HTTPS: ${HTTPS_PORT:-443} . (Formerly praqma/network-multitool)"

fi


if [ -n "${HTTP_PORT}" ]; then
  echo "Replacing default HTTP port (80) with the value specified by the user - (HTTP_PORT: ${HTTP_PORT})."
  sed -i "s/80/${HTTP_PORT}/g"  /etc/nginx/nginx.conf
fi

if [ -n "${HTTPS_PORT}" ]; then
  echo "Replacing default HTTPS port (443) with the value specified by the user - (HTTPS_PORT: ${HTTPS_PORT})."
  sed -i "s/443/${HTTPS_PORT}/g"  /etc/nginx/nginx.conf
fi


# Execute the command specified as CMD in Dockerfile:
exec "$@"