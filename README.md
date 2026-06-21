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

---

## 📊 Data Model

![Data Model](docs/data_model.png)

| Object | Type | Description |
|---|---|---|
| `gold.dim_customers` | Dimension Table | Cleaned and integrated customer details including name, gender, marital status, birthdate and country — sourced from CRM and ERP |
| `gold.dim_products` | Dimension Table | Product details including category, subcategory, product line and cost — filtered to active products only |
| `gold.fact_sales` | Fact Table | Sales transactions with order dates, shipping dates, quantity, price and sales amount — linked to customers and products via surrogate keys |

---

## 🛠️ Transformations Applied (Silver Layer)

### Data Cleansing
- Removed duplicates using `ROW_NUMBER()` window function
- Handled NULL and invalid values using `COALESCE` and `CASE`
- Fixed invalid dates stored as integers
- Removed unwanted prefixes and spaces from IDs

### Data Standardization
- Normalized gender values to `Male`, `Female`, `n/a`
- Normalized marital status to `Single`, `Married`, `n/a`
- Normalized country codes to full country names

### Data Enrichment
- Derived product end dates using `LEAD()` window function
- Recalculated incorrect sales figures from quantity and price
- Integrated CRM and ERP customer data — CRM treated as master source

---

## 🧠 Key SQL Concepts Used

```sql
-- Stored Procedures
CREATE OR REPLACE PROCEDURE silver.load_silver()

-- Window Functions
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC)
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)

-- Conditional Logic
CASE WHEN ... THEN ... END
COALESCE(value, 'n/a')

-- Data Type Casting
CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)

-- Aggregations and Joins
LEFT JOIN, GROUP BY, NULLIF()
```

---

## 📂 Project Structure

```
dwh_project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│   ├── source_crm/                     # CRM source CSV files
│   └── source_erp/                     # ERP source CSV files
│
├── docs/                               # Project documentation and architecture details
│   ├── data_architecture.png           # Architecture diagram of the data warehouse
│   ├── data_catalog.md                 # Catalog of datasets including field descriptions
│   ├── data_flow.png                   # Data flow diagram across Bronze, Silver and Gold
│   ├── data_integration.png            # Integration diagram showing how CRM and ERP connects
│   └── data_model.png                  # Star schema data model diagram
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   │   ├── ddl_bronze.sql              # Create bronze tables
│   │   └── proc_load_bronze.sql        # Load raw data into bronze
│   ├── silver/                         # Scripts for cleansing and transforming data
│   │   ├── ddl_silver.sql              # Create silver tables
│   │   └── proc_load_silver.sql        # Load cleansed data into silver
│   ├── gold/                           # Scripts for creating analytical views
│   │   └── proc_load_gold.sql          # Create gold views
│   └── tests/                          # Data quality and validation scripts
│       ├── quality_checks_silver.sql   # Silver layer quality checks
│       └── quality_checks_gold.sql     # Gold layer quality checks
│
├── init_database.sql                   # Database and schema initialization script
├── README.md                           # Project overview and instructions
└── LICENSE                             # License information for the repository
```
## 🚀 How to Run

1. Clone the repository
```bash
git clone https://github.com/your-username/sql-data-warehouse-project.git
```

2. Open pgAdmin and connect to your PostgreSQL server

3. Execute scripts in this order:
```sql
-- Step 1: Initialize database and schemas
scripts/init_database.sql

-- Step 2: Create bronze tables
scripts/bronze/ddl_bronze.sql

-- Step 3: Load raw data into bronze layer
scripts/bronze/proc_load_bronze.sql
CALL bronze.load_bronze();

-- Step 4: Create silver tables
scripts/silver/ddl_silver.sql

-- Step 5: Load cleansed data into silver layer
scripts/silver/proc_load_silver.sql
CALL silver.load_silver();

-- Step 6: Create gold analytical views
scripts/gold/proc_load_gold.sql
```

4. Run quality checks:
```sql
-- Validate silver layer
scripts/tests/quality_checks_silver.sql

-- Validate gold layer
scripts/tests/quality_checks_gold.sql
```

5. Query the gold layer:
```sql
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;
```
## 🎯 Project Outcome

This project simulates a real-world data warehouse by:
- Building a fully layered ETL pipeline from raw CSV to analytical views
- Applying data quality rules and business logic at the Silver layer
- Creating a clean star schema ready for BI tools and reporting
- Documenting the full data architecture and integration model

---

## 💡 Future Enhancements
- [ ] Build a Power BI or Tableau dashboard on top of the gold views
- [ ] Add incremental loading to the bronze layer
- [ ] Implement data quality checks as automated test scripts

---

⭐ If you found this project useful, consider starring the repository — it helps others discover it!
