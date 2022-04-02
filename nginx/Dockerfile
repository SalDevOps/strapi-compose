FROM nginx:1.19.7-alpine

# Add bash for boot cmd
RUN apk add bash

# Add default nginx.conf to container
COPY --chown=nginx:nginx default.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx upstream.ini start /app/

# set workdir
WORKDIR /app

# permissions and nginx user for tightened security
RUN chown -R nginx:nginx /app && chmod -R 755 /app && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chmod -R 755 /var/log/nginx; \
        chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && chown -R nginx:nginx /var/run/nginx.pid

USER nginx

HEALTHCHECK CMD curl --head --silent --fail 0.0.0.0:8080/health-check || exit 1 \
    --interval=36s \
    --timeout=6s \
    --start-period=6s \
    --retries=3

CMD ["/app/start"]
