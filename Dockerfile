FROM openjdk:8-jre-alpine

ENV METABASE_VERSION=0.36.7

COPY ./rootfs /

RUN addgroup metabase && adduser -S -D -G metabase metabase && \
    wget -O /opt/metabase.jar https://downloads.metabase.com/v${METABASE_VERSION}/metabase.jar

USER metabase

CMD ["java", "-Dlog4j.configuration=file:/opt/metabase/log4j.properties", "-jar", "/opt/metabase.jar"]