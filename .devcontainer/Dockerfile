ARG VARIANT="8"
FROM k1low/tbls:latest AS tbls
FROM mcr.microsoft.com/vscode/devcontainers/php:0-${VARIANT}

RUN . /etc/os-release \
    && echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-client libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli pdo pdo_mysql intl zip \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

## Setup nvm
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

## Install tbls
COPY --from=tbls /usr/bin/tbls /usr/local/bin/tbls

## Install CodeceptJS headless mode dependency packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libdbus-1-3 libatspi2.0-0 \
    libx11-6 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrandr2 libgbm1 libxcb1 libxkbcommon0 libpango-1.0-0 libcairo2 libasound2 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

## Install pict
RUN git clone https://github.com/microsoft/pict.git /usr/local/src/pict \
    && cd /usr/local/src/pict && make \
    && mv /usr/local/src/pict/pict /usr/local/bin/pict \
    && rm -fr /usr/local/src/pict

## Install d2
RUN curl -fsSL https://d2lang.com/install.sh | sh -s --

## Install developer omnibus tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends bash-completion tig git-flow direnv pre-commit silversearcher-ag ripgrep vim exa bat fd-find python3-pip graphviz plantuml fonts-ipafont fonts-ipaexfont fonts-noto-cjk \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite

## [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
