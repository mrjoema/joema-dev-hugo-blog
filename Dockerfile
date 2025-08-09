FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git gcc g++ musl-dev

RUN go install -tags extended github.com/gohugoio/hugo@v0.128.0

FROM alpine:latest

RUN apk add --no-cache ca-certificates libc6-compat libstdc++ git

COPY --from=builder /go/bin/hugo /usr/local/bin/hugo

WORKDIR /src

EXPOSE 1313

CMD ["hugo", "server", "--bind", "0.0.0.0"]