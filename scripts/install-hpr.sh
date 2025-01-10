#!/bin/bash
set -e

# Ensure required environment variables are set
: "${HPR_DATA_DIR:?HPR_DATA_DIR must be set}"
VERIFY_SIGNATURE=${VERIFY_SIGNATURE:-true}
export GNUPGHOME=/root/.gnupg

# Import Parsec GPG key if verification is enabled
if [ "$VERIFY_SIGNATURE" = "true" ]; then
    echo "Importing Parsec GPG key..."
    curl -s https://builds.parsec.app/hpr/gpg/parsechpr_public.key | gpg --import
fi

verify_signature() {
    local archive=$1
    local temp_dir=$2
    local url=$3
    
    # Download signature
    if [[ $url == https://builds.parsec.app/* ]]; then
        wget "${url}.sig" -O "${archive}.sig"
    else
        echo "Custom URL detected. Looking for signature at ${url}.sig"
        if ! wget "${url}.sig" -O "${archive}.sig"; then
            echo "Warning: Could not download signature file for custom URL"
            echo "Either provide a .sig file at ${url}.sig or set VERIFY_SIGNATURE=false"
            exit 1
        fi
    fi

    cd "$temp_dir"
    if ! gpg --verify parsechpr*/parsechpr.sig parsechpr*/parsechpr; then
        echo "ERROR: GPG signature verification failed!"
        exit 1
    fi
}

download_and_install() {
    local url=$1
    local output=$2
    local skip_verify=${3:-false}

    echo "Downloading HPR from: $url"
    wget "$url" -O "$output"

    # Create temporary directory in HPR_DATA_DIR
    local temp_dir=$(mktemp -d -p "${HPR_DATA_DIR}")
    trap 'rm -rf "${temp_dir}"' EXIT

    # Extract archive
    echo "Extracting archive..."
    tar -xf "$output" -C "$temp_dir"
    
    # Debug: show extracted contents
    echo "Contents of temp directory:"
    ls -la "$temp_dir"
    echo "Contents of subdirectories:"
    ls -R "$temp_dir"

    # Verify if required
    if [ "$skip_verify" = "false" ] && [ "$VERIFY_SIGNATURE" = "true" ]; then
        echo "Verifying signature..."
        verify_signature "$output" "$temp_dir" "$url"
    else
        echo "Skipping signature verification"
    fi

    # Install binary
    echo "Installing binary to ${HPR_DATA_DIR}..."
    cp -f "${temp_dir}"/parsechpr*/parsechpr "${HPR_DATA_DIR}/"
    chmod +x "${HPR_DATA_DIR}/parsechpr"
}

# Create data directory if it doesn't exist
mkdir -p "${HPR_DATA_DIR}"

# Download and install HPR
cd "${HPR_DATA_DIR}"
if [ -n "${HPR_DOWNLOAD_URL:-}" ]; then
    echo "Using custom HPR URL"
    download_and_install "$HPR_DOWNLOAD_URL" "${HPR_DATA_DIR}/hpr.tar.gz"
else
    if [ -z "${HPR_VERSION:-}" ]; then
        echo "ERROR: Either HPR_DOWNLOAD_URL or HPR_VERSION must be set"
        exit 1
    fi
    echo "Downloading HPR version ${HPR_VERSION} from official source"
    download_and_install "https://builds.parsec.app/hpr/parsechpr${HPR_VERSION}.linux-amd64.tar.gz" "${HPR_DATA_DIR}/hpr.tar.gz"
fi

# Clean up downloaded archives
rm -f "${HPR_DATA_DIR}/hpr.tar.gz" "${HPR_DATA_DIR}/hpr.tar.gz.sig"