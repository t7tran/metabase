FROM amazoncorretto:17-alpine

ENV METABASE_VERSION=0.47.4 \
    JQ_VERSION=1.6 \
    MB_ANON_TRACKING_ENABLED=false \
    MB_CHECK_FOR_UPDATES=false \
    MB_EMOJI_IN_LOGS=false \
    MB_ENABLE_EMBEDDING=true

RUN apk upgrade --no-cache && \
    addgroup metabase && adduser -S -D -G metabase metabase && \
# add font support for xlsx export
    apk --no-cache add msttcorefonts-installer fontconfig bash curl && \
    update-ms-fonts && \
    fc-cache -f && \
# install jq
    curl -fsSLo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
# download metabase
    curl -fsSLo /opt/metabase.jar https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

COPY ./rootfs /

USER metabase

ENTRYPOINT ["entrypoint"]
CMD ["java", "-Dlog4j.configurationFile=file:/opt/metabase/log4j2.xml", "-jar", "/opt/metabase.jar"]