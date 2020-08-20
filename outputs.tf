output "web_acl_id" {
  description = "The ARN of the WAF WebACL."
  value       = aws_wafv2_web_acl.main.arn
}
