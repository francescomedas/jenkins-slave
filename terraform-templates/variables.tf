variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "jenkins_url" {
  type = string
}

variable "jenkins_username" {
  type = string
}

variable "jenkins_password" {
  type = string
}

variable "jenkins_credentials_id" {
  type = string
}

variable "slaves_max_size" {
  type = number
}

variable "slaves_min_size" {
  type = number
}

variable "slaves_desired_capacity" {
  type = number
}