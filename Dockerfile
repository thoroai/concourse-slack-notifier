FROM clux/muslrust AS build

RUN mkdir -p /src
WORKDIR /src
COPY . /src

RUN cargo build --release

FROM alpine:3.8

RUN apk add --no-cache ca-certificates

COPY --from=build /src/target/x86_64-unknown-linux-musl/release/concourse-slack-notifier /opt/resource/main
RUN ln -s /opt/resource/main /opt/resource/check
RUN ln -s /opt/resource/main /opt/resource/in
RUN ln -s /opt/resource/main /opt/resource/out

ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR /etc/ssl/certs
