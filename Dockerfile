FROM dikunix/docker-gitlab-runner-alpine:latest

MAINTAINER Oleks <oleks@oleks.info>

USER root

###
# Source: https://github.com/frol/docker-alpine-glibc
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Vlad
###
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

ENV LANG=C.UTF-8
###

###
# Original Source: https://github.com/DIKUNIX/docker-alpine-mono
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Vlad
# Copyright (c) 2017 DIKU
###
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar xz && \
    wget "https://www.archlinux.org/packages/extra/x86_64/mono/download/" -O "/tmp/mono.pkg.tar.xz" && \
    tar -xJf "/tmp/mono.pkg.tar.xz" -C / && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies && \
    rm /tmp/*
###

# Install gtk-sharp similarly to mono:
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar xz && \
    wget "https://www.archlinux.org/packages/extra/x86_64/gtk-sharp-2/download/" -O "/tmp/gtk.pkg.tar.xz" && \
    tar -xJf "/tmp/gtk.pkg.tar.xz" -C / && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies && \
    rm /tmp/*

# Install monodevelop similarly to mono and gtk-sharp:
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar xz && \
    wget "https://www.archlinux.org/packages/extra/x86_64/monodevelop/download/" -O "/tmp/gtk.pkg.tar.xz" && \
    tar -xJf "/tmp/gtk.pkg.tar.xz" -C / && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies && \
    rm /tmp/*

# Install nuget similarly to mono, gtk-sharp, and monodevelop:
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates tar xz && \
    wget "https://www.archlinux.org/packages/extra/any/nuget/download/" -O "/tmp/gtk.pkg.tar.xz" && \
    tar -xJf "/tmp/gtk.pkg.tar.xz" -C / && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies && \
    rm /tmp/*

RUN apk add --no-cache nano vim man man-pages

USER docker
