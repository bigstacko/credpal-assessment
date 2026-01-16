provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source            = "./modules/alb"
  app_name          = var.app_name
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  container_port    = var.container_port
}

module "redis" {
  source          = "./modules/redis"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  ecs_sg_id       = module.ecs.ecs_sg_id
}

module "ecs" {
  source            = "./modules/ecs"
  app_name          = var.app_name
  container_image  = var.container_image
  container_port   = var.container_port
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  alb_sg_id         = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn
  redis_endpoint   = module.redis.redis_endpoint
}
