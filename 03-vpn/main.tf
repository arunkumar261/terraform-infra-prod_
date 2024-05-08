# module "vpn" {
#    source = "terraform-aws-modules/ec2-instance/aws"
# #     source =  "C:/DevOpswithAWS/repos/terraform-ec2_instance"
#   ami =data.aws_ami.centos8.id
#   name= "${local.ec2_name}-vpn"
#   instance_type = var.instance_type

#   vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]

# #we need to give databasesubnet id because it is mongodb
#   subnet_id = data.aws_subnet.selected.id

#   user_data = file("openvpn.sh")


#   tags  = merge(
#     var.common_tags,
#     {
#         Component = "vpn"
#     },
#     {
#         Name = "${local.ec2_name}-vpn"
#     }
#   )
# }

module "vpn" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.centos8.id
  name                   = "${local.ec2_name}-vpn"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  subnet_id              = data.aws_subnet.selected.id
  user_data = file("openvpn.sh")
  tags = merge(
    var.common_tags,
    {
      Component = "vpn"
    },
    {
      Name = "${local.ec2_name}-vpn"
    }
  )
}





