# Base Image
ARG STRAPI_IMAGE=libre/strapi-live
ARG STRAPI_IMAGE_TAG=v3

FROM ${STRAPI_IMAGE}:${STRAPI_IMAGE_TAG} AS build
ARG DEPENDENCIES_FILE_PATH

ADD --chown=strapi:strapi ${DEPENDENCIES_FILE_PATH} /custom/package.json

RUN rm -rf build \
    && import-strapi \
        --from /custom \
        --package-only \
        --install

FROM libre/strapi:v3.6.8-n14 AS custom

COPY --from=build --chown=strapi:strapi ${APP_PATH} ${APP_PATH}
