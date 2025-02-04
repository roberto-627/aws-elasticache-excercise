AWS ElastiCache Terraform Module
================================

This Terraform module deploys an Amazon ElastiCache cluster (Redis) on AWS, supporting:

*   **Data Sharding (Cluster Mode)** for improved performance and horizontal scalability
    
*   **Automatic Failover** for high availability
    
*   **Security Groups** for controlled network access
    
*   **Cache Subnet Groups** for subnet isolation
    
*   **Parameter Groups** to customize Redis parameters
    
*   **CloudWatch Monitoring** for key metrics
    

Table of Contents
-----------------

1.  [Features](#features)
    
2.  [Architecture Overview](#architecture-overview)
    
3.  [Usage](#usage)
    
4.  [Examples](#examples)
    
5.  [Inputs](#inputs)
    
6.  [Outputs](#outputs)
    
7.  [Requirements](#requirements)
    
8.  [Authors](#authors)
    
9.  [License](#license)
    

Features
--------

1.  **Sharding**: By setting cluster\_mode\_enabled = true, you can distribute data across multiple shards (num\_node\_groups) to improve performance.
    
2.  **Automatic Failover**: When automatic\_failover\_enabled = true, if the primary node fails, a replica is automatically promoted, ensuring high availability.
    
3.  **Security Groups**: Configurable inbound rules using CIDR blocks and/or referenced security group IDs.
    
4.  **Cache Subnet Group**: Define the subnets for the ElastiCache cluster.
    
5.  **Parameter Group**: Override specific Redis parameters for performance tuning.
    
6.  **Monitoring**: Publishes key metrics to CloudWatch automatically. Additional alarms can be created as needed.
    

Architecture Overview
---------------------

When you deploy this module, it creates:

1.  An **AWS Security Group** with inbound and outbound rules for Redis traffic.
    
2.  An **ElastiCache Subnet Group** that includes one or more subnets in your VPC.
    
3.  An **ElastiCache Parameter Group** to apply custom Redis parameter overrides.
    
4.  An **ElastiCache Replication Group** configured with:
    
    *   The specified node type (e.g., cache.t3.medium)
        
    *   Sharding (cluster mode) or a single primary-replica setup
        
    *   Automatic failover (if enabled)
        
    *   Encryption at rest and/or in transit (if enabled)
        

---

## Usage

1. **Add this module** to your Terraform configuration (update the `source` path accordingly):

   ```hcl
   module "redis_cluster" {
     source  = "github.com/roberto-627/aws-elasticache-excercise.git?ref=main"

     replication_group_id          = "my-redis-rg"
     replication_group_description = "Redis replication group"
     engine_version                = "6.2"
     node_type                     = "cache.t3.medium"
     cluster_mode_enabled          = true
     num_node_groups               = 2
     replicas_per_node_group       = 1
     automatic_failover_enabled    = true
     maintenance_window            = "mon:05:00-mon:06:00"

     vpc_id   = "vpc-1234567890"
     subnet_ids = [
       "subnet-11111111",
       "subnet-22222222",
       "subnet-33333333"
     ]

     ingress_cidr_blocks = [
       "10.0.0.0/16",
     ]

     parameter_overrides = [
       { name = "maxmemory-policy", value = "volatile-lru" },
       { name = "timeout",         value = "300" }
     ]

     tags = {
       Environment = "Production"
       Project     = "AwesomeApp"
     }
   }

2. Make sure you specify the aws profile in the provider.tf file.

3. Initialize and apply with Terraform:

    ```bash
    terraform init
    terraform plan
    terraform apply

4. Verify that the ElastiCache cluster is up and running in your AWS Console.

---

## Examples
- See the examples/ folder for a minimal Redis cluster example.
- In examples/redis/main.tf, you can explore how to configure cluster mode, automatic failover, and more.

---

## Inputs

| Variable                        | Type                                              | Default                                    | Description                                                                                                        |
|--------------------------------|---------------------------------------------------|--------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| `region`          | `string`                                          | `"us-east-1"`                           | Provider region to deploy resources
| `replication_group_id`          | `string`                                          | `"my-redis-rg"`                           | Identifier for the replication group                                                                               |
| `replication_group_description` | `string`                                          | `"Redis replication"`                      | Description for the replication group                                                                              |
| `engine`                        | `string`                                          | `"redis"`                                  | The Redis engine                                                                                                   |
| `engine_version`                | `string`                                          | `"6.x"`                                    | Redis engine version                                                                                               |
| `node_type`                     | `string`                                          | `"cache.t3.small"`                        | Instance class for the Redis nodes                                                                                 |
| `port`                          | `number`                                          | `6379`                                     | Redis listening port                                                                                               |
| `cluster_mode_enabled`          | `bool`                                            | `false`                                    | Enable cluster (sharding) mode                                                                                     |
| `num_node_groups`               | `number`                                          | `1`                                        | Number of shards (only relevant if `cluster_mode_enabled = true`)                                                 |
| `replicas_per_node_group`       | `number`                                          | `1`                                        | Number of replicas per shard                                                                                       |
| `num_cache_clusters`            | `number`                                          | `1`                                        | Number of cache clusters (only relevant if `cluster_mode_enabled = false`)                                         |
| `automatic_failover_enabled`    | `bool`                                            | `true`                                     | Enable automatic failover                                                                                          |
| `maintenance_window`            | `string`                                          | `"sun:05:00-sun:06:00"`                    | Preferred maintenance window                                                                                       |
| `primary_availability_zone`     | `string`                                          | `null`                                     | Preferred AZ for the primary node (cluster mode)                                                                   |
| `replica_availability_zones`    | `list(string)`                                    | `[]`                                       | Availability Zones for replicas (cluster mode)                                                                     |
| `at_rest_encryption_enabled`    | `bool`                                            | `false`                                    | Enable at-rest encryption                                                                                          |
| `transit_encryption_enabled`    | `bool`                                            | `false`                                    | Enable in-transit encryption                                                                                       |
| `vpc_id`                        | `string`                                          | **No default**                             | The ID of the VPC in which to deploy                                                                               |
| `subnet_ids`                    | `list(string)`                                    | **No default**                             | Subnets for the ElastiCache subnet group                                                                           |
| `security_group_name`           | `string`                                          | `"redis-security-group"`                   | Name of the security group                                                                                         |
| `security_group_description`    | `string`                                          | `"Security group for Redis ElastiCache"`   | Description for the security group                                                                                 |
| `ingress_cidr_blocks`           | `list(string)`                                    | `["0.0.0.0/0"]`                            | CIDR blocks that can access the Redis port                                                                         |
| `ingress_security_groups`       | `list(string)`                                    | `[]`                                       | Security group IDs allowed ingress to the Redis port                                                               |
| `subnet_group_name`             | `string`                                          | `"redis-subnet-group"`                     | Name for the ElastiCache subnet group                                                                              |
| `parameter_group_name`          | `string`                                          | `"redis-parameter-group"`                  | Name of the ElastiCache parameter group                                                                            |
| `parameter_group_family`        | `string`                                          | `"redis6.x"`                               | Family of the ElastiCache parameter group (e.g. `redis6.x`)                                                        |
| `parameter_group_description`   | `string`                                          | `"Custom parameter group for Redis"`       | Description for the parameter group                                                                                |
| `parameter_overrides`           | `list(object({ name = string, value = string }))` | `[]`                                       | List of Redis parameters to override (e.g. `timeout`, `maxmemory-policy`)                                          |
| `tags`                          | `map(string)`                                     | `{}`                                       | Tags to assign to resources                                                                                        |

---

## Outputs

| Output                     | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
| `security_group_id`        | The ID of the ElastiCache security group                            |
| `replication_group_id`     | The ID of the replication group                                     |
| `primary_endpoint_address` | The primary endpoint address for the Redis cluster                 |
| `reader_endpoint_address`  | The reader endpoint address for read replicas (if applicable)       |


## Requirements
- Terraform 1.0+
- An AWS account and proper credentials configured (via environment variables, AWS profile, etc.)
- Permissions to create AWS ElastiCache, Security Groups, Subnet Groups, and Parameter Groups

## Authors
Roberto Melara

## License
This project is licensed under the MIT License. Feel free to use it as you see fit.

If you have any issues or feature requests, please open an issue or pull request.