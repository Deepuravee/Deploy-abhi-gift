# === Build Stage ===
FROM node:18-alpine AS build

WORKDIR /app

# Copy dependency definitions
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci --legacy-peer-deps

# Copy all source files
COPY . .

# Build the React app for production
RUN npm run build

# === Production Stage ===
FROM nginx:stable-alpine AS production

# Remove default nginx static assets (optional)
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx, foreground
CMD ["nginx", "-g", "daemon off;"]
