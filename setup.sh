#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages based on the package manager
install_packages() {
    if command_exists apt-get; then
        sudo apt-get install -y "$@"
    elif command_exists yum; then
        sudo yum install -y "$@"
    elif command_exists dnf; then
        sudo dnf install -y "$@"
    elif command_exists zypper; then
        sudo zypper install -y "$@"
    elif command_exists pacman; then
        sudo pacman -Sy --noconfirm "$@"
    elif command_exists brew; then
        brew install "$@"
    elif command_exists port; then
        sudo port install "$@"
    else
        echo "Unable to determine package manager. Please install the required packages manually."
        exit 1
    fi
}

# Function to gather OS information
gather_os_info() {
    if command_exists lsb_release; then
        OS_NAME=$(lsb_release -si)
        OS_VERSION=$(lsb_release -sr)
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_VERSION=$VERSION_ID
    elif command_exists sw_vers; then
        OS_NAME="macOS"
        OS_VERSION=$(sw_vers -productVersion)
    else
        echo "Unable to determine OS information. Please install the required packages manually."
        exit 1
    fi
}

# Gather OS information
gather_os_info

# Install required packages based on OS
if [[ $OS_NAME == "Ubuntu" || $OS_NAME == "Debian" ]]; then
    install_packages autoconf libtool automake g++
elif [[ $OS_NAME == "Fedora" || $OS_NAME == "CentOS" || $OS_NAME == "Red Hat Enterprise Linux" ]]; then
    install_packages autoconf libtool automake gcc-c++
elif [[ $OS_NAME == "openSUSE Leap" || $OS_NAME == "openSUSE Tumbleweed" ]]; then
    install_packages autoconf libtool automake gcc-c++
elif [[ $OS_NAME == "Arch Linux" ]]; then
    install_packages autoconf libtool automake gcc
elif [[ $OS_NAME == "Windows" ]]; then
    echo "Windows is not supported. Please install the required packages manually."
    exit 1
elif [[ $OS_NAME == "macOS" ]]; then
    install_packages autoconf libtool automake gcc
else
    echo "Unsupported OS: $OS_NAME $OS_VERSION. Please install the required packages manually."
    exit 1
fi

# Continue with the existing code
./bootstrap.sh && ./configure && make && make install

# Install additional packages if needed
if [[ $OS_NAME == "Ubuntu" || $OS_NAME == "Debian" ]]; then
    install_packages bluez-tools
fi
