## Study Material
- Coursera Specializations 
  - Data engineering
  - Kubernetes engine
  - Architecture with GCP
- Official study guides
  - Associate, Data Engineering, Architecture with GCP
- Official mock exams
  - Take all of them even if you are only studying for the Architect exam
- GCP docs
  - Start with the `All Concepts` section of each product
  - https://cloud.google.com/files/storage_architecture_and_challenges.pdf
- Qwiklabs quests
  - 30 days of free access to any lab   
- Play yourself
  - Free tier allows experimenting with almost everything
  - Be careful not to run out of credits
    - Good practice for setting up billing alerts and quotas 
- Google publications (https://research.google/pubs/) 

# Main themes

## A separation, Compute from Storage
* 1 Petabit/s bisection bandwidth (Jupyter network fabric)
  - Enough for `100k` servers to talk at `10 Gbps`
  - Enough to scan Library of Congress in `0.1s`! 
* It does not make sense anymore to not decouple storage from compute 

## Trade control for productivity, ease of mind, scalability, and cost-effectiveness 
* Serverless, Fully Managed Service, PaaS, IaaS, YAOYWB (aka You are on your own buddy)

## You don't have to fully give up on OSS
* GCP offers many open source technologies either as a serverless or fully managed service
  - Dataflow, based on Apache Beam
  - Dataproc, based on Hadoop and Spark ecosystems
  - CloudSQL, supports MySQL and Postgres
  - Cloud Composer, based on Apache Airflow
  - Cloud Dataflow, based on Apache Beam
  - GKE, based on Kubernetes
* etc
  - Compute Engine, support for running Docker images
  - Bigtable, inspiration behind Apache Cassandra (along with Amazon's Dynamo) and HBase
    - API and clients compatible with HBase

## GCP Free Tier
- One year `$300` free trial with access to most resources
- Free tier after that with limited access to many services 

## SLA, SLI, SLO

## Quotas
- Per project
- Per region
- Can be lifted on a case-by-case basis

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
    - Very fast approximate statistics (approximate counts)
    - Shows execution details of each query!
      - Slot time (linear actual time representing total computing power used for the query)
      - Bytes shuffled (very important metric to minimize during schema design)
      - Breakdown of wait, I/O (read, write) and compute
* Columnar data store
* `bq` command line
* Public global datasets
* Join many datasets in one query
* Very generous free tier (free quota per month) 
* Native support for `ARRAY` and `STRUCT` data types  
* Native support for `GIS`
  - Big Query Geo Viz (viz dashboard for GIS)
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
* Supports standard SQL time windows and functions `LAG`, `LEAD`, etc.
* Read-only access to `INFORMATION_SCHEMA` and `TABLES` to explore metadata
  - Follows the ANSI standard 
* Streaming and time travel
  - Streaming API (charged, unlike batch insertion)
* Query caching
  - Based on the actual SQL test not the AST :( Even a single whitespace difference, and it will be a miss
  - Query must be referentially transparent (no streaming, no external sources, no DML, no time-dependency)
  - The underlying table or view has not changed since last execution
  - Cached result sets get evicted after `24h` 
* BI Engine
  - Keeps the most frequently accessed parts of your dataset in memory
  - Reserve a specific amount of memory in a region or multi-region
  - Maximum `100GB` at the moment
  - Pretty expensive, makes sense only if calculations predict a cost optimization

```genericsql
SELECT *
FROM `demos.average_speeds`
FOR SYSTEM_TIME AS OF TIMESTAMP_SUB(CURRENT_TIMESTAMP, INTERVAL 10 MINUTE)
ORDER BY timestamp DESC
LIMIT 100;
```

## Cloud Dataflow
* Serverless data processing solution
  - Integrated with GCP monitoring
  - Visualizes the pipeline DAG
  - Shows very fine-grained metric charts and autoscaling history  
* Unified programming model for `batch` and `streaming` jobs
  - Based on Apache Beam pipelines
  - 100 times better than Hadoop's MapReduce programming model!
* Preexisting templates (Pub/Sub to BigQuery, etc.)
* Auto scaling to millions of QPS
* First choice for creating new pipelines or transformations
* Apache Beam provides an abstract way of defining data pipelines
  - How to run a pipeline is left as an exercise to the reader
    - Just kidding; The actual runners or backends will run the pipeline
    - Google is the maintainer of Dataflow runner for Apache Beam
  - Has a concept of `PCollection` which is very similar to Spark's `RDD`s   
* SQL Pipelines and BigQuery support (still in alpha? //TODO\\) 
* Supports Beam window types
  - Fixed time (every `30m` non-overlapping)
  - Sliding time (`30m` wide every `10m`, can overlap) 
  - Session windows (based on a key in data, and a minimum gap between windows)
* Not all trigger types designed by Beam are supported at the moment?
  - Python pipelines support only `AfterWatermark` triggers (this may have changed?)
  - Java pipelines support more types of triggers. Check the Beam runner docs for up-to-date info
* Late data handling
  - Supports two accumulation modes: `accumulate`, and `discard`

## Data Studio
* Visualizations (At its current state, it's like a mini Tableau)
* Based on Google Drive (reports live in or are presented in Drive?)
* Share only report not the underlying data
* Supports various data sources such as BigQuery, Google Sheets, etc.
* Supports custom queries
* Refer to 
 query history for cost estimation

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

## Cloud Pub/Sub
* Serverless data ingestion service (async message bus)
* `Topic/Subscription/Subscriber` model
  - Only messages published after the subscription is created are available to subscribers
* Client libraries in most programming languages
  - REST API wrapper
* Highly Available (runs in most regions around thw world)
* Durability
  - By default, it saves messages up to 7 days
* Highly Scalable    
  - Used by Google's search engine at a rate of `100 million messages per second`
* [HIPPA compliant](https://cloud.google.com/security/compliance/hipaa)
  - End to end encryption (at transit and at rest)
  - Fine grained access control
* The central piece of modern architectures, decoupling systems (isolation of many things)  
* Patterns
  - Cardinality: [`Linear`, `Fan-in`, `Fan-out`]
* Models
  - Push based
  - Pull based
    - Async pull
    - Sync pull (explicit fetching of messages, a single message or a batch at a time)
* At-least once delivery semantics
  - Configurable ack deadline per subscription
  - Can replay events   
* Message payload can be up to `10MB` (text or binary)
* Messages can have key-value metadata
  - Useful for adding metadata without having to add it to the payload
  - This could help with evolution of a system without re-engineering all messages
* Publisher
  - Sends messages in batch (configurable with `BatchSettings`)  
* Late, out of order, or duplicate messages may happen
  - Solvable with other techniques

## Managed VMWare Solution (2020)
* Great for customers with existing VMWare workloads  
* Fully managed

## BigTable
* Custer-based fully-managed self-learning HA NoSQL database for high throughput and low latency
  - Latency in the `ms`s
  - `~ 100k` queries per second for 10 nodes (linear scalability)
  - Very fast writes
  - Fault tolerant
  - Use only for large volumes of data `> 300 GB`
  - Heatmap visualization for reads and writes by row keys!
  - API-compatible and client-compatible with HBase
* Based on the Colossus file system
  - Similar to the first generation of Google's distributed file system, GFS
  - Similar to HDFS which is also inspired by GFS
     - Actual data is stored redundantly in blobs on file system nodes
       - Default replication factor = `3`
     - Tablets point to data chunks
     - Metadata in each cluster node (in memory?)
* Row-based columnar database
  - Tables with rows and columns
  - Only one index per row, namely the row key
  - Data is organized lexicographically based on row keys
    - Minimal set of operations (think RISC)  
  - Column families (like Cassandra, HBase)
    - Up to 100 families without significant performance degradation
  - Tombstones for deleted rows with periodic compacting  
* Most queries can't be optimized automatically
  - Design the row key and your queries so that most operations becomes a scan
  - Take advantage of the lexicographical ordering of row keys  
* Learns access patterns
  - Redistributes tablets across nodes so that writes and reads are evenly distributed
  - Gives priority to reads if reads and writes have non-similar distributions    
* Performance optimization
  - Optimize the schema
  - Add more nodes (almost linear scalability)
  - Use SDD for VM nodes of the cluster
  - Put clients in the same zone as Bigtable
* Multiple instances of the same cluster can co-exist
  - Create anther instance in another zone for HA and automatic failover
    - `gcloud bigtable clusters create $CUSTER_ID --instance=$INSTANCE_ID --zone=$ZONE`
  - Can be used for segregation of reads and writes
  - Provides near-real-time backup 
