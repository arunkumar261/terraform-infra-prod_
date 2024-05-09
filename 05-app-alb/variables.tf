variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "prod"
}

variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "prod"
    Terraform = "true"
  }
}

variable "zone_name" {
  default = "arundev.online"
}


variable "tags" {
    default = {
        Component = "app-alb"
    }
  
}