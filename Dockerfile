# --- Stage 1: Build ---
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json & package-lock.json trước để cache dependencies
COPY package*.json ./

# Cài dependencies
RUN npm install

# Copy toàn bộ source code vào container
COPY . .

# Build production (ra thư mục dist)
RUN npm run build


# --- Stage 2: Run (Nginx) ---
FROM nginx:alpine

# Copy file build từ stage 1 vào thư mục nginx
COPY --from=build /app/dist /usr/share/nginx/html
  
  # Copy config nginx (nếu cần routing SPA)
  COPY nginx.conf /etc/nginx/conf.d/default.conf
  
  # Expose port
  EXPOSE 80
  
  CMD ["nginx", "-g", "daemon off;"]
  