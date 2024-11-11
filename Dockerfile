# Stage 1: Build the Angular app
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Angular app
RUN ng build --configuration production

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Copy built files from the previous stage
COPY --from=build /app/dist/angular-17-crud/browser /usr/share/nginx/html

# Copy custom Nginx configuration if needed (Optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf


RUN echo "Contents of /usr/share#/nginx/html:" && ls -la /usr/share/nginx/html

# Install curl for health check
RUN apk add --no-cache curl
# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

