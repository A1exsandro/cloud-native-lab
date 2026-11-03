output "aws_account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.current.region
}

output "aws_caller_arn" {
  description = "Authenticated AWS identity"
  value       = data.aws_caller_identity.current.arn
}
