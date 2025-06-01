# Home Assistant Qdrant Addon

## Introduction

Qdrant is a vector similarity search engine and vector database that provides fast and scalable vector similarity search with extended filtering support. It is useful for neural network or semantic-based matching, faceted search, and other applications.

This addon provides a simple way to run Qdrant within your Home Assistant environment.

## Installation

The installation of this addon is pretty straightforward:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Add the repository URL for this addon.
3. Find the "Qdrant" addon and click it.
4. Click on the "INSTALL" button.

## How to use

### Starting the addon

1. Set the addon configuration (see configuration section below).
2. Start the addon.
3. Check the addon log output to see the result.

### Accessing Qdrant

Once the addon is running, Qdrant will be available at:

- REST API: `http://homeassistant.local:6333` (or your configured HTTP port)
- Web Dashboard: `http://homeassistant.local:6333/dashboard`
- gRPC API: `http://homeassistant.local:6334` (or your configured gRPC port)

## Configuration

Addon configuration:

```yaml
http_port: 6333
grpc_port: 6334
cors_allow_origin: "*"
log_level: "INFO"
storage_path: "/qdrant/storage"
env_vars:
  - name: "CUSTOM_ENV_VAR"
    value: "custom_value"
```

### Option: `http_port` (required)

The port on which Qdrant's HTTP API will be available.

**Default**: `6333`

### Option: `grpc_port` (required)

The port on which Qdrant's gRPC API will be available.

**Default**: `6334`

### Option: `cors_allow_origin` (optional)

Sets the CORS allow origin header for the HTTP API.

**Default**: `"*"`

### Option: `log_level` (optional)

Controls the level of log output from Qdrant.

**Possible values**: `DEBUG`, `INFO`, `WARN`, `ERROR`

**Default**: `"INFO"`

### Option: `storage_path` (optional)

The path where Qdrant will store its data. This is mapped to the addon's persistent storage.

**Default**: `"/qdrant/storage"`

### Option: `env_vars` (optional)

Allows you to specify additional environment variables to pass to the Qdrant process.

**Note**: _This is for advanced users only. Most users will not need this._

#### Sub-option: `name`

The name of the environment variable.

#### Sub-option: `value`

The value of the environment variable.

## Using Qdrant

### Python Client Example

```python
from qdrant_client import QdrantClient

# Connect to your Home Assistant Qdrant instance
client = QdrantClient(host="homeassistant.local", port=6333)

# Create a collection
client.create_collection(
    collection_name="test_collection",
    vectors_config={"size": 4, "distance": "Dot"}
)

# Add some vectors
client.upsert(
    collection_name="test_collection",
    points=[
        {
            "id": 1,
            "vector": [0.05, 0.61, 0.76, 0.74],
            "payload": {"city": "Berlin"}
        },
        {
            "id": 2, 
            "vector": [0.19, 0.81, 0.75, 0.11],
            "payload": {"city": "London"}
        }
    ]
)

# Search for similar vectors
search_result = client.search(
    collection_name="test_collection",
    query_vector=[0.2, 0.1, 0.9, 0.7],
    limit=3
)
```

### REST API Example

```bash
# Create a collection
curl -X PUT 'http://homeassistant.local:6333/collections/test_collection' \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "vectors": {
            "size": 4,
            "distance": "Dot"
        }
    }'

# Add vectors
curl -L -X PUT 'http://homeassistant.local:6333/collections/test_collection/points' \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "points": [
            {"id": 1, "vector": [0.05, 0.61, 0.76, 0.74], "payload": {"city": "Berlin"}},
            {"id": 2, "vector": [0.19, 0.81, 0.75, 0.11], "payload": {"city": "London"}}
        ]
    }'

# Search
curl -L -X POST 'http://homeassistant.local:6333/collections/test_collection/points/search' \
    -H 'Content-Type: application/json' \
    --data-raw '{
        "vector": [0.2, 0.1, 0.9, 0.7],
        "limit": 3
    }'
```

## Support

Got questions?

You have several options to get them answered:

- The [Qdrant Documentation][qdrant-docs]
- The Home Assistant [Community Forum][forum]
- Join the [Discord chat server][discord] for general Home Assistant discussions

You could also [open an issue here][issue] on GitHub.

[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/
[issue]: https://github.com/yourusername/addon-qdrant/issues
[qdrant-docs]: https://qdrant.tech/documentation/ 