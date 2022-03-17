# Base Image
ARG STRAPI_IMAGE=libre/strapi
ARG STRAPI_IMAGE_TAG=latest
FROM ${STRAPI_IMAGE}:${STRAPI_IMAGE_TAG} AS base


# Build Stage
FROM base AS import-build

ARG GITHUB_TOKEN_FILE_PATH
ARG SECRET_NAME=github_token
ARG STRAPI_TEMPLATE_URL

ADD ${GITHUB_TOKEN_FILE_PATH} /run/secrets/${SECRET_NAME}

RUN import-strapi ${STRAPI_TEMPLATE_URL} \
    --secret ${SECRET_NAME} \
    --install


# Final Stage
FROM base AS final

COPY --from=import-build \
    --chown=strapi:strapi \
    /srv/app /srv/app
