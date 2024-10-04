# Multi-stage
# 1) Node image for building frontend assets
# 2) nginx stage to serve frontend assets
# Name the node stage "builder"
FROM node:16.3.0-alpine AS builder
# Set working directory
WORKDIR /app
# Copy all files from current directory to working dir in image
COPY . .
# install node modules and build assets
RUN npm install && npm run build

# nginx state for serving content
FROM nginxinc/nginx-unprivileged:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Switch to root for file deletion
USER 0
# Remove default nginx static assets
RUN rm -rf ./*
# Switch to nginx user
USER nginx
# Copy static assets from builder stage
COPY --from=builder /app/dist .
# Expose port 8080
EXPOSE 8080/tcp
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]
