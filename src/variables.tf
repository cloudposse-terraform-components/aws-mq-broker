variable "region" {
  type        = string
  description = "AWS Region"
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = false
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
}

variable "deployment_mode" {
  type        = string
  default     = "ACTIVE_STANDBY_MULTI_AZ"
  description = "The deployment mode of the broker. Supported: SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ"
}

variable "engine_type" {
  type        = string
  default     = "ActiveMQ"
  description = "Type of broker engine, `ActiveMQ` or `RabbitMQ`"
}

variable "engine_version" {
  type        = string
  default     = "5.15.14"
  description = "The version of the broker engine. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
}

variable "host_instance_type" {
  type        = string
  default     = "mq.t3.micro"
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
}

variable "general_log_enabled" {
  type        = bool
  default     = true
  description = "Enables general logging via CloudWatch"
}

variable "audit_log_enabled" {
  type        = bool
  default     = true
  description = "Enables audit logging. User management action made using JMX or the ActiveMQ Web Console is logged"
}

variable "maintenance_day_of_week" {
  type        = string
  default     = "SUNDAY"
  description = "The maintenance day of the week. e.g. MONDAY, TUESDAY, or WEDNESDAY"
}

variable "maintenance_time_of_day" {
  type        = string
  default     = "03:00"
  description = "The maintenance time, in 24-hour format. e.g. 02:00"
}

variable "maintenance_time_zone" {
  type        = string
  default     = "UTC"
  description = "The maintenance time zone, in either the Country/City format, or the UTC offset format. e.g. CET"
}

variable "mq_admin_user" {
  type        = list(string)
  default     = []
  description = "Admin username"
}

variable "mq_admin_password" {
  type        = list(string)
  default     = []
  description = "Admin password"
  sensitive   = true
}

variable "mq_application_user" {
  type        = list(string)
  default     = []
  description = "Application username"
}

variable "mq_application_password" {
  type        = list(string)
  default     = []
  description = "Application password"
  sensitive   = true
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
    DEPRECATED: Use `allowed_security_group_ids` instead.
    List of Security Group IDs to be allowed to connect to the broker instance.
    EOT
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv4 CIDRs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv6 CIDRs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_ipv6_prefix_list_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv6 Prefix Lists IDs to allow access to the security group created by this module.
    The length of this list must be known at "plan" time.
    EOT
}

variable "allowed_ingress_ports" {
  type        = list(number)
  default     = []
  description = <<-EOT
    List of TCP ports to allow access to in the created security group.
    Default is to allow access to all ports. Set `create_security_group` to `false` to disable.
    Note: List of ports must be known at "plan" time.
    EOT
}

variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the created resource with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access.
    EOT
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "Set `true` to create and configure a new security group. If false, `associated_security_group_ids` must be provided."
}

variable "security_group_name" {
  type        = list(string)
  default     = []
  description = <<-EOT
    The name to assign to the created security group. Must be unique within the VPC.
    If not provided, will be derived from the `null-label.context` passed in.
    If `create_before_destroy` is true, will be used as a name prefix.
    EOT
}

variable "security_group_description" {
  type        = string
  default     = "Managed by Terraform"
  description = <<-EOT
    The description to assign to the created Security Group.
    Warning: Changing the description causes the security group to be replaced.
    EOT
}

variable "security_group_create_before_destroy" {
  type        = bool
  default     = true
  description = <<-EOT
    Set `true` to enable Terraform `create_before_destroy` behavior on the created security group.
    We only recommend setting this `false` if you are importing an existing security group
    that you do not want replaced and therefore need full control over its name.
    Note that changing this value will always cause the security group to be replaced.
    NOTE for Amazon MQ (e.g. RabbitMQ): AWS does not support changing the security groups of an
    existing broker, so a create-before-destroy replacement of the security group forces a full
    broker recreation. Set this to `false` for brokers to keep the security group stable.
    EOT
}

variable "preserve_security_group_id" {
  type        = bool
  default     = false
  description = <<-EOT
    When `false` and `security_group_create_before_destroy` is `true`, changes to security group rules
    cause a new security group to be created with the new rules, and the existing security group is then
    replaced with the new one, eliminating any service interruption.
    When `true` or when changing the value (from `false` to `true` or from `true` to `false`),
    existing security group rules will be deleted before new ones are created, resulting in a service interruption,
    but preserving the security group itself.
    **NOTE:** Setting this to `true` does not guarantee the security group will never be replaced,
    it only keeps changes to the security group rules from triggering a replacement.
    See the [terraform-aws-security-group README](https://github.com/cloudposse/terraform-aws-security-group) for further discussion.
    EOT
}

variable "security_group_create_timeout" {
  type        = string
  default     = "10m"
  description = "How long to wait for the security group to be created."
}

variable "security_group_delete_timeout" {
  type        = string
  default     = "15m"
  description = <<-EOT
    How long to retry on `DependencyViolation` errors during security group deletion from
    lingering ENIs left by certain AWS services such as Elastic Load Balancing.
    EOT
}

variable "additional_security_group_rules" {
  type        = list(any)
  default     = []
  description = <<-EOT
    A list of Security Group rule objects to add to the created security group, in addition to the ones
    this module normally creates. (To suppress the module's rules, set `create_security_group` to false
    and supply your own security group(s) via `associated_security_group_ids`.)
    The keys and values of the objects are fully compatible with the `aws_security_group_rule` resource, except
    for `security_group_id` which will be ignored, and the optional "key" which, if provided, must be unique and known at "plan" time.
    For more info see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
    and https://github.com/cloudposse/terraform-aws-security-group.
    EOT
}

variable "allow_all_egress" {
  type        = bool
  default     = true
  description = <<-EOT
    If `true`, the created security group will allow egress on all ports and protocols to all IP addresses.
    If `false`, no egress rules will be created by this module; egress must be configured via other means
    (e.g. additional security group rules) or all outbound traffic will be denied.
    EOT
}

variable "overwrite_ssm_parameter" {
  type        = bool
  default     = true
  description = "DEPRECATED: No longer used. The underlying `cloudposse/mq-broker/aws` module no longer exposes this input; retained only for backward compatibility and has no effect."
}

variable "use_existing_security_groups" {
  type        = bool
  default     = null
  description = <<-EOT
    DEPRECATED: Use `create_security_group` instead.
    Historical description: Set to `true` to disable Security Group creation and provide a list of
    existing Security Group IDs in `existing_security_groups` to place the broker into.
    When non-null, this takes precedence over `create_security_group`.
    EOT
}

variable "existing_security_groups" {
  type        = list(string)
  default     = []
  description = <<-EOT
    DEPRECATED: Use `associated_security_group_ids` instead.
    List of existing Security Group IDs to place the broker into.
    EOT
}

variable "ssm_parameters_enabled" {
  type        = bool
  default     = true
  description = "Whether to create SSM parameters for MQ users and passwords"
}

variable "ssm_parameter_name_format" {
  type        = string
  default     = "/%s/%s"
  description = "SSM parameter name format"
}

variable "ssm_path" {
  type        = string
  default     = "mq"
  description = "SSM path"
}

variable "mq_admin_user_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Admin username"
  default     = "mq_admin_username"
}

variable "mq_admin_password_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Admin password"
  default     = "mq_admin_password"
}

variable "mq_application_user_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Application username"
  default     = "mq_application_username"
}

variable "mq_application_password_ssm_parameter_name" {
  type        = string
  description = "SSM parameter name for Application password"
  default     = "mq_application_password"
}

variable "kms_ssm_key_arn" {
  type        = string
  default     = "alias/aws/ssm"
  description = "ARN of the AWS KMS key used for SSM encryption"
}

variable "encryption_enabled" {
  type        = bool
  default     = true
  description = "Flag to enable/disable Amazon MQ encryption at rest"
}

variable "kms_mq_key_arn" {
  type        = string
  default     = null
  description = "ARN of the AWS KMS key used for Amazon MQ encryption"
}

variable "use_aws_owned_key" {
  type        = bool
  default     = true
  description = "Boolean to enable an AWS owned Key Management Service (KMS) Customer Master Key (CMK) for Amazon MQ encryption that is not in your account"
}

variable "configuration_data" {
  type        = string
  default     = null
  description = "Data value for broker configuration (e.g. broker configuration XML)"
}

