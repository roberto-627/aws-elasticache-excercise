variable "region" {
  type        = string
  description = "Provider region to deploy resources"
  default     = "us-east-1"
}

variable "replication_group_id" {
  type        = string
  description = "Identifier for the replication group"
  default     = "my-redis-rg"
}

variable "replication_group_description" {
  type        = string
  description = "Description for the replication group"
  default     = "Redis replication group"
}

variable "engine" {
  type        = string
  description = "The Redis engine"
  default     = "redis"
}

variable "engine_version" {
  type        = string
  description = "Redis engine version"
  default     = "6.x"
}

variable "node_type" {
  type        = string
  description = "Instance class for the Redis nodes"
  default     = "cache.t3.small"
}

variable "port" {
  type        = number
  description = "Redis listening port"
  default     = 6379
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Enable cluster (sharding) mode"
  default     = false
}

variable "num_node_groups" {
  type        = number
  description = "Number of shards (only applies when cluster_mode_enabled = true)"
  default     = 1
}

variable "replicas_per_node_group" {
  type        = number
  description = "Number of replicas per shard"
  default     = 1
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of cache clusters (only applies when cluster_mode_enabled = false)"
  default     = 1
}

variable "automatic_failover_enabled" {
  type        = bool
  description = "Enable automatic failover"
  default     = true
}

variable "maintenance_window" {
  type        = string
  description = "Preferred maintenance window"
  default     = "sun:05:00-sun:06:00"
}

variable "primary_availability_zone" {
  type        = string
  description = "Preferred availability zone for the primary node (cluster mode)"
  default     = null
}

variable "replica_availability_zones" {
  type        = list(string)
  description = "Availability zones for replicas (cluster mode)"
  default     = []
}

variable "at_rest_encryption_enabled" {
  type        = bool
  description = "Enable at-rest encryption"
  default     = false
}

variable "transit_encryption_enabled" {
  type        = bool
  description = "Enable in-transit encryption"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ElastiCache cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for the ElastiCache subnet group"
}

variable "security_group_name" {
  type        = string
  description = "Name for the security group"
  default     = "redis-security-group"
}

variable "security_group_description" {
  type        = string
  description = "Description for the security group"
  default     = "Security group for Redis ElastiCache"
}

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks allowed ingress to the Redis port"
  default     = ["0.0.0.0/0"]
}

variable "ingress_security_groups" {
  type        = list(string)
  description = "Security group IDs allowed ingress to the Redis port"
  default     = []
}

variable "subnet_group_name" {
  type        = string
  description = "Name for the ElastiCache subnet group"
  default     = "redis-subnet-group"
}

variable "parameter_group_name" {
  type        = string
  description = "Name of the ElastiCache parameter group"
  default     = "redis-parameter-group"
}

variable "parameter_group_family" {
  type        = string
  description = "Family of the ElastiCache parameter group (e.g. redis6.x)"
  default     = "redis6.x"
}

variable "parameter_group_description" {
  type        = string
  description = "Description for the parameter group"
  default     = "Custom parameter group for Redis"
}

variable "parameter_overrides" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of Redis parameters to override"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to resources"
  default     = {}
}
