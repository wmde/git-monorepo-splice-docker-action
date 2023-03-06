FROM python:3.8-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git git-fast-import openssh

RUN pip3 install git-filter-repo

# T314987: /github/workspace is not owned by the same user
RUN git config --system --add safe.directory /github/workspace

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]