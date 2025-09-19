#!/bin/bash

# Deployment script for Astro Tourism application
# Run this script after setting up EC2 with setup-ec2.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please run setup-ec2.sh first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please run setup-ec2.sh first."
    exit 1
fi

print_status "Starting Astro Tourism deployment..."

# Stop existing containers
print_status "Stopping existing containers..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml down --remove-orphans || true

# Pull latest images and rebuild
print_status "Building application containers..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml build --no-cache

# Start the application
print_status "Starting application containers..."
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Wait for services to be ready
print_status "Waiting for services to start..."
sleep 30

# Health check
print_status "Performing health checks..."

# Check if containers are running
if docker ps | grep -q "astro_tourism_nginx"; then
    print_success "Nginx container is running"
else
    print_error "Nginx container failed to start"
    docker logs astro_tourism_nginx
    exit 1
fi

if docker ps | grep -q "astro_tourism_frontend"; then
    print_success "Frontend container is running"
else
    print_error "Frontend container failed to start"
    docker logs astro_tourism_frontend
    exit 1
fi

if docker ps | grep -q "astro_tourism_backend"; then
    print_success "Backend container is running"
else
    print_error "Backend container failed to start"
    docker logs astro_tourism_backend
    exit 1
fi

# Test health endpoints
print_status "Testing application endpoints..."

# Test main health endpoint
if curl -f http://localhost/health &> /dev/null; then
    print_success "Main health check passed"
else
    print_warning "Main health check failed"
fi

# Test API health endpoint
if curl -f http://localhost/api/health &> /dev/null; then
    print_success "API health check passed"
else
    print_warning "API health check failed"
fi

# Display deployment information
print_success "🎉 Astro Tourism deployment completed!"
echo ""
echo "🌍 Application Information:"
echo "- Application URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
echo "- Health Check: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/health"
echo "- API Health: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/api/health"
echo ""
echo "🐳 Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "📊 Useful Commands:"
echo "- View logs: docker-compose logs -f"
echo "- Restart: docker-compose restart"
echo "- Stop: docker-compose down"
echo "- Status: docker-compose ps"
echo ""
print_warning "Configure your domain DNS to point to this EC2 instance for production use"