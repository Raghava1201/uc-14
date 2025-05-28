resource "aws_sns_topic" "login_topic" {
  name = var.topic_name
}
 
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.login_topic.arn
  protocol  = "email"
  endpoint = var.email
}