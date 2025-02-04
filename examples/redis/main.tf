module "redis_cluster" {
  source = "../../"

  replication_group_id          = "my-redis"
  replication_group_description = "Production Redis cluster"
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
    { name = "timeout",         value = "300"         },
  ]

  tags = {
    Environment = "Development"
    Project     = "Test"
  }
}
