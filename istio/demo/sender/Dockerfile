FROM golang:1.22.1 AS builder
WORKDIR /app
COPY . .
RUN go build -a -ldflags="-linkmode external -extldflags -static" -o sender .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/sender .
EXPOSE 8080
CMD ["./sender"]
