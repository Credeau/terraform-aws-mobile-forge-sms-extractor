# Load Balancer DNS Name
output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

# Auto Scaling Group Name
output "asg_name" {
  value = aws_autoscaling_group.main.name
}

# ALB Access Log Bucket
output "alb_access_log_bucket" {
  value = var.enable_alb_access_logs ? aws_s3_bucket.access_logs[0].bucket : null
}

# Vocabulary Config File URI
output "vocab_config_file_uri" {
  value = "s3://${var.vocab_s3_bucket}/${var.vocab_file_s3_path}"
}

# Classification Config File URI
output "classification_config_file_uri" {
  value = "s3://${var.classification_s3_bucket}/${var.classification_file_s3_path}"
}

# Regex Config File URI
output "regex_config_file_uri" {
  value = "s3://${var.regex_s3_bucket}/${var.regex_file_s3_path}"
}