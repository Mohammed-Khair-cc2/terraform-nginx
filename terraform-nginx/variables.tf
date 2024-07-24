# vpc cider range
variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# give project a name
variable "nginx-project" {
  type    = string
  default = "terraform-nginx"

}

# launch ec2 Amazon linux 2023 AMI
variable "ami" {
  type    = string
  default = "ami-0b995c42184e99f98"

}
