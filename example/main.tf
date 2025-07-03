data "aws_ssm_parameter" "postgres_user_name" {
  name            = "DUMMY_POSTGRES_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_password" {
  name            = "DUMMY_POSTGRES_PASSWORD"
  with_decryption = true
}

module "sms_extractor" {
  source = "git::https://github.com/credeau/terraform-aws-mobile-forge-sms-extractor.git?ref=v1.0.0"

  application                    = "mobile-forge-extractor"
  environment                    = "prod"
  region                         = "ap-south-1"
  stack_owner                    = "tech@credeau.com"
  stack_team                     = "devops"
  organization                   = "credeau"
  alert_email_recipients         = []
  instance_type                  = "t3a.medium"
  ecr_repository                 = "sms-extractor"
  ecr_image_tag                  = "1.0.0-amd64"
  root_volume_size               = 20
  ami_id                         = "ami-00000000000000000"
  key_name                       = "mobile-forge-demo"
  asg_min_size                   = 1
  asg_max_size                   = 2
  asg_desired_size               = 1
  upscale_evaluation_period      = 60
  downscale_evaluation_period    = 300
  logs_retention_period          = 7
  api_timeout                    = 30
  scaling_cpu_threshold          = 65
  scaling_memory_threshold       = 65
  scaling_disk_threshold         = 70
  mapped_port                    = 8082
  application_port               = 8082
  enable_scheduled_scaling       = false
  timezone                       = "Asia/Kolkata"
  upscale_schedule               = "0 9 * * MON-SUN"
  scheduled_upscale_min_size     = 5
  scheduled_upscale_max_size     = 10
  scheduled_upscale_desired_size = 5
  downscale_schedule             = "0 21 * * MON-SUN"
  enable_alb_access_logs         = false
  max_sms_count                  = 1000
  vpc_id                         = "vpc-00000000000000000"
  private_subnet_ids             = ["subnet-00000000000000000", "subnet-00000000000000000"]
  internal_security_groups       = ["sg-00000000000000000"]
  postgres_user_name             = data.aws_ssm_parameter.postgres_user_name.value
  postgres_password              = data.aws_ssm_parameter.postgres_password.value
  postgres_host                  = aws_db_instance.postgres.db_name
  postgres_port                  = "5432"
  postgres_db                    = "api_insights_db"
  vocab_s3_bucket                = "your_vocab_s3_bucket"
  vocab_file_s3_path             = "regex/vocabulary.enc"
  classification_s3_bucket       = "your_classification_s3_bucket"
  classification_file_s3_path    = "regex/classification.enc"
  regex_s3_bucket                = "your_regex_s3_bucket"
  regex_file_s3_path             = "regex/regex.enc"
}

output "sms_extractor" {
  value = module.sms_extractor
}