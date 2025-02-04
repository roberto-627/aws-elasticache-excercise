############################################################
# Security Group for ElastiCache
############################################################
resource "aws_security_group" "this" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # By default, deny all inbound, allow outbound. 
  # Adjust as needed or configure ingress rules.
  ingress {
    description     = "Allow inbound from trusted CIDRs or SGs"
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    cidr_blocks     = var.ingress_cidr_blocks
    security_groups = var.ingress_security_groups
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

############################################################
# ElastiCache Subnet Group
############################################################
resource "aws_elasticache_subnet_group" "this" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

############################################################
# ElastiCache Parameter Group
############################################################
resource "aws_elasticache_parameter_group" "this" {
  name        = var.parameter_group_name
  family      = var.parameter_group_family
  description = var.parameter_group_description

  dynamic "parameter" {
    for_each = var.parameter_overrides
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}

############################################################
# ElastiCache Replication Group (Redis)
#   - Supports sharding (cluster_mode_enabled = true)
#   - Automatic failover for high availability
############################################################
resource "aws_elasticache_replication_group" "this" {
  replication_group_id = var.replication_group_id
  description          = var.replication_group_description

  engine               = var.engine
  engine_version       = var.engine_version
  parameter_group_name = aws_elasticache_parameter_group.this.name

  # Sharding / Cluster Mode
  dynamic "cluster_mode" {
    for_each = var.cluster_mode_enabled ? [1] : []
    content {
      num_node_groups         = var.num_node_groups
      replicas_per_node_group = var.replicas_per_node_group
    }
  }

  num_node_groups         = var.num_node_groups
  replicas_per_node_group = var.replicas_per_node_group

  # Subnet group & Security group
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.this.id]

  # Failover
  automatic_failover_enabled = var.automatic_failover_enabled

  # Node Type
  port      = var.port
  node_type = var.node_type

  # Maintenance
  maintenance_window = var.maintenance_window

  # At-rest Encryption & Transit Encryption
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled

  # Monitoring
  # (ElastiCache automatically publishes metrics to CloudWatch. Optionally, 
  # you can create CloudWatch Alarms to track specific metrics.)

  tags = var.tags
}
