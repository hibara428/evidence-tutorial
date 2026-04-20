FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

# Copy pre-fetched source data and app files
# Run `npm run sources` locally before building this image
COPY . .

RUN npm run build

# Remove <link rel="manifest"> to prevent CORS errors when behind IAP
# (browsers fetch manifest.webmanifest without credentials, causing IAP to redirect)
RUN find /app/build -name "*.html" -exec sed -i 's/<link rel="manifest"[^>]*>//g' {} \;

# ---

FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
