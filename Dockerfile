FROM node:10.15.3-alpine
WORKDIR /app
RUN apk --update add \
        git \
        openssh
RUN npm config set prefer-offline true \
        && npm config set cache /app/npm-cache \
        && npm install -g @angular/cli
COPY ./bin /app/bin
VOLUME /app/output
VOLUME /app/repo
VOLUME /app/npm-cache
VOLUME /root/.ssh
ENV NPM_BUILD_CMD="prod"
ENV DIST_DIR_NAME="dist"
ENTRYPOINT [ "/app/bin/runner.sh" ]
