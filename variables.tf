variable "region" {
  description = "aws region"
  type        = string
}
variable "access_key" {
  description = "access key"
  type        = string
}
variable "secret_key" {
  description = "secret key"
  type        = string
}
variable "availability_zone" {
  description = "aws availability zone"
  type        = string
}
variable "ec2_ami" {
  description = "EC2 ami image"
  type        = string
}
variable "ec2_key_name" {
  description = "ssh key filename"
  type        = string
}
