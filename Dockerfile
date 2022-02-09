FROM openjdk:8-jre-alpine

ENV METABASE_VERSION=0.42.0 \
    JQ_VERSION=1.6 \
    MB_ANON_TRACKING_ENABLED=false \
    MB_CHECK_FOR_UPDATES=false \
    MB_EMOJI_IN_LOGS=false \
    MB_ENABLE_EMBEDDING=true

COPY ./rootfs /

RUN addgroup metabase && adduser -S -D -G metabase metabase && \
# add font support for xlsx export
    apk --no-cache add msttcorefonts-installer fontconfig bash curl && \
    update-ms-fonts && \
    fc-cache -f && \
# install jq
    curl -fsSLo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
# download metabase
    curl -fsSLo /opt/metabase.jar https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar && \
# make scripts executable
    chmod +x /usr/local/bin/bootstrap && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

USER metabase

CMD ["java", "-Dlog4j.configuration=file:/opt/metabase/log4j.properties", "-jar", "/opt/metabase.jar"]