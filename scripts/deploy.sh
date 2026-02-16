#!/bin/bash
set -e

echo "================================================"
echo "  🚀 Industrial IoT Gateway - Deployment"
echo "================================================"
echo ""

# Check Docker installation
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose not found. Please install Docker Compose."
    exit 1
fi

echo "✓ Docker and Docker Compose found"
echo ""

# Pull latest images
echo "📦 Pulling latest images..."
docker compose pull

echo ""

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker compose down

echo ""

# Start services
echo "▶️  Starting services..."
docker compose up -d

echo ""

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 15

# Health check
echo "🔍 Service status:"
docker compose ps

echo ""
echo "================================================"
echo "  ✅ Deployment Complete!"
echo "================================================"
echo ""
echo "Access services at:"
echo "  • Node-RED:  http://localhost:1880"
echo "  • Grafana:   http://localhost:3000 (admin/admin)"
echo "  • InfluxDB:  http://localhost:8086"
echo ""
echo "View logs: docker compose logs -f"
echo "================================================"
