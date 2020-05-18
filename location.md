# Resource Location: Global, Regional, Zonal
- Only determines where the resource resides and from where it is accessible
- No bearing on uniqueness of names or ids across a project
  - For instance a VM name must still be unique in a project regardless of being zonal or regional  

## Global Resources
* Addresses (global static IP addresses)
* Disk images (such as preconfigured images provided by Google)
* Disk snapshots (can be even shared between projects)
* Instance templates (zonal resources in the template impose constraints)
* Cloud Interconnect and Interconnect locations
* VPC Networks (individual subnets are regional)
* Firewalls
* Routes
* Dataproc Clusters (can be global or regional but a zone is still needed)

## Multi-Regional Resources (Large Geographic Areas)
* Datasets
  - US (all data centers in US)
  - EU (only data centers within the 27 member states)
    - Excludes London and Zürich regions 

## Regional Resources
* Addresses (regional static IP addresses)
* Interconnect attachments
* Subnets of VPC networks
* Regional instance groups
* Regional persistent disks
* Datasets (as of now supports only select regions)

## Zonal Resources
* VM instances
* Zonal persistent disks
* Machine types
* Zonal instance groups 

## Clusters
* A zone is housed in multiple clusters
* Multiple clusters in a data center 
  - each with a fully independent stack (power, cooling, hardware, software)
* For each organization GCP maps `zone` -> `cluster`
  - GCP does its best to do a consistent mapping  
