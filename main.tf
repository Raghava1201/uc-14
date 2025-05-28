module "sns" {
  source     = "./modules/sns"
  topic_name = "console-login-alerts"
  email      = var.email
}

module "cloudtrail" {
  source         = "./modules/cloudtrail"
  trail_name     = "management-events-trail"
  s3_bucket      = "cloudtrail-logs-uc-14"
  log_group_name = "cloudtrail-logs"
}

module "cloudwatch" {
  source         = "./modules/cloudwatch"
  log_group_name = module.cloudtrail.cloudwatch_log_group_name
  sns_topic_arn  = module.sns.sns_topic_arn
}