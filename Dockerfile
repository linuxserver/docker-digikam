FROM ghcr.io/linuxserver/baseimage-kasmvnc:arch

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DIGIKAM_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hackerman"

# title
ENV TITLE=DigiKam

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/digikam-logo.png && \
  echo "**** install runtime packages ****" && \
  pacman -Sy --noconfirm --needed \
    breeze-icons \
    digikam \
    firefox \
    mariadb \
    openexr \
    perl-image-exiftool && \
  echo "**** image tweaks ****" && \
  ln -s \
    /usr/bin/vendor_perl/exiftool \
    /usr/bin/exiftool && \
  dbus-uuidgen > /etc/machine-id && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/cache/pacman/pkg/* \
    /var/lib/pacman/sync/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
