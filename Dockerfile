#FROM ubuntu:focal-20211006
#FROM registry.astralinux.ru/library/astra/ubi17:1.7.6
#FROM astra17prepare:latest
FROM astra17gitlab1:latest

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
    NODE_ENV=production \
    NODEJS_VERSION=16

ENV GITLAB_INSTALL_DIR="${GITLAB_HOME}/gitlab" \
    GITLAB_SHELL_INSTALL_DIR="${GITLAB_HOME}/gitlab-shell" \
    GITLAB_GITALY_INSTALL_DIR="${GITLAB_HOME}/gitaly" \
    GITLAB_DATA_DIR="${GITLAB_HOME}/data" \
    GITLAB_BUILD_DIR="${GITLAB_CACHE_DIR}/build" \
    GITLAB_RUNTIME_DIR="${GITLAB_CACHE_DIR}/runtime"


# RUN set -ex \
#     # Добавляем репозиторий Yarn
#     && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#     ## Обновление
#     && apt-get update \
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     # Утилиты и системные инструменты
#     curl supervisor logrotate locales tzdata unzip wget tar \
#     wget ca-certificates apt-transport-https gnupg2 yarn zlib1g-dev redis-tools libkrb5-dev \
#     # Веб-сервер и SSH
#     && apt-get install --no-install-recommends -y \
#     nginx openssh-server \
#     # Основные языки и инструменты разработки
#     && apt-get install --no-install-recommends -y \
#     git-core python3 python3-docutils gettext-base graphicsmagick \
#     # Библиотеки для Ruby и компиляции
#     && apt-get install --no-install-recommends -y \
#     gcc g++ make patch pkg-config cmake autoconf bison build-essential \
#     # Системные библиотеки (OpenSSL, Zlib, Readline, ICU и другие)
#     && apt-get install --no-install-recommends -y \
#     libssl-dev libyaml-dev libgdbm-dev libreadline-dev libncurses5-dev \
#     libffi-dev libxml2-dev libxslt1.1 libcurl4-openssl-dev libre2-dev \
#     libicu-dev libmagic1 libimage-exiftool-perl libdb-dev \
#     # PostgreSQL
#     # && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
#     # && echo 'deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
#     # && apt update \
#     # && apt-get install --no-install-recommends -y  postgresql-client \
#     # Установка Pax из внешних источников
#     && wget http://pax.grsecurity.net/paxctl-0.9.tar.gz  \
#     && tar -xvzf paxctl-0.9.tar.gz && cd paxctl-0.9 && make install  && cd ..  \
#     #  Настройка локали
#     && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
#     && locale-gen en_US.UTF-8 \
#     && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
#     # Установка gosu
#     && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64" \
#     && chmod +x /usr/local/bin/gosu \
#     # Добавление репозитория nodeJS и настройка приоритетов
#     && curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
#     &&  echo -e "Package: nodejs\nPin: origin \"deb.nodesource.com\"\nPin-Priority: 1000" | tee /etc/apt/preferences.d/99nodesource \
#     && apt-get update && apt-get install --no-install-recommends -y nodejs \
#     # Очистка
#     && rm -rf paxctl-0.9* &&  rm -rf /var/lib/apt/lists/*

COPY assets/build/ ${GITLAB_BUILD_DIR}/
RUN bash ${GITLAB_BUILD_DIR}/install.sh
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