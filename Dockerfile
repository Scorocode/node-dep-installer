FROM node:11.1-alpine

# https://github.com/nodejs/docker-node#nodealpine
RUN apk add --no-cache curl libc6-compat make g++

RUN apk add --no-cache python && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip install --upgrade pip setuptools && \
    rm -r /root/.cache

ENV PYTHON=/usr/bin/python2

RUN npm -g config set user root
RUN npm install -g yarn && \
    npm i -g node-pre-gyp && \
    npm i -g node-gyp && \
    npm i -g grpc --build-from-source

# fix error: Unhandled rejection Error: EACCES: permission denied, mkdir '/.npm'
ENV HOME=/var/data/project
ENV UV_THREADPOOL_SIZE=128

WORKDIR /var/data/project

COPY entrypoint.sh  /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
