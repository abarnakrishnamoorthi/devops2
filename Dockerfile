# Use Node.js Alpine base image to build React
FROM node:alpine as build

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the entire project and build it
COPY . .
RUN npm run build

# Use Nginx for production
FROM nginx:alpine

# Copy React build files to Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Copy a custom Nginx configuration file (for port 3003)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 3003
EXPOSE 3003

CMD ["nginx", "-g", "daemon off;"]
