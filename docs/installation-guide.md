# Installation Guide

## Prerequisites

### System Requirements
- **OS**: Linux (Ubuntu 20.04+, Debian 11+)
- **CPU**: 2+ cores
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 20GB free space

### Software Requirements
- Docker Engine 20.10+
- Docker Compose v2.0+
- Git 2.0+
- Bash shell

## Installation Steps

### 1. Install Docker

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Verify installation
docker --version
docker compose version
