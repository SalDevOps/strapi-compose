#!/bin/bash
PUBLIC_IP=$(curl -s ifconfig.me)
echo "Starting nginx in $PUBLIC_IP"
LOG_REWRITES="${LOG_REWRITES:-0}" \
LOG_HEALTH_CHECKS="${LOG_HEALTH_CHECKS:-0}" \
FRONTEND_HOST="${FRONTEND_HOST:-localhost}" \
BACKEND_HOST="${FRONTEND_HOST:-$FRONTEND_HOST}" \
envsubst '$API_SERVER_ADDR $API_SERVER_PORT $LOG_REWRITES $LOG_HEALTH_CHECKS $FRONTEND_HOST $BACKEND_HOST' \
        < /tmp/template.conf \
        > /etc/nginx/conf.d/default.conf \
    && echo "Starting nginx engine with following config" \
    && cat /etc/nginx/conf.d/default.conf \
    && nginx -g 'daemon off;'
