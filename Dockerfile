FROM golang:1.26 AS builder
ENV GOTOOLCHAIN=local
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /culturecamp ./cmd/culturecamp
RUN CGO_ENABLED=0 go build -o /culturectl ./cmd/culturectl

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=builder /culturecamp /culturecamp
COPY --from=builder /culturectl /culturectl
EXPOSE 49660
ENTRYPOINT ["/culturecamp"]
