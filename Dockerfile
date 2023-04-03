# Use the Go image to build our application.
FROM golang:1.20-alpine AS builder

# Change the current directory in Docker to our source directory.
WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies
# and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

# Copy the present working directory to our source directory in Docker.
COPY . .

# Build our application.
RUN go build -o /usr/bin/pb ./...

# This starts our final image; based on alpine to make it small.
FROM alpine

# Copy executable from builder.
COPY --from=builder /usr/bin/pb /usr/bin/pb

# Notify Docker that the container wants to expose a port.
EXPOSE 8080

# Serve the pocketbase
CMD ["/usr/bin/pb", "serve", "--http=0.0.0.0:8080"]