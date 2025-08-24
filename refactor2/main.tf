module "network" {
  source              = "./modules/network"
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  create_nat_gateways = var.create_nat_gateways
}

module "security" {
  source               = "./modules/security"
  vpc_id               = module.network.vpc_id
  public_subnet_cidrs  = module.network.public_subnet_cidrs
  private_subnet_cidrs = module.network.private_subnet_cidrs
}

module "compute" {
  source                = "./modules/compute"
  bastion_ami           = var.bastion_ami
  db_ami                = var.db_ami
  instance_type_bastion = var.instance_type_bastion
  instance_type_db      = var.instance_type_db
  public_subnet_id      = module.network.public_subnet_ids[0]
  db_subnet_id          = module.network.private_subnet_ids[1]
  db_private_ip         = var.db_private_ip
  key_name              = var.key_name
  sg_bastion_id         = module.security.sg_bastion_id
  sg_db_id              = module.security.sg_db_id
}

module "alb" {
  source            = "./modules/alb"
  public_subnet_ids = module.network.public_subnet_ids
  sg_lb_id          = module.security.sg_lb_id
  vpc_id            = module.network.vpc_id
  health_check_path = var.alb_health_check_path
}

module "autoscaling" {
  source              = "./modules/autoscaling"
  private_subnet_ids  = slice(module.network.private_subnet_ids, 0, 2)
  launch_template_ami = var.web_ami
  instance_type       = var.web_instance_type
  sg_web_id           = module.security.sg_web_id
  key_name            = var.key_name
  target_group_arn    = module.alb.target_group_arn
  desired_capacity    = var.web_desired
  min_size            = var.web_min
  max_size            = var.web_max
}
