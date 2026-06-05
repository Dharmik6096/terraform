variable "ec2_instance_type" {
  default = "t3.micro"
  type    = string
}

variable "ec2_ami_id" {
  default = "ami-0fe18bc3cfa53a248"
  type    = string
}

variable "ec2_root_storage_size" {
  default = 15
  type    = number
}

variable "env" {
  default = "prd"
  type    = string
}