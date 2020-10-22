FROM openjdk:8-jre-alpine

ENV METABASE_VERSION=0.36.7

COPY ./rootfs /

RUN addgroup metabase && adduser -S -D -G metabase metabase && \
# add font support for xlsx export
    apk --no-cache add msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f && \
# download metabase
    wget -O /opt/metabase.jar https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

USER metabase

CMD ["java", "-Dlog4j.configuration=file:/opt/metabase/log4j.properties", "-jar", "/opt/metabase.jar"]