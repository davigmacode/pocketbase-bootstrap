FROM golang:1.20-alpine

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies
# and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -o /usr/bin/pocketbase ./...

WORKDIR /
EXPOSE 8080

CMD ["/usr/bin/pocketbase", "serve", "--http=0.0.0.0:8080"]