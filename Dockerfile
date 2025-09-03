FROM amazoncorretto:21.0.7-alpine

ENV METABASE_VERSION=0.56.4 \
    JQ_VERSION=1.7.1 \
    ORACLE_JDBC_VERSION=23.7.0.25.01 \
    MB_ANON_TRACKING_ENABLED=false \
    MB_CHECK_FOR_UPDATES=false \
    MB_EMOJI_IN_LOGS=false \
    MB_ENABLE_EMBEDDING_STATIC=true \
    MB_ENABLE_EMBEDDING_SDK=true \
    MB_ENABLE_EMBEDDING_INTERACTIVE=true

RUN apk upgrade --no-cache && \
    addgroup metabase && adduser -S -D -G metabase metabase && \
# add font support for xlsx export
    apk --no-cache add msttcorefonts-installer fontconfig bash curl && \
    update-ms-fonts && \
    fc-cache -f && \
# install jq
    curl -fsSLo /usr/local/bin/jq https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/jq-linux-amd64 && \
    chmod +x /usr/local/bin/jq && \
# download metabase
    mkdir -p /opt/plugins && \
    curl -fsSLo /opt/metabase.jar https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar && \
    curl -fsSLo /opt/plugins/ojdbc11.jar https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/${ORACLE_JDBC_VERSION}/ojdbc11-${ORACLE_JDBC_VERSION}.jar && \
# clean up
    rm -rf /apk /tmp/* /var/cache/apk/*

COPY ./rootfs /

USER metabase

ENTRYPOINT ["entrypoint"]
CMD ["java", "-Dlog4j.configurationFile=file:/opt/metabase/log4j2.xml", "-jar", "/opt/metabase.jar"]