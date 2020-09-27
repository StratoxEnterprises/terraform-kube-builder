FROM ljfranklin/terraform-resource:0.13.3 as base
LABEL maintainer="Tomas Trnka <tt@tomastrnka.net>"
RUN apk update \
    && apk upgrade

# Terraform Libvirt Plugin
FROM golang:1.13-alpine AS libvirt
RUN apk update \
    && apk upgrade \
    && apk add --no-cache git make gcc pkgconfig libvirt-dev libc-dev \
    && mkdir -p /build \
    && mkdir -p /dist
WORKDIR /build 
RUN git clone https://github.com/dmacvicar/terraform-provider-libvirt.git
WORKDIR /build/terraform-provider-libvirt
RUN git checkout v0.6.2 && env GO111MODULE=on go mod download \
    && make build && mv terraform-provider-libvirt /dist/terraform-provider-libvirt_v0.6.2

FROM base AS tools
RUN apk add wireguard-tools=1.0.20200102-r0 \
    && apk add jq=1.6-r0 \
    && mkdir -p /root/.terraform.d/plugins/linux_amd64/ \
    && apk add libvirt gcc libxslt cdrkit openssh-client \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*
COPY --from=libvirt /dist/terraform-provider-libvirt_v0.6.2 /root/.terraform.d/plugins/linux_amd64/