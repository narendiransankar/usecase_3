
module "network" {
  source          = "./modules/network"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  region          = var.region
}

module "security" {
  source     = "./modules/security"
  env        = var.env
  vpc_id     = module.network.vpc_id
  trusted_ips = var.trusted_ips
}

module "compute" {
  source           = "./modules/compute"
  env              = var.env
  public_subnet_ids = module.network.public_subnet_ids
  web_sg_id        = module.security.web_sg_id
  key_name         = var.key_name
  instance_type    = var.instance_type
}
