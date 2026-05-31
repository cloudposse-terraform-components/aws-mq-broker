locals {
  eks_outputs = module.eks.outputs
  vpc_outputs = module.vpc.outputs

  vpc_id             = local.vpc_outputs.vpc_id
  private_subnet_ids = local.vpc_outputs.private_subnet_ids

  # A SINGLE_INSTANCE deployment requires one subnet. An ACTIVE_STANDBY_MULTI_AZ deployment requires two subnets
  subnet_ids = var.deployment_mode == "SINGLE_INSTANCE" ? slice(local.private_subnet_ids, 0, 1) : slice(local.private_subnet_ids, 0, 2)
}

module "mq_broker" {
  source  = "cloudposse/mq-broker/aws"
  version = "3.6.0"

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  deployment_mode            = var.deployment_mode
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type
  publicly_accessible        = var.publicly_accessible
  general_log_enabled        = var.general_log_enabled
  audit_log_enabled          = var.audit_log_enabled
  configuration_data         = var.configuration_data

  maintenance_day_of_week = var.maintenance_day_of_week
  maintenance_time_of_day = var.maintenance_time_of_day
  maintenance_time_zone   = var.maintenance_time_zone

  encryption_enabled = var.encryption_enabled
  kms_ssm_key_arn    = var.kms_ssm_key_arn
  kms_mq_key_arn     = var.kms_mq_key_arn
  use_aws_owned_key  = var.use_aws_owned_key

  mq_admin_user           = var.mq_admin_user
  mq_admin_password       = var.mq_admin_password
  mq_application_user     = var.mq_application_user
  mq_application_password = var.mq_application_password

  ssm_parameters_enabled                     = var.ssm_parameters_enabled
  ssm_parameter_name_format                  = var.ssm_parameter_name_format
  ssm_path                                   = var.ssm_path
  mq_admin_user_ssm_parameter_name           = var.mq_admin_user_ssm_parameter_name
  mq_admin_password_ssm_parameter_name       = var.mq_admin_password_ssm_parameter_name
  mq_application_user_ssm_parameter_name     = var.mq_application_user_ssm_parameter_name
  mq_application_password_ssm_parameter_name = var.mq_application_password_ssm_parameter_name

  # Security group configuration
  create_security_group                = var.create_security_group
  security_group_name                  = var.security_group_name
  security_group_description           = var.security_group_description
  security_group_create_before_destroy = var.security_group_create_before_destroy
  preserve_security_group_id           = var.preserve_security_group_id
  security_group_create_timeout        = var.security_group_create_timeout
  security_group_delete_timeout        = var.security_group_delete_timeout
  allow_all_egress                     = var.allow_all_egress
  allowed_ingress_ports                = var.allowed_ingress_ports
  allowed_security_group_ids           = var.allowed_security_group_ids
  associated_security_group_ids        = var.associated_security_group_ids
  allowed_cidr_blocks                  = var.allowed_cidr_blocks
  allowed_ipv6_cidr_blocks             = var.allowed_ipv6_cidr_blocks
  allowed_ipv6_prefix_list_ids         = var.allowed_ipv6_prefix_list_ids
  additional_security_group_rules      = var.additional_security_group_rules

  # Deprecated security group inputs (retained for backward compatibility)
  allowed_security_groups      = var.allowed_security_groups
  existing_security_groups     = var.existing_security_groups
  use_existing_security_groups = var.use_existing_security_groups

  context = module.this.context
}
