output "security_group_id" {
  description = "The ID of the ElastiCache security group"
  value       = aws_security_group.this.id
}

output "replication_group_id" {
  description = "The ID of the replication group"
  value       = aws_elasticache_replication_group.this.id
}

output "primary_endpoint_address" {
  description = "The address of the primary endpoint"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "The address of the reader endpoint (for read replicas)"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}
