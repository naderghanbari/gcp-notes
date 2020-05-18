## Quotas
- Per project
- Per region
- Can be lifted on a case-by-case basis

## Managed VMWare Solution (2020)
* Great for customers with existing VMWare workloads  
* Fully managed

## Network
* Andromeda: Google's virtual network stack (SDN)
  - Google's own infrastructure and services use Andromeda
* 1 Petabit/s bisection bandwidth (Jupyter network fabric)
  - Enough for `100k` servers to talk at `10 Gbps`
  - Enough to scan Library of Congress in `0.1s`! 
* 10Gbps bandwidth between any two nodes in the same zone.
  - Racks don't matter anymore (e.g. this renders HDFS original rack-ware design obsolete) 
  - For Skylake and later `16` vCPUs, same-zone VM-to-VM is capped at `32 Gbps`
* All outgoing traffic is encrypted by GCP
  - Specialized chipset on NICs encrypt data  

## Cloud SQL
* Managed MySql, Postgres, SQL Server
* `30 GB` capacity with `60k IOPS`
* Auto scale and auto backup

## BigQuery
* Two components in one:
  - Globally scalable storage service based on Google's Colossus file system
  - Fast highly-parallel SQL engine
    - Available as a separate service: BigQuery Query Engine
    - Works with its native storage as well as GCS, Sheets, CSV, etc.
    - Join data sources (Join CSV files with Postgres!) 
* Columnar data store
* `bq` command line
* Public global datasets
* Very generous free tier (free quota per month) 
* Native support for `ARRAY` and `STRUCT` data types  
* Native support for `GIS`
  - Big Query Geo Viz ( viz dashboard)
* Big Query ML: create and train ML models with SQL!

## Cloud Dataflow
* Serverless fully managed data processing solution
* Unified programming model for `batch` jobs and `streaming` jobs
* Based on Apache Beam programming model
* Preexisting templates (Pub/Sub to BigQuery, etc.)
* Auto scaling to millions of QPS

## Data Studio
* Visualizations
* Based on Google Drive (reports live in or are presented in Drive?)
* Share only report non the underlying data

## Auto ML
* Offers supervised ML without writing code
* Labeling service to make labeling easier and faster

## ML APIs
* Speech to text, TTS, Vision API, Translate, etc.

## ML Engine
* Managed notebooks and jobs (TF, Keras)

## Data Loss Prevention API
* Redaction, anonymization

## Data Catalog

## Cloud Composer
* Managed Apache Airflow as a service
* Workflow orchestration
