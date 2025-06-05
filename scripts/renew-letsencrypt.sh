#!/bin/bash

# Manual renewal script for Let's Encrypt certificates
# This script manually triggers certificate renewal

echo "### Attempting to renew Let's Encrypt certificates ..."
docker compose run --rm certbot renew

echo "### Reloading nginx to use renewed certificates ..."
docker compose exec nginx nginx -s reload

echo "### Certificate renewal process completed!"
