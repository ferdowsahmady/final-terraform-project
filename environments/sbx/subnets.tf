module "subnets" {
  source         = "../../modules/vpc"
  environment    = var.environment
  vpc_id         = module.subnets.vpc_id
  vpc_cidr_block = "192.168.0.0/16"
  subnet_1_cidr  = "192.168.10.0/24"
  subnet_2_cidr  = "192.168.20.0/24"

}