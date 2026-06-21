# 🏗️ SQL Data Warehouse Project (PostgreSQL)

## 📌 Overview
This project demonstrates an end-to-end data warehousing solution built with **PostgreSQL**,
following the **Medallion Architecture** (Bronze → Silver → Gold).

The goal is to consolidate raw data from two source systems — **CRM** and **ERP** — and
transform it into clean, business-ready analytical views through structured ETL pipelines.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Primary database engine |
| pgAdmin | Query execution and database management |
| DrawIO | Architecture and flow diagrams |
| GitHub | Version control |

---

## 🏗️ Data Architecture

![Data Architecture](docs/data_architecture.png)

| Layer | Schema | Description |
|---|---|---|
| **Bronze** | `bronze` | Raw data loaded as-is from CRM and ERP CSV files |
| **Silver** | `silver` | Cleansed, standardized and validated data |
| **Gold** | `gold` | Business-ready views modeled into a star schema |

---

## 🔄 Data Flow

![Data Flow](docs/data_flow.png)
