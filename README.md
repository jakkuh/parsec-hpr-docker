# Parsec High Performance Relay Docker

A Docker container for running Parsec's High Performance Relay 2.0 (HPR). The relay is used in situations where restrictive firewalls prevent the Parsec client from directly connecting to a host.

## Features
- Downloads the HPR binary at runtime
- GPG signature verification for security
- Configurable network bindings
- PUID/PGID support
- Persistent binary storage (/data)
- Fully configurable through environment variables

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/parsec-hpr-docker.git
cd parsec-hpr-docker

# Copy and edit the environment file
cp .env.example .env

# Start the container
docker-compose up -d
```

## Configuration

### Relay Config

| Variable | Description |
|----------|-------------|
| `TEAM_ID` | Your Parsec team ID |
| `SECRET` | Your relay secret |

### Network Config

| Variable | Default | Description |
|----------|---------|-------------|
| `WAN_IP` | - | External IP address for the relay |
| `PUBLIC_PORT` | 5000 | Public port for connections |
| `PRIVATE_PORT` | 4900 | Private port for connections |
| `PUBLIC_IP` | - | Optional: Bind public port to specific interface |
| `PRIVATE_IP` | - | Optional: Bind private port to specific interface |

### Version Config

| Variable | Default | Description |
|----------|---------|-------------|
| `HPR_VERSION` | - | Optional: Version of Parsec HPR to install |
| `HPR_DOWNLOAD_URL` | https://builds.parsec.app/hpr/parsechpr2.0.0.linux-amd64.tar.gz | Optional: Custom download URL for HPR binary |
| `VERIFY_SIGNATURE` | true | Optional: Enable/disable GPG signature verification |

### User/Group Config

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | - | Optional: User ID for file permissions |
| `PGID` | - | Optional: Group ID for file permissions |

## Documentation

For more information about Parsec HPR configuration and setup, please refer to the official Parsec documentation:
- [Configure Parsec Relay Server](https://support.parsec.app/hc/en-us/articles/32381057878292-Configure-Parsec-Relay-Server)

## Security Notes

- The HPR binary is verified using GPG signatures by default
- Consider using Docker secrets in production environments

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
