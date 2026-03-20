# Stage 1: Build with Zola
FROM ghcr.io/getzola/zola:latest AS builder

ARG BASE_URL=https://feliciterra.com

WORKDIR /site
COPY . .

RUN zola build --base-url "$BASE_URL"

# Stage 2: Serve with static-file-server
FROM halverneus/static-file-server:latest

ARG PORT=8080
ENV PORT=$PORT

COPY --from=builder /site/public /web

EXPOSE $PORT
