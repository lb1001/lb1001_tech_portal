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

# # Copy the ssl certification to server and update the server config
COPY --from=builder /app/nginx/ssl /usr/share/nginx/ssl
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=builder /app/nginx/tech_portal.conf /etc/nginx/conf.d

# Expose port 80 and 443
EXPOSE 80
EXPOSE 443

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
