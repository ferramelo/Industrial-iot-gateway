#!/bin/bash

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="gateway_backup_${TIMESTAMP}.tar.gz"

echo "================================================"
echo "  💾 Industrial IoT Gateway - Backup"
echo "================================================"
echo ""

# Create backup directory
mkdir -p $BACKUP_DIR

echo "Creating backup: $BACKUP_FILE"
echo ""

# Backup Docker volumes
echo "📦 Backing up Docker volumes..."
docker run --rm \
  -v nodered-data:/nodered \
  -v influxdb-data:/influxdb \
  -v grafana-data:/grafana \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine tar czf /backup/$BACKUP_FILE -C / nodered influxdb grafana

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Backup completed successfully!"
    echo "   File: $BACKUP_DIR/$BACKUP_FILE"
    echo "   Size: $(du -h $BACKUP_DIR/$BACKUP_FILE | cut -f1)"
    
    # Keep only last 5 backups
    echo ""
    echo "🧹 Cleaning old backups (keeping last 5)..."
    cd $BACKUP_DIR
    ls -t gateway_backup_*.tar.gz | tail -n +6 | xargs -r rm
    echo "   Current backups: $(ls -1 gateway_backup_*.tar.gz | wc -l)"
else
    echo ""
    echo "❌ Backup failed!"
    exit 1
fi

echo ""
echo "================================================"
