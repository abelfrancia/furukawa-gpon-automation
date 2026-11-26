# Furukawa GPON Automation & NetOps Suite

[![Docs: English](https://img.shields.io/badge/Docs-English-blue.svg)](README.md)
[![Docs: Português (BR)](https://img.shields.io/badge/Docs-Portugu%C3%AAs%20(BR)-green.svg)](README.pt-BR.md)
[![Docs: Español](https://img.shields.io/badge/Docs-Espa%C3%B1ol-orange.svg)](README.es.md)
[![Stack: Bash + Expect](https://img.shields.io/badge/Stack-Bash%20%7C%20Expect%20%7C%20MySQL-4EAA25.svg)](#)
[![Vendor: Furukawa GPON](https://img.shields.io/badge/Vendor-Furukawa%20OLT%20GPON-0052CC.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg)](LICENSE)

> **Automated GPON OLT provisioning, optical RX signal auditing, active CPE diagnostics, MySQL subscriber integration, and XenServer backup verification built for ISP Network Operations Centers (NOC).**

Originally developed in 2020 for production ISP operations and refactored in 2026 into a modular, security-hardened portfolio repository.

## Capabilities
- **Furukawa OLT GPON Lifecycle (`src/olt/`):** Full ONU diagnostics (`show onu info`, `model-name`, `firmware version`, `olt mac`, `ip-host`, ARP, non-volatile syslog), administrative `block`/`unblock`, bandwidth profile upgrades (`50M`/`100M` on **G400R**, **G420W**, **ONT100**, **DM984**), remote firmware downloads & dual-bank OS commits (`os1`/`os2`), decommission (`no onu`), remote reboot (`onu reset`), SNMP alarm cleanup, and fleet inventory collection.
- **Active NOC Probes (`src/diagnostics/`):** High-frequency 128-packet ICMP burst latency/jitter test and MTR hop-by-hop path reports.
- **Optical Signal Health Auditor (`src/analytics/`):** Parses dBm RX levels across the OLT fleet (`OK`, `WARNING <= -26 dBm`, `CRITICAL <= -28 dBm`).
- **Subscriber DB & XenServer Audit (`src/database/`, `src/hypervisor/`):** Parameterized MySQL CRUD operations and multi-node XenServer snapshot backup log verification.

## Quick Start

    cp .env.example .env
    chmod +x bin/start.sh src/**/*.sh
    ./bin/start.sh

**Author:** Abel Luis Francia
