# Home Assistant Qdrant Addon

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg

## About

Qdrant is a vector similarity search engine and vector database. It provides a production-ready service with a convenient API to store, search, and manage points—vectors with an additional payload.

This Home Assistant addon allows you to run Qdrant locally within your Home Assistant instance.

## Installation

1. Add this repository to your Home Assistant supervisor
2. Install the "Qdrant" addon
3. Configure the addon (see configuration options below)
4. Start the addon

## Configuration

**Note**: _Remember to restart the addon when the configuration is changed._

Example addon configuration:

```yaml
http_port: 6333
grpc_port: 6334
cors_allow_origin: "*"
log_level: "INFO"
storage_path: "/qdrant/storage"
env_vars: []
```

### Option: `http_port`

The port for Qdrant's HTTP API (default: 6333)

### Option: `grpc_port`  

The port for Qdrant's gRPC API (default: 6334)

### Option: `cors_allow_origin`

CORS allow origin setting for HTTP API (default: "*")

### Option: `log_level`

Set the log level. Options: DEBUG, INFO, WARN, ERROR (default: "INFO")

### Option: `storage_path`

Path where Qdrant will store its data (default: "/qdrant/storage")

### Option: `env_vars`

Additional environment variables to pass to Qdrant

## Usage

Once the addon is running, you can access:

- **REST API**: `http://homeassistant.local:6333`
- **Web UI**: `http://homeassistant.local:6333/dashboard`
- **gRPC API**: `http://homeassistant.local:6334`

## Support

Got questions? Please use the [GitHub issue tracker][issue].

[issue]: https://github.com/yourusername/addon-qdrant/issues 