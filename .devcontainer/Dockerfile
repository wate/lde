# [Choice] PHP version (use -bullseye variants on local arm64/Apple Silicon): 8, 8.1, 8.0, 7, 7.4, 7.3, 8-bullseye, 8.1-bullseye, 8.0-bullseye, 7-bullseye, 7.4-bullseye, 7.3-bullseye, 8-buster, 8.1-buster, 8.0-buster, 7-buster, 7.4-buster
ARG VARIANT=8-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

RUN . /etc/os-release \
    && echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y -t ${VERSION_CODENAME}-backports mariadb-client libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev golang \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql intl zip \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# Install tbls
RUN go install github.com/k1LoW/tbls@main \
    && mv ~/go/bin/tbls /usr/local/bin/tbls \
    && rm -fr ~/go

# Install pict
RUN git clone https://github.com/microsoft/pict.git /usr/local/src/pict \
    && cd /usr/local/src/pict && make \
    && mv /usr/local/src/pict/pict /usr/local/bin/pict \
    && rm -fr /usr/local/src/pict

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends bash-completion tig git-flow direnv pre-commit silversearcher-ag vim exa bat fd-find python3-pip graphviz plantuml fonts-ipafont fonts-ipaexfont fonts-noto-cjk \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
