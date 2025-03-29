#FROM ubuntu:focal-20211006
FROM registry.astralinux.ru/library/astra/ubi17:1.7.6

ARG VERSION=14.4.3

ENV GITLAB_VERSION=${VERSION} \
    RUBY_VERSION=2.7.4 \
    RUBY_SOURCE_SHA256SUM="3043099089608859fc8cce7f9fdccaa1f53a462457e3838ec3b25a7d609fbc5b" \
    GOLANG_VERSION=1.17.4 \
    GITLAB_SHELL_VERSION=13.21.1 \
    GITLAB_PAGES_VERSION=1.46.0 \
    GITALY_SERVER_VERSION=14.4.3 \
    GITLAB_USER="git" \
    GITLAB_HOME="/home/git" \
    GITLAB_LOG_DIR="/var/log/gitlab" \
    GITLAB_CACHE_DIR="/etc/docker-gitlab" \
    RAILS_ENV=production \
    NODE_ENV=production

ENV GITLAB_INSTALL_DIR="${GITLAB_HOME}/gitlab" \
    GITLAB_SHELL_INSTALL_DIR="${GITLAB_HOME}/gitlab-shell" \
    GITLAB_GITALY_INSTALL_DIR="${GITLAB_HOME}/gitaly" \
    GITLAB_DATA_DIR="${GITLAB_HOME}/data" \
    GITLAB_BUILD_DIR="${GITLAB_CACHE_DIR}/build" \
    GITLAB_RUNTIME_DIR="${GITLAB_CACHE_DIR}/runtime"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    wget ca-certificates apt-transport-https gnupg2
    # && rm -rf /var/lib/apt/lists/* - включить для сокращения размера образа

RUN set -ex \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    curl sudo supervisor logrotate locales \
    nginx openssh-server \
    postgresql-client postgresql-contrib redis-tools \
    git-core python3 python3-docutils nodejs gettext-base graphicsmagick \
    libpq5 zlib1g libyaml-0-2 libssl1.1 \
    libgdbm6  libncurses5  \
    libxml2 libxslt1.1 libcurl4 libre2-dev tzdata unzip libimage-exiftool-perl \
    libmagic1 yarn \
    libreadline-dev libffi-dev libicu-dev \
    && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
    && locale-gen en_US.UTF-8 \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
    # && rm -rf /var/lib/apt/lists/* - включить для сокращения размера образа
RUN set -ex \
    && apt-get install \
    gcc g++ make patch pkg-config cmake paxctl \
    libc6-dev \
    libpq-dev zlib1g-dev libyaml-dev libssl-dev \
    libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
    libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
    gettext libkrb5-dev
# COPY assets/build/ ${GITLAB_BUILD_DIR}/
# RUN bash ${GITLAB_BUILD_DIR}/install.sh
# COPY assets/runtime/ ${GITLAB_RUNTIME_DIR}/
# COPY entrypoint.sh /sbin/entrypoint.sh
# RUN chmod 755 /sbin/entrypoint.sh
# ARG BUILD_DATE
# ARG VCS_REF
# LABEL \
#     maintainer="sameer@damagehead.com" \
#     org.label-schema.schema-version="1.0" \
#     org.label-schema.build-date=${BUILD_DATE} \
#     org.label-schema.name=gitlab \
#     org.label-schema.vendor=damagehead \
#     org.label-schema.url="https://github.com/sameersbn/docker-gitlab" \
#     org.label-schema.vcs-url="https://github.com/sameersbn/docker-gitlab.git" \
#     org.label-schema.vcs-ref=${VCS_REF} \
#     com.damagehead.gitlab.license=MIT
# EXPOSE 22/tcp 80/tcp 443/tcp
# VOLUME ["${GITLAB_DATA_DIR}", "${GITLAB_LOG_DIR}","${GITLAB_HOME}/gitlab/node_modules"]
# WORKDIR ${GITLAB_INSTALL_DIR}
# ENTRYPOINT ["/sbin/entrypoint.sh"]
# CMD ["app:start"]