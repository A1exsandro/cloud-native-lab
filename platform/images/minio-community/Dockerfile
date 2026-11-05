# Build stage
FROM golang:1.24.8-bookworm AS builder

ARG MINIO_COMMIT=7aac2a2c5b7c882e68c1ce017d8256be2feea27f

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone https://github.com/minio/minio.git . && \
    git checkout "${MINIO_COMMIT}"

RUN make build

# Runtime stage
FROM debian:13-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/minio /usr/local/bin/minio

EXPOSE 9000 9001

ENTRYPOINT ["/usr/local/bin/minio"]
