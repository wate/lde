ARG VARIANT="8"
FROM k1low/tbls:latest AS tbls
FROM mcr.microsoft.com/devcontainers/php:1-${VARIANT}

RUN . /etc/os-release \
  && echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" > /etc/apt/sources.list.d/backports.list \
  && apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y --no-install-recommends mariadb-client libicu-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev \
  && apt-get install -y --no-install-recommends bash-completion build-essential gpg vim \
  && apt-get install -y --no-install-recommends imagemagick \
  && apt-get install -y --no-install-recommends fonts-ipaexfont fnt \
  && apt-get install -y --no-install-recommends pipx \
  && apt-get install -y --no-install-recommends direnv tig silversearcher-ag plantuml graphviz \
  && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

## Install php module
RUN docker-php-ext-install mysqli pdo pdo_mysql intl zip \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd

## Install node.js and package manager
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt-get install -y nodejs \
  && rm nodesource_setup.sh  \
  && rm /usr/bin/yarn /usr/bin/yarnpkg && rm -fr /usr/share/yarn \
  && npm i -g yarn @antfu/ni

## Install tbls
COPY --from=tbls /usr/bin/tbls /usr/local/bin/tbls

## Enable apache rewrite module
RUN a2enmod rewrite

## Install eza
RUN mkdir -p /etc/apt/keyrings \
  && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list \
  && chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list \
  && apt update \
  && apt install -y eza

## Install task
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

## Install pict
RUN git clone https://github.com/microsoft/pict.git /usr/local/src/pict \
    && cd /usr/local/src/pict && make \
    && mv /usr/local/src/pict/pict /usr/local/bin/pict \
    && rm -fr /usr/local/src/pict

## Install d2
RUN curl -fsSL https://d2lang.com/install.sh | sh -s --
