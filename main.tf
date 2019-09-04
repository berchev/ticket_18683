# Depend on that Variable cloudwatch group will be created or NOT
variable "enabled_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit"]
#  default = []
}

# I have created Role arn for EKS Cluster. By default that role need to have AmazonEKSClusterPolicy and AmazonEKSServicePolicy 
# Create this role using this guide: https://docs.aws.amazon.com/eks/latest/userguide/getting-started-console.html   (Amazon EKS Prerequisites -> Create your Amazon EKS Service Role)

# Some numbers will replace XXXXXXXXXXXXX
variable "role_arn" {
  default = "arn:aws:iam::XXXXXXXXXXX:role/eks_role"
}

variable "cluster_name" {
  default = "example"
  type    = "string"
}

provider "aws" {
  region = "us-east-1"
}

# In order to create EKS Cluster you have pre-requirement: (VPC, and two subnets in two different availability zones)
resource "aws_vpc" "first_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "first" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "first"
  }
}

resource "aws_subnet" "second" {
  vpc_id     = "${aws_vpc.first_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "second"
  }
}


resource "aws_eks_cluster" "example" {
  depends_on = ["aws_cloudwatch_log_group.example"]
  role_arn   = var.role_arn
  vpc_config {
    subnet_ids = ["${aws_subnet.first.id}", "${aws_subnet.second.id}"]
  }
  # Log types here are depending on variable enabled_cluster_log_types
  enabled_cluster_log_types = var.enabled_cluster_log_types
  name = "${var.cluster_name}"
}

# IF count is evaluated to TRUE aws_cloudwatch_log_group is created. (We can have only API, only AUDIT, or BOTH)
# The issue comes when you have cloudwatch group ONCE destroyed and then you try to add it again.
# Error will occurs, telling that Cloudwatch group exists !
resource "aws_cloudwatch_log_group" "example" {
  count             = length(var.enabled_cluster_log_types) > 0 ? 1 : 0
  name              = format("/aws/eks/%s/cluster", var.cluster_name)
  retention_in_days = 1 
}
