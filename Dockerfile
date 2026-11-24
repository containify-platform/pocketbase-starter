# PocketBase, downloaded from its GitHub release and checked against the
# release's checksum. Bump PB_VERSION (and the checksums) to upgrade.
FROM alpine:3.22 AS download
ARG PB_VERSION=0.40.6
ARG TARGETARCH
ARG PB_SHA256_amd64=0e1f609158ed945f809f8a02ae012aa0427129c66ebb63c1aee76f2c0309373f
ARG PB_SHA256_arm64=d22c66ceb67ca92b7d767f36d826e848a276bcfa3c197ead20bf87c42208984f
RUN apk add --no-cache curl unzip \
 && arch="${TARGETARCH:-amd64}" \
 && curl -fsSL -o /tmp/pb.zip "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_${arch}.zip" \
 && eval "sum=\$PB_SHA256_${arch}" \
 && echo "${sum}  /tmp/pb.zip" | sha256sum -c - \
 && unzip /tmp/pb.zip pocketbase -d /out

FROM alpine:3.22
RUN apk add --no-cache ca-certificates tzdata \
 && adduser -D -H -u 1000 pocketbase \
 && mkdir -p /pb/pb_data && chown pocketbase:pocketbase /pb/pb_data
WORKDIR /pb
COPY --from=download /out/pocketbase /usr/local/bin/pocketbase
COPY --chown=pocketbase:pocketbase pb_migrations ./pb_migrations
COPY --chown=pocketbase:pocketbase pb_hooks ./pb_hooks
COPY --chown=pocketbase:pocketbase pb_public ./pb_public
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
USER pocketbase
ENV PORT=8090
EXPOSE 8090
VOLUME /pb/pb_data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
