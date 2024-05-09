module "roboshop_aws_vpc" {
  #source      = "C:/DevOpswithAWS/repos/terraform_aws_vpc"        #through local module
  source = "git::https://github.com/arunkumar261/terraform_aws_vpc_code.git?ref=main"   #through git hub source code
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_tags     = var.vpc_tags
   vpc_cidr = var.vpc_cidr

  # For public subnet
  public_subnets_cidr = var.public_subnets_cidr
    # For private subnet
  private_subnets_cidr = var.private_subnets_cidr
    # For database subnet
  database_subnets_cidr = var.database_subnets_cidr

  is_peering_required = var.is_peering_required
}


