# Use the official Node.js 18.16.0-bullseye image as the base
FROM node:18.16.0-bullseye AS builder

# Set the working directory
WORKDIR /app

# Copy the package files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application files
COPY . .

# Build the static site
RUN npm run build

# Use the official nginx image as the base
FROM nginx:stable-bullseye

# Copy the static site from the previous stage to the nginx "html" directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
