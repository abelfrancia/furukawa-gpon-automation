# Furukawa GPON Automation & NetOps Suite

[![Docs: English](https://img.shields.io/badge/Docs-English-blue.svg)](README.md)
[![Docs: Português (BR)](https://img.shields.io/badge/Docs-Portugu%C3%AAs%20(BR)-green.svg)](README.pt-BR.md)
[![Docs: Español](https://img.shields.io/badge/Docs-Espa%C3%B1ol-orange.svg)](README.es.md)
[![Stack: Bash + Expect](https://img.shields.io/badge/Stack-Bash%20%7C%20Expect%20%7C%20MySQL-4EAA25.svg)](#)
[![Fabricante: Furukawa GPON](https://img.shields.io/badge/Fabricante-Furukawa%20OLT%20GPON-0052CC.svg)](#)
[![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-lightgrey.svg)](LICENSE)

> **Suite de automatización para aprovisionamiento de OLTs GPON Furukawa, auditoría de señal óptica (dBm), diagnóstico activo de CPEs, integración con base de datos MySQL y verificación de respaldos en hipervisores XenServer para centros de operaciones de red (NOC).**

Desarrollada originalmente en 2020 para operaciones reales en proveedores de telecomunicaciones (ISP) y refactorizada en 2026 con arquitectura modular y estándares modernos de seguridad.

## Capacidades
- **Ciclo de Vida GPON Furukawa (`src/olt/`):** Diagnóstico completo de ONU (`show onu info`, `model-name`, `firmware version`, `olt mac`, `ip-host`, ARP, syslog no volátil), bloqueo/desbloqueo administrativo, cambio de perfil de ancho de banda (`50M`/`100M` en **G400R**, **G420W**, **ONT100**, **DM984**), descarga y commit de firmware (`os1`/`os2`), baja de servicio (`no onu`), reinicio remoto, limpieza SNMP e inventario global.
- **Sondas Activas de NOC (`src/diagnostics/`):** Ráfaga ICMP de 128 paquetes (`ping -i 0.1 -c 128`) y análisis de ruta MTR hacia la CPE.
- **Auditoría de Señal Óptica (`src/analytics/`):** Clasificación automática de potencia RX en `OK`, `WARNING <= -26 dBm` y `CRITICAL <= -28 dBm`.
- **Base de Suscriptores y Auditoría XenServer (`src/database/`, `src/hypervisor/`):** Operaciones CRUD en MySQL y verificación consolidada de respaldos en hipervisores XenServer.

## Inicio Rápido

    cp .env.example .env
    chmod +x bin/start.sh src/**/*.sh
    ./bin/start.sh

**Autor:** Abel Luis Francia
