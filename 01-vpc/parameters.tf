resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.roboshop_aws_vpc.vpc_id
}


resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_aws_vpc.public_subnet_ids)
}

#join function : i will seperate values with seperator ","(comma) 
#it will do in aws and stores it in ssm parameter
#lets say    join(seperator , list)     ex : ("aeu" , "Arun") 

#to see wt im getting on terminal ,, it will give list because there is 2 subnets with public 1a and 1b
# output "public_subnet_ids" {
#   value = module.roboshop_aws_vpc.public_subnet_ids
# }


resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_aws_vpc.private_subnet_ids)
}


resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join("," , module.roboshop_aws_vpc.database_subnet_ids)
}