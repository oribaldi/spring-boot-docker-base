FROM openjdk:latest
MAINTAINER Etienne Koekemoer <me@etiennek.com>

ENV BOOTAPP_JAVA_OPTS -Xms256m -Xmx256m

ENV BOOTAPP_USR bootapp
ENV BOOTAPP_GROUP bootapp_group
ENV BOOTAPP_PATH /app.jar
ENV BOOTAPP_DATA_VOLUME /data
ENV SERVER_PORT 8007

COPY wrapper.sh /wrapper.sh

RUN groupadd -r $BOOTAPP_GROUP && useradd -r -g $BOOTAPP_GROUP $BOOTAPP_USR \
	&& chmod 555 /wrapper.sh

EXPOSE $SERVER_PORT

VOLUME /tmp
VOLUME $BOOTAPP_DATA_VOLUME

USER $BOOTAPP_USR

ONBUILD USER root
ONBUILD COPY app.jar $BOOTAPP_PATH
ONBUILD RUN chmod 555 $BOOTAPP_PATH && \
            touch $BOOTAPP_PATH
ONBUILD USER $BOOTAPP_USR

ENTRYPOINT ["/wrapper.sh"]
