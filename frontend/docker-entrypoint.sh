#!/usr/bin/env bash

ENV_VARS_PREFIX=${ENV_VARS_PREFIX:-"NG_"}
CONFIG_TEMPLATE=${CONFIG_TEMPLATE:-/tmp/template.conf}

prepare_config() {
    # Only Environment variables starting with $ENV_VARS_PREFIX will be exported/replaced in nginx config file:
    export  NGINX_ENV="$(compgen -A variable | grep -E "${ENV_VARS_PREFIX}" | sed -e 's/^/$/' | xargs | sed -e 's/ / /g')"
    echo "Replacing Environment Variables ${NGINX_ENV}"
    envsubst "$NGINX_ENV" \
        < ${CONFIG_TEMPLATE} \
        > /etc/nginx/conf.d/default.conf
}

start_nginx() {
    prepare_config
    echo "✅ Starting to Serve FrontEnd app with NGINX..."
    nginx -g 'daemon off;'
}

# Start NginX by default (if no command has been requested)
# otherwise, try directly running the requested command/parameters
[[ -z "$1" ]] && start_nginx || exec "$@"
