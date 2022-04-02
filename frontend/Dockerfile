# Base Image
ARG BASE_IMAGE=libre/strapi-base
ARG BASE_IMG_TAG=node-14

FROM node:14-alpine AS base

RUN npm install -g msw


# ----| SOURCE |----
# Get Source Files from Git Repository (using gget)
FROM libre/gget AS source

ARG GITHUB_TOKEN_FILE_PATH
ARG SECRET_NAME=github_token
ARG APP_REPO_URL
ARG APP_REPO_BRANCH
ARG GITHUB_USER_NAME

ADD ${GITHUB_TOKEN_FILE_PATH} /run/secrets/${SECRET_NAME}

WORKDIR /src

RUN gget ${APP_REPO_URL} \
    --branch ${APP_REPO_BRANCH} \
    --secret ${SECRET_NAME} \
    --user ${GITHUB_USER_NAME}


# ----| INSTALL |----
# Picks Package.json (only) to Install Dependencies
FROM base AS install

WORKDIR /src

COPY --from=source /src/package.json .

RUN yarn


# ----| TESTS |----
# Target Stage to build the ":tests" Image
FROM install AS tests

COPY --from=source /src/ .

ENTRYPOINT [ "yarn", "test" ]


# ----| BUILD |----
# Builds final/target static files to serve
FROM install AS build

COPY --from=source /src/ .

RUN yarn build


# ----| SERVER |----
# Result Image to serve static files as a website with NginX
FROM nginx:1.19.7-alpine AS server

COPY frontend/docker-entrypoint.sh /usr/local/bin/entrypoint

RUN apk add --no-cache bash \
    && chmod +x /usr/local/bin/entrypoint

COPY --chown=nginx:nginx frontend/nginx.conf /tmp/template.conf

COPY --from=build --chown=nginx:nginx /src/build/ /var/www/html/

EXPOSE 8080

HEALTHCHECK CMD curl --head --silent --fail 0.0.0.0:8080/health-check || exit 1 \
    --interval=36s \
    --timeout=6s \
    --start-period=6s \
    --retries=3

ENTRYPOINT entrypoint
