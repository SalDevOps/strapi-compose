#!/bin/bash

PUBLIC_IP=$(curl -s ifconfig.me)
echo "Starting nginx in $PUBLIC_IP"

# To be used to isolate the /admin routes:
export  NG_FRONTEND_DOMAIN="${NG_FRONTEND_DOMAIN:-localhost}" \
        NG_BACKEND_DOMAIN="${NG_FRONTEND_DOMAIN:-$NG_FRONTEND_DOMAIN}" \
        NG_LOG_REWRITES="${NG_LOG_REWRITES:-0}" \
        NG_LOG_HEALTH_CHECKS="${NG_LOG_HEALTH_CHECKS:-0}"

# All Strapi Admin related URLs (as per in upstream.ini file)
export  NG_BACKEND_URLS='('"$(grep -vE '^[ #]+|^$' upstream.ini | xargs | sed -e 's/ /|/g')"')'
echo "Found Backend URLs ${NG_BACKEND_URLS}"

# Only Environment variables starting with API_ or NG_ will be exported/replaced in nginx config file:
export  NGINX_ENV="$(compgen -A variable | grep -E '(API|NG)_' | sed -e 's/^/$/' | xargs | sed -e 's/ / /g')"
echo "Replacing Environment Variables ${NGINX_ENV}"
envsubst "$NGINX_ENV" \
    < /tmp/template.conf \
    > /etc/nginx/conf.d/default.conf
# cat /etc/nginx/conf.d/default.conf

echo "✅ NGINX Engines Ready"
nginx -g 'daemon off;'
