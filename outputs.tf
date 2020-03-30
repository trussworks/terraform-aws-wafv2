output "web_acl_id" {
  value = aws_cloudformation_stack.webacl.outputs.WebACLARN
}
