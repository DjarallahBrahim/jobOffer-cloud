module "vpc" {
  source = "./vpc.tf"
}

module "firewall" {
  source = "./firewall.tf"
}