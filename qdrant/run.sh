#!/bin/bash
set -eo pipefail  # Fail on errors and pipeline errors

INPUT_FILE="/data/options.json"

# Read configuration from Home Assistant addon options
HTTP_PORT=$(jq -r '.http_port // 6333' "$INPUT_FILE")
GRPC_PORT=$(jq -r '.grpc_port // 6334' "$INPUT_FILE")
CORS_ALLOW_ORIGIN=$(jq -r '.cors_allow_origin // "*"' "$INPUT_FILE")
LOG_LEVEL=$(jq -r '.log_level // "INFO"' "$INPUT_FILE")
STORAGE_PATH=$(jq -r '.storage_path // "/qdrant/storage"' "$INPUT_FILE")

# Set environment variables for Qdrant
export QDRANT__SERVICE__HTTP_PORT="$HTTP_PORT"
export QDRANT__SERVICE__GRPC_PORT="$GRPC_PORT"
export QDRANT__SERVICE__CORS_ALLOW_ORIGIN="$CORS_ALLOW_ORIGIN"
export QDRANT__LOG_LEVEL="$LOG_LEVEL"
export QDRANT__STORAGE__STORAGE_PATH="$STORAGE_PATH"

# Process additional environment variables from addon options
while IFS= read -r line; do
    [[ -z "$line" ]] && continue  # Skip empty lines
    key="${line%%=*}"
    value="${line#*=}"
    
    echo "Setting environment variable: $key=${value@Q}"
    export "$key"="$value"
done < <(
    < "$INPUT_FILE" jq -r \
    '.env_vars[]? | "\(.name)=\(.value | tostring)"'
)

echo "Starting Qdrant with configuration:"
echo "  HTTP Port: $HTTP_PORT"
echo "  GRPC Port: $GRPC_PORT" 
echo "  CORS Allow Origin: $CORS_ALLOW_ORIGIN"
echo "  Log Level: $LOG_LEVEL"
echo "  Storage Path: $STORAGE_PATH"

# Ensure storage directory exists
mkdir -p "$STORAGE_PATH"

# Start Qdrant
exec ./qdrant 