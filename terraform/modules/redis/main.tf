resource "aws_security_group" "redis" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "redis-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_elasticache_cluster" "this" {
  cluster_id         = "redis"
  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [aws_security_group.redis.id]
}
