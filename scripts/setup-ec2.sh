#!/bin/bash

# Astro Tourism Deployment Script for Amazon EC2
# This script sets up the environment and deploys the application

set -e

echo "🚀 Starting Astro Tourism deployment on EC2..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script as root or with sudo"
    exit 1
fi

# Update system packages
print_status "Updating system packages..."
apt-get update && apt-get upgrade -y

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker ubuntu
    rm get-docker.sh
    print_success "Docker installed successfully"
else
    print_warning "Docker is already installed"
fi

# Install Docker Compose
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed successfully"
else
    print_warning "Docker Compose is already installed"
fi

# Install additional tools
print_status "Installing additional tools..."
apt-get install -y git curl wget unzip htop nginx-common

# Create application directory
print_status "Setting up application directory..."
APP_DIR="/opt/astro_tourism"
mkdir -p $APP_DIR
cd $APP_DIR

# Set up firewall
print_status "Configuring firewall..."
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Create docker group and add ubuntu user
print_status "Setting up Docker permissions..."
groupadd -f docker
usermod -aG docker ubuntu

# Create systemd service for auto-start
print_status "Creating systemd service..."
cat > /etc/systemd/system/astro-tourism.service << EOF
[Unit]
Description=Astro Tourism Application
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$APP_DIR
ExecStart=/usr/local/bin/docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
ExecStop=/usr/local/bin/docker-compose -f docker-compose.yml -f docker-compose.prod.yml down
TimeoutStartSec=0
User=ubuntu

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable astro-tourism.service

# Set up log rotation
print_status "Setting up log rotation..."
cat > /etc/logrotate.d/astro-tourism << EOF
/var/lib/docker/containers/*/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    copytruncate
}
EOF

# Create deployment info
cat > $APP_DIR/deployment-info.txt << EOF
Astro Tourism Deployment Information
===================================
Deployed on: $(date)
EC2 Instance: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
Public IP: $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
Application Directory: $APP_DIR

Services:
- Frontend: React.js application
- Backend: Python Flask API
- Reverse Proxy: Nginx

Docker Containers:
- astro_tourism_nginx (Port 80, 443)
- astro_tourism_frontend
- astro_tourism_backend

Commands:
- Start: sudo systemctl start astro-tourism
- Stop: sudo systemctl stop astro-tourism
- Status: sudo systemctl status astro-tourism
- Logs: docker-compose logs -f

Deployment completed successfully!
EOF

print_success "EC2 setup completed!"
print_status "Application directory: $APP_DIR"
print_status "Next steps:"
echo "1. Clone your repository to $APP_DIR"
echo "2. Run: sudo systemctl start astro-tourism"
echo "3. Check status: sudo systemctl status astro-tourism"
echo "4. View logs: cd $APP_DIR && docker-compose logs -f"

print_warning "Don't forget to:"
echo "- Configure your domain DNS to point to this EC2 instance"
echo "- Set up SSL certificates if needed"
echo "- Configure monitoring and backups"