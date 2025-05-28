resource "aws_cloudwatch_log_metric_filter" "login_filter" {
  name           = "console-login-filter"
  log_group_name = var.log_group_name
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.responseElements.ConsoleLogin = \"Success\") }"
 
  metric_transformation {
    name      = "ConsoleLoginSuccess"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}
 
resource "aws_cloudwatch_metric_alarm" "login_alarm" {
  alarm_name          = "ConsoleLoginAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsoleLoginSuccess"
  namespace           = "CloudTrailMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_topic_arn]
}