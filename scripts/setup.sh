#!/bin/bash

# TJYAai Setup Script
# This script sets up the development environment for TJYAai

set -e

echo "🚀 Setting up TJYAai Development Environment..."

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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    print_status "Creating .env file from .env.example..."
    cp .env.example .env
    print_warning "Please edit .env file with your actual API keys and configuration"
fi

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p models/stable-diffusion
mkdir -p models/real-esrgan
mkdir -p models/gfpgan
mkdir -p models/fomm
mkdir -p models/rembg
mkdir -p templates/dance
mkdir -p templates/motion
mkdir -p uploads
mkdir -p temp

# Set permissions
chmod +x scripts/*.sh

print_success "Directory structure created successfully!"

# Build Docker images
print_status "Building Docker images..."
docker-compose build

print_success "Docker images built successfully!"

# Start services
print_status "Starting services..."
docker-compose up -d postgres redis minio

# Wait for services to be ready
print_status "Waiting for services to be ready..."
sleep 10

# Run database migrations (when implemented)
print_status "Database setup will be handled by the backend service..."

print_success "🎉 TJYAai setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your API keys"
echo "2. Run 'docker-compose up' to start all services"
echo "3. Visit http://localhost:3000 for the frontend"
echo "4. Visit http://localhost:8000/docs for the API documentation"
echo ""
echo "Services:"
echo "- Frontend: http://localhost:3000"
echo "- Backend API: http://localhost:8000"
echo "- MinIO Console: http://localhost:9001 (admin/password123)"
echo "- PostgreSQL: localhost:5432"
echo "- Redis: localhost:6379"