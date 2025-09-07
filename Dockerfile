# Base image
FROM node:22-alpine as base

# Install curl so Coolify can run healthchecks
RUN apk add --no-cache curl

# -----------------------
# Build stage
# -----------------------
FROM base as builder

WORKDIR /home/node/app
COPY package*.json ./
COPY . .

RUN yarn install
RUN yarn build

# -----------------------
# Runtime stage
# -----------------------
FROM base as runtime

ENV NODE_ENV=production
ENV PAYLOAD_CONFIG_PATH=dist/payload.config.js

WORKDIR /home/node/app

COPY package*.json  ./
RUN yarn install --production

COPY --from=builder /home/node/app/dist ./dist
COPY --from=builder /home/node/app/build ./build

EXPOSE 3000

# 👇 Debug: print all env vars, then start Payload
CMD printenv && node dist/server.js
