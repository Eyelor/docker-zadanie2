# Stage 1: Application Building

# Production version: node:20.13.1-alpine
# Test version: node:16.20.0-alpine
FROM node:20.13.1-alpine as build

WORKDIR /server-app

COPY package*.json ./

COPY server.js ./

# Only geoip-lite is needed for this project
RUN npm install geoip-lite


# Stage 2: Application Run

# Production version: node:20.13.1-alpine
# Test version: node:16.20.0-alpine
FROM node:20.13.1-alpine as production

LABEL org.opencontainers.image.authors="Jakub Kopeć"

WORKDIR /server-app

COPY --from=build /server-app .

# Port 3000 is exposed but if PORT is set in the environment variable it will be used instead
EXPOSE 3000

RUN apk add --no-cache curl

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:3000 || exit 1

CMD ["node", "server.js"]

# Build the builder

# docker buildx create --name zadanie1builder --driver docker-container --bootstrap
# docker buildx use zadanie1builder

# Build the image

# docker buildx build -t docker.io/eyelor/zadanie1:geoip-server-extended --platform linux/amd64,linux/arm64 --push --cache-to=type=registry,ref=docker.io/eyelor/zadanie1:geoip-server-extended-cache --cache-from=type=registry,ref=docker.io/eyelor/zadanie1:geoip-server-extended-cache --builder zadanie1builder .

