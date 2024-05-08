variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "tags" {
    default = {
        Component = "user"
    }
}

variable "project_name" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "zone_name" {
  default = "arundev.online"
}

variable "iam_instance_profile" {
  default = "ShellScriptRoleForRoboshop"
}

variable "app_version" {
  
}