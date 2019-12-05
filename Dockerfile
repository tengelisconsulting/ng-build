FROM node:10.15.3-alpine

WORKDIR /app

RUN apk --update add \
        git \
        openssh \
        && mkdir -p /app/output \
        && mkdir -p /app/repo \
        && mkdir -p /app/bin \
        && mkdir -p /app/npm-cache \
        && mkdir -p /home/node/.ssh \
        && chown -R node /app

USER node

RUN npm config set prefix '~/.npm' \
        && npm install -g @angular/cli

COPY ./bin /app/bin
COPY ./npmrc /home/node/.npmrc

VOLUME /app/output
VOLUME /app/repo
VOLUME /app/npm-cache
VOLUME /home/node/.ssh

ENV NPM_BUILD_CMD="prod"
ENV DIST_DIR_NAME="dist"

ENTRYPOINT [ "/app/bin/runner.sh" ]
