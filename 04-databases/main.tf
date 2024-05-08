#for mongodb 
module "mongodb" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami  = data.aws_ami.centos8.id
  name = "${local.ec2_name}-mongodb"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]
  subnet_id = local.database_subnet_id


  tags = merge(
    var.common_tags,
    {
      Component = "mongodb"
    },
    {
      Name = "${local.ec2_name}-mongodb"
    }
  )
}


# 1st way is through user_data variable (used in terraform-roboshop folder 04-ec2) here u dont get logs on terminal u need to log on to ec2 and need to check whether success or failed
#2nd way to get the logs on terminal u will get all the runned ansible tasks for mongodb will b2 displayed on terminal
#belo is 2nd way


resource "null_resource" "mongodb" {
  triggers = {
    instance_id = module.mongodb.id
  }

  connection {
    host = module.mongodb.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}"  #we r passing component and env values here

     ]
  }
}


#for redis

module "redis" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami  = data.aws_ami.centos8.id
  name = "${local.ec2_name}-redis"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.redis_sg_id.value]
  subnet_id = local.database_subnet_id


  tags = merge(
    var.common_tags,
    {
      Component = "redis"
    },
    {
      Name = "${local.ec2_name}-redis"
    }
  )
}


resource "null_resource" "redis" {
  triggers = {
    instance_id = module.redis.id
  }

  connection {
    host = module.redis.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh redis ${var.environment}"  #we r passing component and env values here

     ]
  }
}

#for mysql


module "mysql" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami  = data.aws_ami.centos8.id
  name = "${local.ec2_name}-mysql"
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  subnet_id = local.database_subnet_id
  iam_instance_profile = "ShellScriptRoleForRoboshop"

  tags = merge(
    var.common_tags,
    {
      Component = "mysql"
    },
    {
      Name = "${local.ec2_name}-mysql"
    }
  )
}


resource "null_resource" "mysql" {
  triggers = {
    instance_id = module.mysql.id
  }

  connection {
    host = module.mysql.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"  #we r passing component and env values here

     ]
  }
}


#for rabbitmq
module "rabbitmq" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami  = data.aws_ami.centos8.id
  name = "${local.ec2_name}-rabbitmq"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.rabbitmq_sg_id.value]
  subnet_id = local.database_subnet_id
  iam_instance_profile = "ShellScriptRoleForRoboshop"

  tags = merge(
    var.common_tags,
    {
      Component = "rabbitmq"
    },
    {
      Name = "${local.ec2_name}-rabbitmq"
    }
  )
}


resource "null_resource" "rabbitmq" {
  triggers = {
    instance_id = module.rabbitmq.id
  }

  connection {
    host = module.rabbitmq.private_ip
    type = "ssh"
    user = "centos"
    password = "DevOps321"
  }

  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
        "chmod +x /tmp/bootstrap.sh",
        "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"  #we r passing component and env values here

     ]
  }
}



module "records" {
  source    = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name

  records = [
    {
      name = "mongodb-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.mongodb.private_ip}",
      ]
    },
    {
      name = "redis-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.redis.private_ip}",
      ]
    },
    {
      name = "mysql-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.mysql.private_ip}",
      ]
    },
    {
      name = "rabbitmq-${var.environment}"
      type = "A"
      ttl  = 1
      records = [
        "${module.rabbitmq.private_ip}",
      ]
    },
  ]
}
