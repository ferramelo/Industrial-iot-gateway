# PLC-SCADA Tag Mapping

> Documento di mappatura tra tag PLC (livello campo) e variabili SCADA/IoT Gateway.

---

## 1. Naming Convention

### 1.1 PLC Side (Modbus Registers)

```
<AREA>_<TIPO>_<ID>
```

| Campo  | Descrizione                        | Esempio   |
|--------|------------------------------------|-----------|
| `AREA` | Zona impianto (es. `L1`, `TK`, `P`)| `L1`      |
| `TIPO` | Tipo grandezza (`TMP`, `PRS`, `FLW`)| `TMP`   |
| `ID`   | Numero progressivo (3 cifre)       | `001`     |

**Esempi:** `L1_TMP_001`, `TK_PRS_002`, `P_FLW_003`

### 1.2 SCADA / IoT Gateway Side

```
<site>/<area>/<device>/<measure>
```

| Campo      | Descrizione                  | Esempio          |
|------------|------------------------------|------------------|
| `site`     | Identificativo impianto      | `plant01`        |
| `area`     | Zona funzionale              | `line1`          |
| `device`   | Dispositivo fisico           | `sensor_01`      |
| `measure`  | Grandezza misurata           | `temperature`    |

**Esempi:** `plant01/line1/sensor_01/temperature`

---

## 2. Modbus Register Map

### 2.1 Register Types

| Tipo Registro | Codice Funzione | Accesso    | Descrizione              |
|---------------|----------------|------------|--------------------------|
| Holding Register | FC03        | Read/Write | Valori analogici, setpoint |
| Input Register   | FC04        | Read Only  | Misure da campo          |
| Coil             | FC01        | Read/Write | Uscite digitali          |
| Discrete Input   | FC02        | Read Only  | Ingressi digitali        |

### 2.2 Data Types & Scaling

| Tipo    | Registri | Formato        | Esempio                        |
|---------|----------|----------------|--------------------------------|
| `INT16` | 1        | Intero 16-bit  | Temperatura × 10 → 253 = 25.3°C |
| `UINT16`| 1        | Unsigned 16-bit| Pressione 0–65535              |
| `FLOAT32`| 2       | IEEE 754       | Portata in virgola mobile      |

---

## 3. Tag Mapping Table

### 3.1 Temperature

| PLC Tag      | Modbus Addr | FC   | Type    | Scale  | Unit | SCADA / MQTT Topic                        | Description            |
|--------------|-------------|------|---------|--------|------|-------------------------------------------|------------------------|
| `L1_TMP_001` | 30001       | FC04 | INT16   | ÷ 10   | °C   | `plant01/line1/sensor_01/temperature`     | Temp. ingresso linea 1 |
| `L1_TMP_002` | 30002       | FC04 | INT16   | ÷ 10   | °C   | `plant01/line1/sensor_02/temperature`     | Temp. uscita linea 1   |
| `TK_TMP_001` | 30010       | FC04 | INT16   | ÷ 10   | °C   | `plant01/tank1/sensor_01/temperature`     | Temp. serbatoio 1      |
| `TK_TMP_002` | 30011       | FC04 | FLOAT32 | ×1     | °C   | `plant01/tank1/sensor_02/temperature`     | Temp. serbatoio 2 (PT100) |
| `TK_TMP_SP`  | 40010       | FC03 | INT16   | ÷ 10   | °C   | `plant01/tank1/ctrl_01/temp_setpoint`     | Setpoint temperatura   |

### 3.2 Pressione

| PLC Tag      | Modbus Addr | FC   | Type    | Scale     | Unit  | SCADA / MQTT Topic                        | Description             |
|--------------|-------------|------|---------|-----------|-------|-------------------------------------------|-------------------------|
| `L1_PRS_001` | 30020       | FC04 | UINT16  | ÷ 100     | bar   | `plant01/line1/sensor_01/pressure`        | Pressione ingresso L1   |
| `L1_PRS_002` | 30021       | FC04 | UINT16  | ÷ 100     | bar   | `plant01/line1/sensor_02/pressure`        | Pressione uscita L1     |
| `TK_PRS_001` | 30030       | FC04 | FLOAT32 | ×1        | bar   | `plant01/tank1/sensor_01/pressure`        | Pressione serbatoio 1   |
| `L1_PRS_SP`  | 40020       | FC03 | UINT16  | ÷ 100     | bar   | `plant01/line1/ctrl_01/pressure_setpoint` | Setpoint pressione      |

### 3.3 Portata (Flow)

| PLC Tag      | Modbus Addr | FC   | Type    | Scale  | Unit   | SCADA / MQTT Topic                      | Description              |
|--------------|-------------|------|---------|--------|--------|-----------------------------------------|--------------------------|
| `L1_FLW_001` | 30040       | FC04 | FLOAT32 | ×1     | m³/h   | `plant01/line1/sensor_01/flow`          | Portata linea 1          |
| `L1_FLW_002` | 30042       | FC04 | FLOAT32 | ×1     | m³/h   | `plant01/line1/sensor_02/flow`          | Portata linea 1 (ritorno)|
| `TK_FLW_001` | 30050       | FC04 | FLOAT32 | ×1     | m³/h   | `plant01/tank1/sensor_01/flow`          | Portata ingresso tank 1  |
| `L1_FLW_TOT` | 30052       | FC04 | FLOAT32 | ×1     | m³     | `plant01/line1/sensor_01/flow_total`    | Totalizzatore portata    |

---

## 4. Node-RED Mapping Config (esempio)

```json
[
  {
    "plc_tag": "L1_TMP_001",
    "modbus_address": 30001,
    "function_code": 4,
    "data_type": "INT16",
    "scale": 0.1,
    "offset": 0,
    "unit": "°C",
    "mqtt_topic": "plant01/line1/sensor_01/temperature",
    "influxdb_measurement": "temperature",
    "influxdb_tags": { "area": "line1", "device": "sensor_01" }
  },
  {
    "plc_tag": "L1_PRS_001",
    "modbus_address": 30020,
    "function_code": 4,
    "data_type": "UINT16",
    "scale": 0.01,
    "offset": 0,
    "unit": "bar",
    "mqtt_topic": "plant01/line1/sensor_01/pressure",
    "influxdb_measurement": "pressure",
    "influxdb_tags": { "area": "line1", "device": "sensor_01" }
  },
  {
    "plc_tag": "L1_FLW_001",
    "modbus_address": 30040,
    "function_code": 4,
    "data_type": "FLOAT32",
    "scale": 1.0,
    "offset": 0,
    "unit": "m³/h",
    "mqtt_topic": "plant01/line1/sensor_01/flow",
    "influxdb_measurement": "flow",
    "influxdb_tags": { "area": "line1", "device": "sensor_01" }
  }
]
```

---

## 5. InfluxDB Line Protocol (esempio write)

```
temperature,area=line1,device=sensor_01 value=25.3 1700000000000000000
pressure,area=line1,device=sensor_01 value=1.42 1700000000000000000
flow,area=line1,device=sensor_01 value=12.7 1700000000000000000
```

---

## 6. Alarm Thresholds

| Tag          | Low Low | Low  | High | High High | Unit |
|--------------|---------|------|------|-----------|------|
| `L1_TMP_001` | 5.0     | 10.0 | 80.0 | 90.0      | °C   |
| `TK_TMP_001` | 10.0    | 15.0 | 75.0 | 85.0      | °C   |
| `L1_PRS_001` | 0.5     | 1.0  | 8.0  | 10.0      | bar  |
| `L1_FLW_001` | 1.0     | 2.0  | 50.0 | 60.0      | m³/h |

---

*Document Version: 1.0 — Last Updated: February 2025*
