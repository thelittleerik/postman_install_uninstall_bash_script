#!/bin/bash
# postman.sh - Install or Uninstall Postman on Ubuntu
#
# Usage:
#   ./postman.sh install   # To install Postman
#   ./postman.sh uninstall # To uninstall Postman

# Variables
DOWNLOAD_URL="https://dl.pstmn.io/download/latest/linux64"
ARCHIVE_NAME="postman.tar.gz"
TEMP_DIR="/tmp/postman_install"
INSTALL_DIR="/opt/Postman"
SYMLINK="/usr/bin/postman"
DESKTOP_ENTRY="/usr/share/applications/postman.desktop"

function install_postman() {
    echo "Installing Postman..."

    # Create a temporary directory for the download
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR" || exit 1

    echo "Downloading Postman from $DOWNLOAD_URL..."
    wget -O "$ARCHIVE_NAME" "$DOWNLOAD_URL" || { echo "Download failed"; exit 1; }

    echo "Extracting Postman archive..."
    tar -xzf "$ARCHIVE_NAME" || { echo "Extraction failed"; exit 1; }

    echo "Moving Postman to $INSTALL_DIR..."
    sudo mv Postman "$INSTALL_DIR" || { echo "Failed to move Postman"; exit 1; }

    echo "Creating symbolic link at $SYMLINK..."
    sudo ln -sf "$INSTALL_DIR/Postman" "$SYMLINK" || { echo "Failed to create symlink"; exit 1; }

    echo "Creating desktop entry at $DESKTOP_ENTRY..."
    sudo bash -c "cat > $DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Name=Postman
Exec=$INSTALL_DIR/Postman
Icon=$INSTALL_DIR/app/resources/app/assets/icon.png
Type=Application
Categories=Development;
Terminal=false
EOF

    echo "Updating desktop database..."
    sudo update-desktop-database

    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"

    echo "Postman installation complete. You can launch Postman by running 'postman' in the terminal."
}

function uninstall_postman() {
    echo "Uninstalling Postman..."

    echo "Removing installation directory $INSTALL_DIR..."
    sudo rm -rf "$INSTALL_DIR"

    echo "Removing symbolic link $SYMLINK..."
    sudo rm -f "$SYMLINK"

    echo "Removing desktop entry $DESKTOP_ENTRY..."
    sudo rm -f "$DESKTOP_ENTRY"

    echo "Updating desktop database..."
    sudo update-desktop-database

    echo "Postman has been uninstalled."
}

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [install|uninstall]"
    exit 1
fi

case "$1" in
    install)
        install_postman
        ;;
    uninstall)
        uninstall_postman
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: $0 [install|uninstall]"
        exit 1
        ;;
esac
