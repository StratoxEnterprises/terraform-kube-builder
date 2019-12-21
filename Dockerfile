FROM ljfranklin/terraform-resource:0.12.18 as base
LABEL maintainer="Tomas Trnka <tt@tomastrnka.net>"
RUN apk update && \
    apk upgrade

FROM base AS tools
RUN apk add wireguard-tools=0.0.20190601-r1 && \
    apk add jq=1.6-r0 && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*