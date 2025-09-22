module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "vpc"
  context   = module.this.context
}

module "eks" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.8.0"

  component = "eks"
  context   = module.this.context
}
