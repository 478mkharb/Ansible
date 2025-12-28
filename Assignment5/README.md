# Ansible Infrastructure Automation – App + Monitoring Stack

## Overview

This project demonstrates a **production-style Ansible role-based automation** to deploy:

- A **Java-based application (Task-Master-Pro)** on one `app` server
- A **complete monitoring stack** (Prometheus, Blackbox Exporter, Grafana) on another `monitoring` server
- **Node Exporter** on the `app` server for system metrics
- Fully managed services using **systemd**
- Clean separation of concerns using **Ansible roles**

The setup follows real-world DevOps best practices: idempotency, modular roles for both `RedHat` and `Debian` servers, GitOps-style configuration, and observability-first design.

---

## Architecture
```lua
+---------------------------+        +-------------------------------+
|  App Server [web-server]  |        | Monitoring Server [Centos9]   |
|---------(Debian) ---------|        |------------(RedHat)-----------|
| • Java Application        | -----> | • Prometheus                  |
| • Node Exporter (9100)    |        | • Blackbox Exporter (9115)    |
| • systemd service         |        | • Grafana (3000)              |
| • App Port (8080)         |        | • Dashboards & Alerts         |
+---------------------------+        +-------------------------------+
```
---
## What This Project Does

### Application Server (app)
- Installs Java, Maven, Git
- Clones **Task-Master-Pro** repository
- Builds application using Maven
- Runs the application using **systemd (java -jar)**
- Exposes application on port `8080`
- Runs **Node Exporter** on port `9100`

### Monitoring Server (monitoring)
- Installs and configures **Prometheus**
- Scrapes:
  - Node Exporter metrics from app server 
  - Blackbox HTTP probe metrics for application health
- Installs and configures **Blackbox Exporter** (port `9115`)
- Installs and configures **Grafana**
- Auto-provisions:
  - Prometheus datasource
  - Dashboards (Node Exporter & Blackbox)
---

## Directory Structure Explained

```lou
Assignment5/
.
├── ansible.cfg
├── inventory
│   └── hosts.yml
├── README.md
├── roles
│   ├── app_server
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   ├── build.yml
│   │   │   ├── main.yml
│   │   │   ├── packages.yml
│   │   │   └── service.yml
│   │   ├── templates
│   │   │   └── app.service.j2
│   │   └── vars
│   │       ├── debian.yml
│   │       └── redhat.yml
│   ├── blackbox
│   │   ├── files
│   │   │   └── blackbox.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   └── tasks
│   │       ├── main.yml
│   │       ├── redhat.yml
│   │       └── ubuntu.yml
│   ├── grafana
│   │   ├── files
│   │   │   ├── dashboards.yml
│   │   │   └── datasource-prometheus.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   └── tasks
│   │       ├── main.yml
│   │       ├── redhat.yml
│   │       └── ubuntu.yml
│   ├── node_exporter
│   │   ├── files
│   │   │   └── node_exporter.service
│   │   ├── handlers
│   │   │   └── main.yml
│   │   └── tasks
│   │       ├── main.yml
│   │       ├── redhat.yml
│   │       └── ubuntu.yml
│   └── prometheus
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── tasks
│       │   ├── main.yml
│       │   ├── redhat.yml
│       │   └── ubuntu.yml
│       ├── templates
│       │   ├── prometheus.service.yml.j2
│       │   └── prometheus.yml.j2
│       └── vars
│           └── main.yml
├── site.yml
└── vars
    └── all.yml

28 directories, 38 files
```
---

## Role Breakdown

### 1. App_server (Application)
**Purpose:** Deploy Java application  
**Key Actions:**
- Install Java + Maven
- Clone application repo
- Build JAR using Maven
- Dynamically find built JAR
- Create `systemd` service
- Run app as background service

**Service:**
```bash
/etc/systemd/system/task-master-pro.service
```


---

### 2. Blackbox
**Purpose:** Application health monitoring  
**Checks:**
- HTTP status (2xx)
- Response time
- SSL certificate expiry

**Port:** `9115`

---

### 3. Grafana
**Purpose:** Visualization and dashboards  
**Features:**
- Auto-provision Prometheus datasource
- Auto-load dashboards
- Uses file-based provisioning (GitOps style)

**Dashboards:**
- Prometheus All Metrics
- Node Exporter Full
- Prometheus Blackbox Exporter
---

### 4. Node_Exporter
**Purpose:** Expose host-level metrics  
**Port:** `9100`  
**Metrics:**
- CPU, memory, disk, filesystem, load

---

### 5. prometheus
**Purpose:** Central metrics collection  
**Config File:**
```bash
/opt/monitoring/prometheus/prometheus.yml
```

**Scrapes:**
- `node_exporter` from app server
- `blackbox` probes for application URL

---

## How to Run

### 1. Configure Inventory
Edit:
```bash
inventory/prod/hosts.yml
```

Ensure:
- `app` group has app server
- `monitoring` group has monitoring server

---

### 2. Run Playbook

```bash
ansible-playbook site.yml
```

---

## Access URLs

```lua

| Service        | URL                                 |
|----------------|-------------------------------------|
| Application    | http://<app_ip_addr>:8080           |
| Node Exporter  | http://<app_ip_addr>:9100/metrics   |
| Prometheus     | http://<mon_ip_addr>:9090           |
| Blackbox       | http://<mon_ip_addr>:9115           |
| Grafana        | http://<mon_ip_addr>:3000           |
```
###  Default Grafana login:
```bash
admin / admin
```
### Screenshots of Playbook 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-32-19.png>) 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-32-45.png>) 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-34-03.png>) 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-34-35.png>) 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-34-51.png>)

### Screenshot of Application 
![alt text](<Screenshots/Screenshot from 2025-12-27 21-44-13.png>)

### Screenshot of Node_Exporter with metrics
![alt text](<Screenshots/Screenshot from 2025-12-27 21-44-34.png>)
![alt text](<Screenshots/Screenshot from 2025-12-27 21-44-04.png>)

## Screenshot of Prometheus Targets
![alt text](<Screenshots/Screenshot from 2025-12-27 21-42-41.png>)

## Screenshot of Blackbox Exporter
![alt text](<Screenshots/Screenshot from 2025-12-27 21-50-38.png>)

## Screenshot of Grafana Dashboards
![alt text](<Screenshots/Screenshot from 2025-12-27 21-49-56.png>)

## Screenshot of Grafana (Node_Exporter) Dashboard
![alt text](<Screenshots/Screenshot from 2025-12-27 21-39-40.png>)

## Screenshot of Grafana (Prometheus) Dashboard
![alt text](<Screenshots/Screenshot from 2025-12-27 21-39-04.png>)

## Screenshot of Grafana (Blackbox) Dashboard
![alt text](<Screenshots/Screenshot from 2025-12-27 21-41-51.png>)
---

## Troubleshooting Guide

### Grafana dashboard not updating?
✔️ Increment `"version"` in dashboard JSON  
✔️ Restart Grafana  
✔️ Hard refresh browser

---

### Blackbox dashboard shows no data?
✔️ Check Prometheus targets:
```bash
/targets
```
- ✔️ Verify application is reachable
- ✔️ Confirm `probe_success` metric exists

---

### Node Exporter dashboard empty?
✔️ Confirm Node Exporter running
✔️ Ensure Prometheus job name matches dashboard

---

### Prometheus targets missing?
✔️ Check `prometheus.yml`
✔️ Verify EC2 IPs resolve correctly
✔️ Restart Prometheus service

---

## Key Learnings from This Project

- Importance of **role separation**
- Managing services via **systemd**
- Difference between:
  - Application ports
  - Metrics ports
- How Prometheus, Blackbox & Grafana work together
- Grafana **provisioned dashboards behavior**
- Real-world Ansible debugging & idempotency

---

## Future Enhancements

- Add Alertmanager
- Slack / Email alerts
- HTTPS monitoring
- Multi-application support
- CI/CD integration

---

## Author

**Mukesh Kharb**  
Batch -33

