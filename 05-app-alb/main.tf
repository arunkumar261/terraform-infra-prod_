resource "aws_lb" "app_alb" {
  name               = "${local.name}-${var.tags.Component}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split("," , data.aws_ssm_parameter.private_subnet_ids.value)


#   enable_deletion_protection = true

  tags = merge(
    var.common_tags,
    var.tags
  )
}

#above we have 1a and 1b subnets we r spliting or list them through split function
#for LB there is a condition that 2 subnets is min and must req 


#for aws lb lister to lister at port 80

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi this response from APP ALB"
      status_code  = "200"
    }
  }
}


module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = var.zone_name

 records = [
    {
        name = "*.app-${var.environment}"
        type = "A"
        
        alias   = {
        name = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
 ]
}

#in * place we can change multiple data like "cart.app-${var.environment}" "redis.app-${var.environment}" like this





