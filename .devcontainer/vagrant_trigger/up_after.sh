#!/usr/bin/env bash

set -e

# Configuration
VBOX_VERSION="${VBOX_VERSION:-latest}"
VBOX_DOWNLOAD_URL="https://download.virtualbox.org/virtualbox"
VBOX_ISO_DIR="${HOME}"
VBOX_MOUNT_DIR="/tmp/vbox"
VBOX_INSTALL_DIR="/opt/VBoxGuestAdditions"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Check if VirtualBox Guest Additions directory sharing is running
is_vbox_guest_additions_running() {
    log_info "Checking if VirtualBox Guest Additions directory sharing is running..."

    # Check if vboxsf kernel module is loaded (shared folder support)
    if lsmod | grep -q vboxsf; then
        log_info "VirtualBox Guest Additions directory sharing is active (vboxsf module detected)"
        return 0
    fi

    # Check if any shared folders are mounted
    if mount | grep -q vboxsf; then
        log_info "VirtualBox Guest Additions directory sharing is active (shared folders mounted)"
        return 0
    fi

    # Check if vboxguest-service is running
    if systemctl is-active --quiet vboxadd-service 2>/dev/null; then
        log_info "VirtualBox Guest Additions service is active"
        return 0
    fi

    log_info "VirtualBox Guest Additions directory sharing is not active"
    return 1
}

# Get the latest VirtualBox version from LATEST.TXT
get_latest_vbox_version() {
    log_info "Fetching latest VirtualBox version..."
    local version
    version=$(curl -s "${VBOX_DOWNLOAD_URL}/LATEST.TXT" | tr -d '[:space:]')

    if [[ -z "$version" ]]; then
        log_error "Failed to fetch VirtualBox version from LATEST.TXT"
        return 1
    fi

    echo "$version"
}

# Determine installer suffix based on architecture
get_installer_suffix() {
    local arch
    arch=$(uname -m)

    if [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
        echo "-arm64"
    else
        echo ""
    fi
}

# Determine kernel headers package based on architecture
get_kernel_headers_package() {
    local arch
    arch=$(uname -m)

    if [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
        echo "linux-headers-arm64"
    else
        echo "linux-headers-amd64"
    fi
}

# Download VBoxGuestAdditions ISO if not already present
download_vbox_iso() {
    local version="$1"
    local iso_file="${VBOX_ISO_DIR}/VBoxGuestAdditions_${version}.iso"

    if [[ -f "$iso_file" ]]; then
        log_info "VBoxGuestAdditions ISO already exists: $iso_file"
        return 0
    fi

    log_info "Downloading VBoxGuestAdditions ISO for version ${version}..."
    if curl -f -L -o "$iso_file" \
        -m 300 \
        "${VBOX_DOWNLOAD_URL}/${version}/VBoxGuestAdditions_${version}.iso"; then
        chmod 0644 "$iso_file"
        log_info "VBoxGuestAdditions ISO downloaded successfully"
        return 0
    else
        log_error "Failed to download VBoxGuestAdditions ISO"
        return 1
    fi
}

# Install VirtualBox Guest Additions
install_vbox_guest_additions() {
    local version="$1"
    local installer_suffix="$2"
    local iso_file="${VBOX_ISO_DIR}/VBoxGuestAdditions_${version}.iso"
    local install_dir="${VBOX_INSTALL_DIR}-${version}"

    # Check if already installed
    if [[ -d "$install_dir" ]]; then
        log_info "VirtualBox Guest Additions already installed at $install_dir"
        VBOX_INSTALLED=false
        return 0
    fi

    log_info "Installing VirtualBox Guest Additions..."

    # Install build dependencies
    log_info "Installing build dependencies..."
    sudo apt-get update -qq
    local kernel_headers_package
    kernel_headers_package=$(get_kernel_headers_package)
    if ! sudo apt-get install -y build-essential dkms "${kernel_headers_package}"; then
        log_error "Failed to install build dependencies"
        return 1
    fi

    # Create mount directory
    log_info "Creating VirtualBox mount directory..."
    if ! sudo mkdir -p "$VBOX_MOUNT_DIR"; then
        log_error "Failed to create mount directory"
        return 1
    fi

    # Mount ISO
    log_info "Mounting VBoxGuestAdditions ISO..."
    if ! sudo mount -o loop,ro "$iso_file" "$VBOX_MOUNT_DIR"; then
        log_error "Failed to mount VBoxGuestAdditions ISO"
        return 1
    fi

    # Run installer
    log_info "Running VBoxLinuxAdditions installer..."
    local installer_path="${VBOX_MOUNT_DIR}/VBoxLinuxAdditions${installer_suffix}.run"

    if (! sudo bash "$installer_path") then
        log_warn "VBoxLinuxAdditions installation may have failed, but continuing..."
    fi

    # Unmount ISO
    log_info "Unmounting VBoxGuestAdditions ISO..."
    if ! sudo umount "$VBOX_MOUNT_DIR"; then
        log_error "Failed to unmount VBoxGuestAdditions ISO"
        return 1
    fi

    # Create install marker
    sudo mkdir -p "$install_dir"
    log_info "VirtualBox Guest Additions installation completed"

    # Remove build dependencies
    log_info "Removing build dependencies..."
    sudo apt-get autoremove -y dkms "${kernel_headers_package}"

    VBOX_INSTALLED=true
    return 0
}

# Main execution
main() {
    log_info "Starting VirtualBox Guest Additions setup..."

    # Check if VirtualBox Guest Additions is already running
    if is_vbox_guest_additions_running; then
        log_info "VirtualBox Guest Additions is already active, skipping installation"
        return 0
    fi

    # Determine VirtualBox version
    local vbox_version="$VBOX_VERSION"
    if [[ "$vbox_version" == "latest" ]]; then
        if ! vbox_version=$(get_latest_vbox_version); then
            log_error "Failed to determine VirtualBox version"
            exit 1
        fi
        log_info "Using VirtualBox version: $vbox_version"
    fi

    # Get installer suffix
    local installer_suffix
    installer_suffix=$(get_installer_suffix)

    # Download ISO
    if ! download_vbox_iso "$vbox_version"; then
        log_error "Failed to download VirtualBox ISO"
        exit 1
    fi

    # Install Guest Additions
    if ! install_vbox_guest_additions "$vbox_version" "$installer_suffix"; then
        log_error "Failed to install VirtualBox Guest Additions"
        exit 1
    fi

    log_info "VirtualBox Guest Additions setup completed successfully"
}

VBOX_INSTALLED=false

main

if "${VBOX_INSTALLED}"; then
    log_info "Rebooting to apply VirtualBox Guest Additions..."
    sudo reboot
fi
