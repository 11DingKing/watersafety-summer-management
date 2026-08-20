FROM golang:1.26 AS builder
ENV GOTOOLCHAIN=local
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /watersafety ./cmd/watersafety
RUN CGO_ENABLED=0 go build -o /culturectl ./cmd/culturectl

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=builder /watersafety /watersafety
COPY --from=builder /culturectl /culturectl
EXPOSE 49660
ENTRYPOINT ["/watersafety"]
