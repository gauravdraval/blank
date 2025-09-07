# ---------------------------
# Base image
# ---------------------------
FROM node:22-alpine AS base

WORKDIR /home/node/app

# Install curl for healthcheck (required by Coolify)
RUN apk add --no-cache curl

# ---------------------------
# Builder stage
# ---------------------------
FROM base AS builder

WORKDIR /home/node/app

# Copy package.json and yarn.lock first (for caching)
COPY package*.json ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy all source files
COPY . .

# Build Payload and server
RUN yarn copyfiles && \
    cross-env PAYLOAD_CONFIG_PATH=src/payload.config.ts payload build && \
    yarn build:server

# ---------------------------
# Production stage
# ---------------------------
FROM base AS prod

WORKDIR /home/node/app

# Copy built app from builder
COPY --from=builder /home/node/app/dist ./dist
COPY --from=builder /home/node/app/package*.json ./

# Install only production dependencies
RUN yarn install --production --frozen-lockfile

# Expose the port
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production

# Start the app
CMD ["node", "dist/server.js"]
