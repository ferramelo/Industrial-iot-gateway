# PLC Ladder Logic Projects

## Overview

Esempi di programmazione PLC in Ladder Logic per integrazione con gateway IoT.

## Competenze

- Programmazione PLC (Ladder Logic)
- Logiche di controllo industriale
- Integrazione PLC-SCADA via Modbus
- Tag mapping

## Progetto Esempio: Controllo Temperatura

### Obiettivo
Sistema di controllo con:
- Lettura sensore analogico
- Controllo ON/OFF riscaldatore
- Allarmi soglia
- Mappatura dati SCADA

### Tag Modbus Mapping

| Tag PLC | Modbus Address | Tipo | Descrizione |
|---------|----------------|------|-------------|
| MW100 | 40001 | INT16 | Temperatura (x10) |
| Q0.0 | 00001 | BOOL | Riscaldatore ON/OFF |
| M0.1 | 10002 | BOOL | Allarme temperatura alta |

### Integrazione Gateway

Il gateway Node-RED legge questi tag via Modbus TCP.

---

*Documentazione PLC Ladder Logic - Competenze Automazione Industriale*
