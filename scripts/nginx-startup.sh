#!/bin/bash

# nginx startup script that handles SSL certificate availability
# This script checks if SSL certificates exist and configures nginx accordingly

DOMAIN=${APPFLOWY_DOMAIN:-"localhost"}
CERT_PATH="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEY_PATH="/etc/letsencrypt/live/$DOMAIN/privkey.pem"
NGINX_CONF="/etc/nginx/nginx.conf"
NGINX_CONF_TEMPLATE="/etc/nginx/nginx.conf.template"

# Function to generate nginx config without SSL
generate_http_only_config() {
    sed 's/listen 443 ssl;//g; /ssl_certificate/d; /ssl_dhparam/d; /include.*ssl/d; s/if.*scheme.*https.*/# SSL redirect disabled/g' "$NGINX_CONF_TEMPLATE" > "$NGINX_CONF"
}

# Function to generate nginx config with SSL
generate_https_config() {
    envsubst '${APPFLOWY_DOMAIN}' < "$NGINX_CONF_TEMPLATE" > "$NGINX_CONF"
}

# Check if SSL certificates exist
if [ -f "$CERT_PATH" ] && [ -f "$KEY_PATH" ]; then
    echo "SSL certificates found. Configuring nginx with HTTPS..."
    generate_https_config
else
    echo "SSL certificates not found. Configuring nginx for HTTP only..."
    generate_http_only_config
fi

# Start nginx
exec nginx -g "daemon off;"
