# System Architecture
## Industrial IoT Gateway

> Industrial IoT Gateway per integrazione protocolli OT (Modbus, OPC UA) con piattaforme IT moderne.

---

## 1. Architecture

### 1.1 Layer Overview

```mermaid
flowchart TB
    subgraph OT["🏭 Field Level — OT"]
        PLC1["⚙️ PLC 1\nModbus"]
        PLC2["⚙️ PLC 2\nProfinet"]
        SCADA["🖥️ SCADA"]
        SENSORS["📡 Sensors"]
    end

    PLC1 & PLC2 & SCADA & SENSORS -->|"Modbus TCP / OPC UA"| GW

    subgraph EDGE["🔀 Gateway Level — Edge Computing"]
        subgraph GW["Node-RED IoT Gateway"]
            MODBUS["Modbus Client"]
            MQTT["MQTT Broker"]
            OPCUA["OPC UA Client"]
        end
        NOTE["Protocol Translation | Data Normalization"]
    end

    GW -->|"HTTP / MQTT"| DB

    subgraph DATA["📊 Data & Visualization Layer"]
        DB["🗄️ InfluxDB\nTime-Series DB\n─────────────\n• Metrics\n• Alarms\n• Historical"]
        GRAFANA["📈 Grafana\nDashboard\n─────────────\n• Visualization\n• Alerting\n• Reporting"]
        DB -->|reads| GRAFANA
    end

    style OT fill:#0d1f2d,stroke:#00d4ff,color:#e8f4f8
    style EDGE fill:#0b1d30,stroke:#00ff9d,color:#e8f4f8
    style DATA fill:#0c1a28,stroke:#ff8c42,color:#e8f4f8
    style GW fill:#0a1a25,stroke:#00ff9d,color:#e8f4f8
    style DB fill:#1a1000,stroke:#ff8c42,color:#e8f4f8
    style GRAFANA fill:#1a1400,stroke:#ffd166,color:#e8f4f8
```

---

## 2. Components

### 2.1 Node-RED Gateway (`iot-gateway`)

- **Purpose:** Protocol translation and data routing
- **Technology:** Node.js-based flow programming

**Protocols Supported:**
- Modbus TCP/RTU
- OPC UA Client
- MQTT (publish/subscribe)
- HTTP REST APIs

**Key Functions:**
- Poll PLC data via Modbus
- Normalize data formats
- Apply business logic
- Route to InfluxDB

---

### 2.2 InfluxDB (`timeseries-db`)

- **Purpose:** Time-series data storage
- **Technology:** InfluxDB 2.7

**Data Organization:**
- Organization: `industrial`
- Bucket: `iot-data`
- Retention: 30 days

---

### 2.3 Grafana (`dashboard`)

- **Purpose:** Data visualization and monitoring
- **Technology:** Grafana latest

**Features:**
- Real-time dashboards
- Alerting system
- Multi-source queries

---

## 3. Network Architecture

### 3.1 Port Mapping

| Service   | Internal Port | External Port | Protocol |
|-----------|--------------|--------------|----------|
| Node-RED  | 1880         | 1880         | HTTP     |
| InfluxDB  | 8086         | 8086         | HTTP     |
| Grafana   | 3000         | 3000         | HTTP     |

### 3.2 Data Flow

1. **Data Acquisition:** Node-RED polls PLC via Modbus TCP
2. **Data Processing:** Value scaling and validation
3. **Data Storage:** Write to InfluxDB via HTTP API
4. **Data Visualization:** Grafana queries InfluxDB

---

## 4. Deployment Model

### 4.1 Containerization Benefits

- **Portability:** Run on any Linux system
- **Scalability:** Easy horizontal scaling
- **Isolation:** Services isolated from host
- **Reproducibility:** Consistent environments

### 4.2 Resource Requirements

| Resource | Minimum      | Recommended  |
|----------|-------------|-------------|
| CPU      | 2 cores     | 4+ cores    |
| RAM      | 4 GB        | 8 GB        |
| Storage  | 20 GB       | 50+ GB      |
| Network  | 100 Mbps    | 1 Gbps      |

---

*Document Version: 1.0 — Last Updated: February 2025*
