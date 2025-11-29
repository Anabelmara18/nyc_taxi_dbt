# NYC Yellow Taxi Trips Data Warehouse

## Project Overview
A modern, end-to-end data engineering pipeline built using *Databricks Delta Live Tables (DLT)* and *dbt*.
This project ingests NYC Yellow Taxi trip data, cleans it, enriches it, and produces analytics-ready fact and dimension tables.

---

## Pipeline Architecture

| Layer  | Description |
|--------|-------------|
| Bronze | Raw ingestion of taxi trip data into Delta Lake, minimal cleaning. |
| Silver | Cleaned and validated data; handled nulls, duplicates, outliers, and added engineered columns (e.g., `trip_duration_minutes`, `fare_per_mile`). |
| Gold   | Enriched fact table and daily aggregated summaries for analytics; categories for distance, fare, and duration. |

---

## Key Columns

| Column | Description |
|--------|-------------|
| VendorID | Taxi provider ID |
| tpep_pickup_datetime | Trip start timestamp |
| tpep_dropoff_datetime | Trip end timestamp |
| passenger_count | Number of passengers |
| trip_distance | Distance of trip |
| RatecodeID | Rate code type |
| PULocationID / DOLocationID | Pickup / Dropoff location IDs |
| payment_type | Payment type |
| fare_amount, extra, tip_amount, total_amount, ... | Fare-related fields |
| trip_duration_minutes | Engineered column: duration in minutes |
| fare_per_mile | Engineered column: fare per mile |
| distance_category | short / medium / long |
| fare_category | low / medium / high |
| duration_category | quick / normal / long |

---

## DBT Models

| Model | Description | Source |
|-------|------------|--------|
| `stg_trip` | Staging table for cleaned silver data | Silver Layer |
| `dim_payment_type` | Payment type dimension | `stg_trip` |
| `dim_location` | Pickup/dropoff location dimension | Lookup table |
| `dim_date` | Date dimension | Generated |
| `fact_trip` | Full enriched fact table | Silver Layer |
| `gold_daily_summary` | Aggregated daily metrics | Fact Table |

---

## Categories

| Category | Definition |
|----------|------------|
| Distance | short (<1 mi), medium (1-5 mi), long (>5 mi) |
| Fare     | low (<=10), medium (10-50), high (>50) |
| Duration | quick (<=10 min), normal (10-30 min), long (>30 min) |

---

## Running the Pipeline

1. Clone repository:  
```
git clone <your-repo-url>
cd <repo-folder>

```
 

2. Install DBT:
```
pip install dbt-databrickst

```

3. Configure profiles.yml with your Databricks workspace.

4. Run DBT models:
```
dbt run

```

5. Test models:
```
dbt test

```
6. Generate documentation:
```
dbt docs generate
dbt docs serve

```

## Project Structure

```
├── models/
│   ├── staging/
│   ├── core/
│   ├── marts/
│   │   ├── dimensions/
│   │   └── facts/
├── seeds/
├── snapshots/
├── macros/
├── tests/
├── dbt_project.yml
└── README.md
```

## Data Models Overview
### Staging Models (stg_)

- Source-aligned cleaned tables

- Renamed and standardized column names

- Basic data quality fixes applied

- Directly sourced from the Silver layer

### Core Models

- Contain business logic transformations:

- trip_duration_minutes

- fare_per_mile

Categorization fields:

- distance_category

- fare_category

- duration_category

### Marts Models (Dimensions + Facts)
Dimensions

- dim_date

- dim_location

- dim_payment_type

Fact Table

- fact_trip — enriched Gold-level dataset

Aggregated Model

- gold_daily_summary — daily performance metrics

### Tests Implemented

To ensure reliability and data quality, the following dbt generic tests were added:

- Generic Tests

- unique

- not_null

- accepted_values

- relationships

## Example Test Snippet

```
version: 2

models:
  - name: fact_trip
    tests:
      - unique:
          column_name: trip_id
      - not_null:
          column_name: tpep_pickup_datetime
      - relationships:
          to: ref('dim_location')
          field: PULocationID
```

## Future Improvements

Planned enhancements for the project:

- Add additional fact tables (e.g., monthly summaries)

- Implement dbt snapshots for historical SCD tracking

- Add advanced custom tests using macros

- Integrate CI/CD using GitHub Actions

- Add metrics using dbt Semantic Layer

- Add monitoring/alerting with Databricks Jobs or Workflows

## Contributing

- Contributions are welcome!

- Fork the repository

- Create a new feature branch

- Commit your changes

- Open a pull request to main

## About Me

Built by Francisca Amrachi Amankwe
Data Engineer 
passionate about pipelines, dbt, Databricks, and analytics.
