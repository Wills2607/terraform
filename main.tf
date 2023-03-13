provider "aws" {
  region = local.region
}

locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"
  region = "us-west-2"

  tags = {
    Name        = local.name
    Environment = "Testing"
  }
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

private_subnet_tags_per_az = {
 "${local.region}a" = {
  Name = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}a-private"
 }

"${local.region}b" = {
  Name = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}b-private"
  }

"${local.region}c" = {
  "Name" = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}c-private"
  }
}
  public_subnet_tags_per_az = {
    "${local.region}a" = {
      "availability-zone" = "${local.region}a"
      "Name" = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}a-public"
    }
        "${local.region}b" = {
      "availability-zone" = "${local.region}b"
      "Name" = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}b-public"
    }
    "${local.region}c" = {
      "availability-zone" = "${local.region}c"
      "Name" = "ex-${replace(basename(path.cwd), "_", "-")}-${local.region}c-public"
    }
  }

  tags = local.tags

  vpc_tags = {
    Name = "ex-${replace(basename(path.cwd), "_", "-")}-vpc"
  }
}
