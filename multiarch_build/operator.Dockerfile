FROM debian:buster-20201012-slim

ARG TARGETOS
ARG TARGETARCH

WORKDIR /
COPY /bin/operator-${TARGETOS}-${TARGETARCH} \
    /notification-manager-operator
USER nobody
ENTRYPOINT ["/notification-manager-operator"]