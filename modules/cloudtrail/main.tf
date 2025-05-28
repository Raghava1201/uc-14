resource "aws_cloudtrail" "trail" {
  name                          = var.trail_name
  s3_bucket_name                = var.s3_bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.logs.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_role.arn
  }
 
resource "aws_cloudwatch_log_group" "logs" {
  name              = var.log_group_name
  retention_in_days = 14
}
 
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-to-cloudwatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "CloudTrailToCloudWatchPolicy"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "${aws_cloudwatch_log_group.logs.arn}:*"
      }
    ]
  })
}
