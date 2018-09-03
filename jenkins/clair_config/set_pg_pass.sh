#!/bin/sh
sed -i "s#{{POSTGRES_CONNECT}}#postgresql://postgres:${POSTGRES_PASSWORD}@postgres:5432?sslmode=disable#" /config/config.yaml