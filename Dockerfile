#первый этап для компиляции приложения
FROM golang:1.23 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /my_app .

#второй этап с минималистичным образом, чтобы итоговый контейнер был маленьким
FROM alpine:latest

WORKDIR /app

COPY tracker.db .

COPY --from=builder /my_app .

CMD ["./my_app"]

#для сборки: docker build -t my_app:v1 .
#для запуска: docker run --rm my_app:v1   //удаляю контейнер после остановки