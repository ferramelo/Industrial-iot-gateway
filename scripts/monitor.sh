#!/bin/bash

echo "================================================"
echo "  🔍 Industrial IoT Gateway - Health Check"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running${NC}"
    exit 1
fi

echo "Container Status:"
echo "----------------"

# List of expected containers
containers=("iot-gateway" "timeseries-db" "dashboard")

for container in "${containers[@]}"; do
    if [ "$(docker ps -q -f name=$container)" ]; then
        status=$(docker inspect --format='{{.State.Status}}' $container)
        uptime=$(docker inspect --format='{{.State.StartedAt}}' $container)
        echo -e "${GREEN}✓${NC} $container: ${GREEN}$status${NC}"
        echo "  Started: $uptime"
    else
        echo -e "${RED}✗${NC} $container: ${RED}NOT RUNNING${NC}"
    fi
    echo ""
done

echo "================================================"
echo "Resource Usage:"
echo "----------------"
docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
echo "================================================"
echo "Network Ports:"
echo "----------------"
echo "Listening ports:"
ss -tulpn 2>/dev/null | grep -E '1880|3000|8086' || echo "No ports found"

echo ""
echo "================================================"
