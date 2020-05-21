## A separation

## GCP Free Tier
- One year `$300` free trial with access to most resources
- Free tier after that with limited access to many services 

## Hassle-Control Spectrum
* Serverless, Fully Managed Service, PaaS, IaaS, YAOYW
* GCP offers many open source technologies either as a serverless or fully managed service
  - Dataflow, based on Apache Beam
  - Dataproc, based on Hadoop and Spark ecosystems
  - CloudSQL, based on MySQL, Postgres, and SQL Server (proprietary) 
  - Cloud Composer, based on Apache Airflow
  - Cloud Dataflow, based on Apache Beam

## SLA, SLI, SLO

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

## OLTP vs OLAP
* OLTP: Lots of writes, simple queries to read
  - Analogy: bookkeeping everyday company transactions and see the balance of each account as of now 
* OLAP: Heavy reads spanning lots of data (scattered through time and space)
  - Analogy: getting audited for the past 5 years, show me your books, how much did you pay in salaries in 2017? 

## Cloud Storage (GCS)
* Object store
  - Ideal for data lakes
* Buckets: containers of objects
  - Globally unique name (releasable)
  - Don't use sensitive data in the bucket name! 
    - Names are publicly searchable!
* Objects: blobs od data
  - Metadata (ACL, compression, lifecycle management)
  - Simulates a file system by allowing `/` in file names 
  - Scan needed for moving things around (choose names and structure carefully)
* Automatic replication (99.999999999% durability)
* Location and storage class
  - Multi-regional, regional
  - Location can never be changed after creation
* Class: Standard, Regional, Nearline, Coldline (cost efficiency based on access frequency)
* Versioning
* Retentions policy
  - Lifecycle management (e.g. move the object to nearline after 30 days)
* Bucket roles: Reader, Writer, Owner
* Automatic mandatory encryption with auto-rotating KEKs
* Immutable audit logs!
* Locks: bucket lock, retention lock, object hold
* Signed URLs for anonymous sharing

## Cloud KMS (Key Management Service)
* GMEK: Google Manages KEKs and rotates them
* CMEK: Customer manages the creation and existence of KEKs
* CSEK: Customer provides (supplies) the KEK 
* In addition to these options, customers of course can encrypt the data themselves off GCP  

## Cloud SQL
* Fully managed MySql, Postgres, SQL Server
* `30 GB` capacity with `60k IOPS`
* Auto scale and auto backup
  - Vertical scale for writes and horizontal for reads
  - Automatic creation of replicas 
* `99.95%` availability (might be higher now?)
* Replication:
  - Read replicas in the same zone as master
  - External master (could be outside GCP or on a GCP VM) (good for backing up on-prem data stores)
  - External replicas (replicas outside GCP)
* Failover
  - Read replicas in the same region but different zones
    - Failover replicas incur cost of course 
    - Auto promotion as master in case of failover (with a new read replica created automatically)
    - Post apocalypse relocation is available
  - In case of failover existing connections drop (no automagical hand off at this time)
    - Design with resiliency (retry the same connection string a few times before giving up) 

## Cloud Spanner
* Global scalable pretty expensive relational database 

## BigQuery
* Two components in one:
  - Globally scalable storage service based on Google's Colossus file system
    - Columnar database
      - Compressed columns (each column is lossless-compressed with RLE run-length encoding)
    - Partition keys (each partition a single blob in a shard)
      - Three kinds
        - Ingestion time (partitioned by arrival time!), pseudo column `_PARTITIONTIME`
        - Timestamp column (YEAR, MONTH, DATE)
        - Integer column (range)
      - Can be enforced (so that queries must filter by it)
      - Cluster keys
        - Sort key within each partition (hence only applicable to partitioned tables)
        - BigQuery automatically reclusters periodically!! (just like good old disk defrag)
      - Partition key and cluster key both contribute to pre-flight cost estimation and performance optimization      
  - Fast highly-parallel query engine
    - Based on [Dremel](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/36632.pdf)
    - Available as a separate service: BigQuery Query Engine
    - Works with its native storage as well as GCS, Sheets, CSV, etc.
    - Join data sources (Join CSV files with Postgres!) 
    - Shows execution details of each query!
      - Slot time (linear actual time representing total computing power used for the query)
      - Bytes shuffled (very important metric to minimize during schema design)
* Columnar data store
* `bq` command line
* Public global datasets
* Join many datasets in one query
* Very generous free tier (free quota per month) 
* Native support for `ARRAY` and `STRUCT` data types  
* Native support for `GIS`
  - Big Query Geo Viz ( viz dashboard)
* Big Query ML: create and train ML models with SQL!
* Federated queries
  - Query from external sources such as GCS in various formats (Parquet, CSV, Avro, Apache orc, JSON)
    - Data lives external and only metadata is needed to recognize the data as a legit table
  - Very Similar to Hive's External tables (as opposed to internal or managed tables)
    - In fact BigQuery uses the same partitioning conventions as Hive:
      - `${PREFIX}/year=2019/month=01/day=01/hour=01/....` 
      - In BigQuery only up to 10 partition keys per table is allowed (10 nested levels) 
* Supports `ARRAY` and `STRUCT` types (like standard SQL)
  - Middle ground between normalized and denormalized schemas
  - Often provide very good performance
    - For instance `GROUP BY` on a denormalized repeated column leads to bad performance due to shuffling/sorting  
* Read-only access to `INFORMATION_SCHEMA` and `TABLES` to explore metadata
  - Follows the ANSI standard 

## Cloud Dataflow
* Serverless data processing solution
* Unified programming model for `batch` and `streaming` jobs
  - Based on Apache Beam pipelines
* Preexisting templates (Pub/Sub to BigQuery, etc.)
* Auto scaling to millions of QPS
* First choice for creating new pipelines or transformations

## Data Studio
* Visualizations
* Based on Google Drive (reports live in or are presented in Drive?)
* Share only report non the underlying data

## Auto ML
* Offers supervised ML without writing code
* Labeling service to make labeling easier and faster

## Cloud Dataproc
* Fully managed Hadoop + Spark ecosystem 
* Node and version management (add nodes or update open source software)
* Store jobs off the cluster
 - So you can spin up a new cluster on demand ofr a single job 
* Cost effective: `1 cent/vCPU/cluster/hour`
  - Can use preemtible VMs
  - By-second charging (`1m` min just like Compute Engine)
  - Schedules (shutdown if idle for more than `10m`, or Max lifetime of `2w`)
* Fast operations (`~90s` spin up and shutdown time) 
* Resizable nodes (good luck with that with an on-prem cluster)
* Can be backed by GCS instead of HDFS
  - Hadoop `2.6.5` and later supports GCS 
  - Simply use `gs://` URLs instead of `hdfs://` and the HDFS connector kicks in and does the job
    - Use the same region for the bucket as the cluster, if they are regional
  - Increase the default block size (`128MB`) to `1GB` or `2GB` (`fs.gs.block.size`)
  - HDFS is still needed for the cluster to run in a healthy state
  - Don't use GCS if you rename directories often, or you append to files, or you have partitioned writes
    - In other words for non-linear mutable workloads keep using HDFS 
* HA mode available (`3:n` i.e. 3 master nodes)
* Submitting jobs only through Dataproc (not through standard Hadoop jobs)
* Auto-Zone feature (picks the best zone in the region)
* Integrated with Stackdriver like many other GCP services
  - Spark or Hadoop job logs

## ML APIs
* Speech to text, TTS, Vision API, Translate, etc.

## ML Engine
* Managed notebooks and jobs (TF, Keras)

## Data Loss Prevention API
* Redaction, anonymization

## Data Catalog
* Serverless data discovery and metadata management service

## Data Fusion
* Fully managed data integration solution for building data pipelines
* Based on Dataproc (may support more now? Dataflow was beta)
  - Creates ephemeral Dataproc clusters to run jobs
  - Zero Code paradigm 
* Rule engine for complex business rules 
  - Useful for business or analytics team  
* Developer Studio 
  - GUI similar to Apache NiFi 
* Schedulable batch pipelines

## Cloud Composer
* Managed Apache Airflow as a service backed by GKE
* Workflow orchestration
* Creates interactive Airflow environments
  - DAGs are Python files
* Wrangler
  - A tool to see the effects of the pipeline on a small subset of data    
* Schedulable DAGs
  - Periodic (Pull-based)
  - Event-driven (Push-based)

