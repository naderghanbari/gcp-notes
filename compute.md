# Compute Engine

Predefined or custom virtual machines.

## [Series](https://cloud.google.com/compute/docs/machine-types#machine_type_comparison)

| Series | Purpose                     | Architecture                 | Max memory |
| ------ | --------------------------- | ---------------------------- | ---------- |
| `N2`   | Price - Performance Balance | Intel Cascade Lake           | `640 GB`   |
| `N2D`  | Compute - Memory Balance    | AMD EPYC Rome                | `768 GB`   |
| `E2`   | Lowest total cost           | Any available!               | `128 GB`   |
| `C2`   | High-end vCPU               | Intel Cascade Lake           | `240 GB`   |
| `M2`   | Memory-optimized            | Intel Skylake & predecessors | `12 TB`    |
| `M1`   | First gen of `M2`           | Intel Skylake & predecessors | `3.5 TB`   |
| `N1`   | First gen of `N2`           | Intel Skylake & predecessors | `624 GB`   |

* `1 GB` = [`1 GiB`](https://en.wikipedia.org/wiki/Gibibyte) = `1024 MB`

## Key Features

* **Live migration** between physical hosts while running!
  - Default behavior during maintenance window of physical nodes or hosts 
* **Per-second** billing!
* **Sustained and Committed savings**
  - Discounts for sustained use up to 57%
    - No upfront commitment, no instance-type lock-in
* OS patch management
* **Preemptible** VMs up to `80%` cheaper
* **Reservable**
* Persistent disk
  - Durable, HDD or SSD, snapshot-ready, survives VM termination
  - Not physically attached to the host
* **Local SSD**
  - Physically attached to host for very high IOPS
* **GPU** and **TPU**
  - Add or remove at any time to save cost
* Grouping and global load-balancing
* Recommendation engine
  - Recommends resizing or deleting for optimum cost!
  - Detects a VM as idle if (in the past 14 days)
    - `< 0.03 vCPU` used `97%` of time
    - `< 2000 B/s` ingress for `95%` of time
    - `< 1000 B/s` egress for `95%` of time
  - Monitoring-aware (if monitoring agent is installed its metrics will be used)     
* Placement policy
  - Pose constraints on where and what hardware you want your VMs to run
* **Shielded VMs**
  - vTPM to detect tampering for high-security purposes
* **Automatic Restart**
  - Can be turned off
* Virtual Displays
* Virtual NIC (new generation created by Google)
  - Up to `50 - 100 Gbps` speed now!
* Deletion Protection
  - Can be turned on irrespective of the state of the VM (stopped, running)    

## Custom Machine Types
* Different pricing
  - Minimum charge of `1 minute` still applies
* Memory must be a multiple of `256 MB` (e.g. `6.75 GB`)
* vCPU count must be `1` or `even`
* For `N1` machine types:
  - Up to `96 vCPU` (Skylake series)
  - Up to `64 vCPU` (Other CPU platforms)
  - `[0.9, 6.5] GB` per vCPU
    - for higher amounts -> `extended memory`       
* For `N2` machine types (only select zones):
  - `[2, 96] vCPU` (Cascade Lake series)
    - Having only `1` vCPU not allowed
    - `#vCPU > 32` -> `vCPU mod 4 MUST be 0`
  - `[0.5, 8.0] GB` per vCPU
    - for higher amounts -> `extended memory`       
* For `N2D` machine types (only select zones):
  - `[2, 96] vCPU` (AMD EPYC Rome)
    - Only `{2, 4, 8, 12, 16, 32, 48, 64, 96}` allowed
  - `[0.5, 8.0] GB` per vCPU
    - for higher amounts -> `extended memory`       
* For `E2` machine types (only select zones):
  - `[2, 16] vCPU` (AMD EPYC Rome)
  - `[0.5, 8.0] GB` per vCPU
* Shared-Core machines
  - `N1` or `E2`

## Creating a VM
* Naming convention similar to domain names [RFC 1035](https://www.ietf.org/rfc/rfc1035.txt)
* From public images
* From custom images
* Right away from a docker image (docker hub)
* MBR (up to `2 TiB` only)

## Preemptible VMs
* Always get terminated after `24h`
* May get terminated earlier
* Much cheaper than normal VMs
* No SLA!
  - Use with caution
  - Use only for fault-tolerant use cases.
  - Make sure state is external to VMs and jobs can be resumed after incarnation
* Check if an instance is preemptible (both form outside and inside the VM itself)       
* Many smaller VMs is better than a few larger ones
  - Smaller ones have a lower rate of termination
* Design your workload to be fault tolerant to mass preemption

## Sole-Tenancy
* First find out what node types are available
  - `gcloud compute sole-tenancy node-types list`
  - `n1-node-96-624`for instance: `96 vCPU` - `624 GB` RAM (56 physical cores)
* Node group
  - How many sole-tenant nodes and in what zone
  - Minimum of two at least required
    - Default vCPU quota of `72` is not enough for two nodes (`192` vCPUs)
  - Autoscaling (_beta_)

## Disks
* Boot Disks
  - Can now be detached and re-attache to/from a stopped VM
  - Permissions: `compute.instances.detachDisk/attachDisk`
  - Max `2TB` (MBR limitation)
* Zonal Persistent Disks
  - Up to 127 secondary zonal disks
  - Up to a total of `257 TB`
  - Growable (resize even if the disk is attached to a VM)   
    - Should not delete any data but backup a snapshot anyway
  - Share it in the `read-only mode` between multiple VMs
  - Default block size of `4KB` (like most physical disks)
    - Can be set to `16KB` only at creation time (suitable for some databases for instance)    
* Regional Persistent Disks
  - Synchronous replication across two zones
  - Can't be used as boot disks and can be created only from snapshots
  - Minimum size of `200 GB`  
  - CP solution (availability is sacrificed for strong consistency)
    - If one disk is unavailable operations still proceed with the healthy disk
  - Share it in the `read-only mode` between multiple VMs
  - Default block size of `4KB` (like most physical disks)
    - Can be set to `16KB` only at creation time (suitable for some databases for instance)    
* Local SSD
  - Attached to physical node
  - Each `375 GB` in size. Up to `8` allowed per VM. (Up to `24` in _beta_)
  - Only suitable for temporary data (cache, etc.)
    - In [most cases of termination](https://cloud.google.com/compute/docs/disks/local-ssd#data_persistence) data will be lost
    - Do not use with preemptible VMs!!  
  - Multiple local SSDs can form a single logical volume
  - NVMe for bets performance or multi-SCSI
  - Throughput is capped by the capacity (imposed by GCP?)   
* Cloud Storage Buckets mountable via FUSE
* RAM disk (as usual, nothing specific to GCP Compute Engine)

## Windows Servers
* Activation needs access to `kms.windows.googlecloud.com`
  - External or internal IP needed for activation
  - Route to `kms.windows.googlecloud.com` with `next-hop=default-internet-gateway`
* May be showing as running but `sysprep` still in progress
  - Probe to see readiness:
    - `gcloud compute instances get-serial-port-output [INSTANCE_NAME]`
* Automatic Google-provided components with auto update
* Password set/reset via `gcloud` and Console

## Extended Memory
* Qualifies for sustained use
* Increments of `256 MB`
* Does not support committed use discount!
* Suitable for in-memory databases

## Virtual Network Interface gVNIC (_beta_)
* Google-made virtual network interface and driver
* Faster than the standard current [virtIO](http://docs.oasis-open.org/virtio/virtio/v1.0/virtio-v1.0.html)-based driver
* Support for `50 - 100 Gbps`

## Connecting to VMs
* Using `gcloud compute ssh` or Console
  - Host keys can be stored as guest attributes for added security
    - Instance metadata must be enabled for this behavior (not a very reliable default)
* Using bastion host
* Using `ssh`
  - External or internal ip (both can be done with `gcloud compute ssh`)    
* Through IAP (SSH wrapped inside HTTPS with TCP forwarding!)
* To move files use `gcloud compute scp` or from the Console in the browser
* OS Login
  - Use IAM roles to grant/revoke ssh access

## Serial Port
* Useful for troubleshooting (4 virtual ports per instance)
* Can be connected to Stackdriver logs for longer retention   

## Life Cycle
- `PROVISIONING` -> `STAGING` -> `RUNNING` (pay for VM and attached resources)
- `STOPPING`, `REPAIRING`
- `TERMINATED` (pay only for static IPs and attached persistent disks)
- Stopping sends ACPI Power Off signal -> graceful shutdown (metadata is maintained)
- Resetting is like a hard reset, VM remains in `RUNNING` (non-graceful)
- Deleting removes the instance forever, but keeps persistent disks
  - Unless Iif persistent disks have `auto-delete = true`
  - Static IPs return to the project pool for reuse
- MAC address is based on internal IP, to reuse the same MAC address use the same internal IP
after deleting an instance

## Network Bandwidth
- Accounted for at VM level. Number of IPs or vNICs don't make a difference. It's the cloud after all!
- Internal IP ingress is unlimited (still limited by resources and physics of course!)
- External IP ingress has a limit per VM: `1,800,000 packets/s` or `20Gb/s`

## Service Accounts
- VMs by default use the default service account
  - This default account has `project/editor` role!! To add IAM roles to it you must revoke
  `project/editor` role from it (this role is there for legacy reasons)
- Add new service accounts and use them at creation time or stop the VM and assign the account
- Both `gsutil` and `gcloud` on VMs are aware of service account and will work out of the box

## Metadata Server
- Accessible from within the VM with no authorization required or from Compute Engine API
- A simple key/value store.

## Placement Policy
- Spread: up to 8 instances per policy (does not support E2, sole-tenant and reserved)
- Compact: up to 22 instances per policy (support only C2 non-sole-tenant non-reserved)
