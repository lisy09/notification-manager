FROM debian:buster-20201012-slim

ARG TARGETOS
ARG TARGETARCH

WORKDIR /
COPY /bin/notification-manager-${TARGETOS}-${TARGETARCH} \
    /notification-manager
USER nobody
ENTRYPOINT ["/notification-manager"]