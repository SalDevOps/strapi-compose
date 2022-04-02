# Base Image
ARG STRAPI_IMAGE=libre/strapi-live
ARG STRAPI_IMAGE_TAG=v3
ARG STRAPI_BASE_TAG=v3.6.8-n14
ARG STRAPI_TEMPLATE_SUBDIR=template

# Build Stage
FROM ${STRAPI_IMAGE}:${STRAPI_IMAGE_TAG} AS build

ARG GITHUB_TOKEN_FILE_PATH
ARG GITHUB_USER_NAME
ARG SECRET_NAME=github_token
ARG STRAPI_TEMPLATE_URL
ARG STRAPI_TEMPLATE_BRANCH
ARG STRAPI_TEMPLATE_SUBDIR
ARG STRAPI_TEMPLATE_EXTRAS

USER root

ADD ${GITHUB_TOKEN_FILE_PATH} /run/secrets/${SECRET_NAME}

RUN rm -rf build

RUN import-strapi ${STRAPI_TEMPLATE_URL} \
    --branch ${STRAPI_TEMPLATE_BRANCH} \
    --secret ${SECRET_NAME} \
    --user ${GITHUB_USER_NAME} \
    --subdir ${STRAPI_TEMPLATE_SUBDIR} \
    --extra-dirs ${STRAPI_TEMPLATE_EXTRAS} \
    --build

# Final Stage
FROM libre/strapi:${STRAPI_BASE_TAG} AS final

COPY --from=build   --chown=strapi:strapi \
                    ${APP_PATH} ${APP_PATH}

VOLUME [ "${APP_PATH}/public" ]

EXPOSE 1337

HEALTHCHECK CMD curl -I 0.0.0.0:1337/_health || exit 1 \
    --interval=36s \
    --timeout=6s \
    --start-period=6s \
    --retries=3

CMD [ "start" ]
