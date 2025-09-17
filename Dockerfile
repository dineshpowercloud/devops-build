# Production image (skip build stage since files are pre-built)
FROM nginx:stable-alpine
COPY build /usr/share/nginx/html
# SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
