# System Architecture

## Overview

Industrial IoT Gateway per integrazione protocolli OT (Modbus, OPC UA) con piattaforme IT moderne.

## Architecture Diagram

┌─────────────────────────────────────────────────────────────┐
│ Field Level (OT) │
├─────────────────────────────────────────────────────────────┤
│ │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│ │ PLC 1 │ │ PLC 2 │ │ SCADA │ │ Sensors │ │
│ │ Modbus │ │ Profinet│ │ │ │ │ │
│ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ │
│ │ │ │ │ │
└───────┼─────────────┼─────────────┼─────────────┼────────┘
│ │ │ │
└─────────────┴─────────────┴─────────────┘
│
Modbus TCP / OPC UA
│
┌─────────────────────────▼─────────────────────────────────┐
│ Gateway Level (Edge Computing) │
├────────────────────────────────────────────────────────────┤
│ │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Node-RED IoT Gateway │ │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ │ │
│ │ │ Modbus │ │ MQTT │ │ OPC UA │ │ │
│ │ │ Client │ │ Broker │ │ Client │ │ │
│ │ └──────────┘ └──────────┘ └──────────┘ │ │
│ │ │ │
│ │ Protocol Translation | Data Normalization │ │
│ └──────────────────┬───────────────────────────────┘ │
│ │ │
└─────────────────────┼─────────────────────────────────────┘
│
HTTP/MQTT
│
┌─────────────────────▼─────────────────────────────────────┐
│ Data & Visualization Layer │
├────────────────────────────────────────────────────────────┤
│ │
│ ┌──────────────────┐ ┌──────────────────┐ │
│ │ InfluxDB │ │ Grafana │ │
│ │ Time-Series DB │◄────────┤ Dashboard │ │
│ │ │ │ │ │
│ │ - Metrics │ │ - Visualization │ │
│ │ - Alarms │ │ - Alerting │ │
│ │ - Historical │ │ - Reporting │ │
│ └──────────────────┘ └──────────────────┘ │
│ │
└────────────────────────────────────────────────────────────┘

text

## Components

### 1. Node-RED Gateway (iot-gateway)
**Purpose**: Protocol translation and data routing  
**Technology**: Node.js-based flow programming  
**Protocols Supported**:
- Modbus TCP/RTU
- OPC UA Client
- MQTT (publish/subscribe)
- HTTP REST APIs

**Key Functions**:
- Poll PLC data via Modbus
- Normalize data formats
- Apply business logic
- Route to InfluxDB

### 2. InfluxDB (timeseries-db)
**Purpose**: Time-series data storage  
**Technology**: InfluxDB 2.7  

**Data Organization**:
- Organization: `industrial`
- Bucket: `iot-data`
- Retention: 30 days

### 3. Grafana (dashboard)
**Purpose**: Data visualization and monitoring  
**Technology**: Grafana latest  

**Features**:
- Real-time dashboards
- Alerting system
- Multi-source queries

## Network Architecture

### Port Mapping
| Service | Internal Port | External Port | Protocol |
|---------|---------------|---------------|----------|
| Node-RED | 1880 | 1880 | HTTP |
| InfluxDB | 8086 | 8086 | HTTP |
| Grafana | 3000 | 3000 | HTTP |

## Data Flow

1. **Data Acquisition**: Node-RED polls PLC via Modbus TCP
2. **Data Processing**: Value scaling and validation
3. **Data Storage**: Write to InfluxDB via HTTP API
4. **Data Visualization**: Grafana queries InfluxDB

## Deployment Model

### Containerization Benefits
- **Portability**: Run on any Linux system
- **Scalability**: Easy horizontal scaling
- **Isolation**: Services isolated from host
- **Reproducibility**: Consistent environments

### Resource Requirements
- **CPU**: 2 cores minimum
- **RAM**: 4GB minimum (8GB recommended)
- **Storage**: 20GB
- **Network**: 100Mbps minimum

---

**Document Version**: 1.0  
**Last Updated**: February 2026
