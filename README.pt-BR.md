# Furukawa GPON Automation & NetOps Suite

[![Docs: English](https://img.shields.io/badge/Docs-English-blue.svg)](README.md)
[![Docs: Português (BR)](https://img.shields.io/badge/Docs-Portugu%C3%AAs%20(BR)-green.svg)](README.pt-BR.md)
[![Docs: Español](https://img.shields.io/badge/Docs-Espa%C3%B1ol-orange.svg)](README.es.md)
[![Stack: Bash + Expect](https://img.shields.io/badge/Stack-Bash%20%7C%20Expect%20%7C%20MySQL-4EAA25.svg)](#)
[![Fabricante: Furukawa GPON](https://img.shields.io/badge/Fabricante-Furukawa%20OLT%20GPON-0052CC.svg)](#)
[![Licença: MIT](https://img.shields.io/badge/Licen%C3%A7a-MIT-lightgrey.svg)](LICENSE)

> **Suíte de automação para provisionamento de OLTs GPON Furukawa, auditoria de sinal óptico (dBm), diagnóstico ativo de CPEs, integração com banco MySQL de assinantes e verificação de backups em hypervisors XenServer para operações de NOC.**

Desenvolvida originalmente em 2020 para operação real em provedor (ISP) e refatorada em 2026 com arquitetura modular e práticas modernas de segurança.

## Funcionalidades
- **Ciclo de Vida GPON Furukawa (`src/olt/`):** Tratativa completa da ONU (`show onu info`, `model-name`, `firmware version`, `olt mac`, `ip-host`, ARP, syslog não-volátil), bloqueio/desbloqueio administrativo, upgrade de perfil de banda (`50M`/`100M` em **G400R**, **G420W**, **ONT100**, **DM984**), download e commit de firmware (`os1`/`os2`), cancelamento (`no onu`), reboot remoto, limpeza SNMP e inventário da frota.
- **Sondas Ativas de NOC (`src/diagnostics/`):** Rajada ICMP de 128 pacotes (`ping -i 0.1 -c 128`) e relatório de rota MTR até a CPE.
- **Auditoria de Sinal Óptico (`src/analytics/`):** Classificação automática de RX em `OK`, `WARNING <= -26 dBm` e `CRITICAL <= -28 dBm`.
- **Base de Assinantes e Auditoria XenServer (`src/database/`, `src/hypervisor/`):** CRUD MySQL sanitizado e auditoria consolidada de logs de backup nos hypervisors XenServer.

## Início Rápido

    cp .env.example .env
    chmod +x bin/start.sh src/**/*.sh
    ./bin/start.sh

**Autor:** Abel Luis Francia
