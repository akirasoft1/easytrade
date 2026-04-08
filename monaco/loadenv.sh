#!/bin/bash
# Simple script to export .env variables to the current shell session
# Usage: source ./load_env.sh

if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
    echo "✅ Environment variables loaded from .env"
else
    echo "❌ .env file not found"
fi
