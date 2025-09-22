FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DIGIKAM_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hackerman"

# title
ENV TITLE=DigiKam \
    NO_GAMEPAD=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/digikam-logo.png && \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    breeze-icon-theme \
    caja \
    chromium \
    mariadb-server \
    openexr \
    libimage-exiftool-perl && \
  echo "**** install from appimage ****" && \
  if [ -z ${DIGIKAM_VERSION+x} ]; then \
    DIGIKAM_VERSION=$(curl -sL https://mirrors.mit.edu/kde/stable/digikam/ \
    | awk -F'(="./|/")' '/href=".\/[0-9]/ {print $2}'); \
  fi && \
  curl -o \
    /tmp/digi.app -L \
    "https://mirrors.mit.edu/kde/stable/digikam/${DIGIKAM_VERSION}/digiKam-${DIGIKAM_VERSION}-Qt6-x86-64.appimage" && \
  cd /tmp && \
  chmod +x digi.app && \
  ./digi.app --appimage-extract && \
  mv squashfs-root /opt/digikam && \
  echo "**** OS Tweaks ****" && \
  mv \
    /usr/bin/chromium \
    /usr/bin/chromium-real && \
  echo '#!/bin/bash' > /usr/sbin/digikam && \
  echo 'cd /opt/digikam && ./AppRun' >> /usr/sbin/digikam && \
  chmod +x /usr/sbin/digikam && \
  ln -s \
    /usr/bin/chromium \
    /usr/bin/firefox && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
