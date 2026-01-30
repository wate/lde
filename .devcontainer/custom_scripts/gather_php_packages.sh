#!/usr/bin/env bash

set -eo pipefail

PHP_VERSIONS=($(apt-cache pkgnames php | grep -oP 'php\K[0-9]+\.[0-9]+' | sort -Vu))

for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    {
        echo "PHP ${PHP_VERSION}"
        echo "-------------------------"
        echo ""
        apt-cache search "php${PHP_VERSION}-" | grep -v dbgsym
        echo ""
    } >>php_package.md
done
