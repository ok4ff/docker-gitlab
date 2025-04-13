#FROM ubuntu:focal-20211006
#FROM registry.astralinux.ru/library/astra/ubi18:1.8
FROM astra18prepare:latest

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
#     && apt-get update \
#     # Инструменты для подключения и распаковки зависимостей
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     wget curl ca-certificates unzip tar \
#     && mkdir -p /etc/apt/keyrings \
#     # Добавляем репозиторий Yarn
#     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor --batch > /etc/apt/keyrings/yarn.gpg \
#     && echo "deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list \
#     # Добавляем репозиторий postgres
#     && install -d /usr/share/postgresql-common/pgdg \
#     && curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc \
#     && echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
#     # Добавляем репозиторий nodejs
#     && wget -qO - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor --batch > /etc/apt/trusted.gpg.d/nodesource.gpg \
#     && echo "deb https://deb.nodesource.com/node_${NODEJS_VERSION}.x bookworm main" > /etc/apt/sources.list.d/nodesource.list \
#     && apt-get update \
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     # Утилиты и системные инструменты
#     supervisor logrotate locales tzdata \
#     wget ca-certificates apt-transport-https gnupg2 yarn zlib1g-dev libkrb5-dev \
#     # Установка ruby version manager
#     && gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#     && curl -sSL https://get.rvm.io | bash -s stable \
#     && usermod -a -G rvm root \
#     && echo "[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm" >> ~/.bashrc \
#     && rvm install ${RUBY_VERSION} \
#     # Установка gosu
#     && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64" && \
#     chmod +x /usr/local/bin/gosu \
#     # Инструментарий для работы с базами данных и кешем
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     redis-tools postgresql-client-12 postgresql-server-dev-12 \
#     # postgresql-contrib-12  - нету для debian12 !!!!! \
#     # Веб-сервер и SSH
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     nginx openssh-server \
#     # Основные языки и инструменты разработки
#     && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
#     git-core python3 python3-docutils gettext-base graphicsmagick \
#     # Библиотеки для Ruby и компиляции
#     && DEBIAN_FRONTEND=noninteractive  apt-get install --no-install-recommends -y \
#     gcc g++ make patch pkg-config cmake autoconf bison build-essential \
#     # Системные библиотеки (OpenSSL, Zlib, Readline, ICU и другие)
#     && DEBIAN_FRONTEND=noninteractive  apt-get install --no-install-recommends -y \
#     libssl-dev libyaml-dev libgdbm-dev libreadline-dev libncurses5-dev \
#     libffi-dev libxml2-dev libxslt1.1 libcurl4-openssl-dev libre2-dev \
#     libicu-dev libmagic1 libimage-exiftool-perl libdb-dev \
#     # Установка Pax из внешних источников
#     && wget http://pax.grsecurity.net/paxctl-0.9.tar.gz  \
#     && tar -xvzf paxctl-0.9.tar.gz && cd paxctl-0.9 && make install  && cd ..  \
#     #  Настройка локали
#     && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
#     && locale-gen en_US.UTF-8 \
#     && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales \
#     # Добавление репозитория nodeJS и настройка приоритетов
#     &&  echo -e "Package: nodejs\nPin: origin \"deb.nodesource.com\"\nPin-Priority: 1000"  > /etc/apt/preferences.d/99nodesource \
#     && apt-get update && DEBIAN_FRONTEND=noninteractive  apt-get install --no-install-recommends -y nodejs \
#     # Очистка
#     && rm -rf paxctl-0.9* &&  rm -rf /var/lib/apt/lists/*

COPY assets/build/ ${GITLAB_BUILD_DIR}/
RUN bash ${GITLAB_BUILD_DIR}/install.sh
COPY assets/runtime/ ${GITLAB_RUNTIME_DIR}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
ARG BUILD_DATE
ARG VCS_REF
LABEL \
    maintainer="sameer@damagehead.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name=gitlab \
    org.label-schema.vendor=damagehead \
    org.label-schema.url="https://github.com/sameersbn/docker-gitlab" \
    org.label-schema.vcs-url="https://github.com/sameersbn/docker-gitlab.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    com.damagehead.gitlab.license=MIT
EXPOSE 22/tcp 80/tcp 443/tcp
VOLUME ["${GITLAB_DATA_DIR}", "${GITLAB_LOG_DIR}","${GITLAB_HOME}/gitlab/node_modules"]
WORKDIR ${GITLAB_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]