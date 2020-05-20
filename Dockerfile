FROM lsiobase/rdesktop-web:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DIGIKAM_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="hackerman"

RUN \
 echo "**** install digikam ****" && \
 if [ -z ${DIGIKAM_VERSION} ]; then \
	DIGIKAM_VERSION=$(curl -s "https://invent.kde.org/graphics/digikam/-/tags?format=atom" \
	| grep -m 1 -P '<title>(v\d\.\d\.\d)</title>' | sed 's/\(^\s*<title>v\|<\/title>\s*$\)//g'); \
 fi && \
 curl -o /app/digikam -L \
 	https://download.kde.org/stable/digikam/${DIGIKAM_VERSION}/digikam-${DIGIKAM_VERSION}-x86-64.appimage && \
 chmod +x /app/digikam && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
