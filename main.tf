locals {
  excluded_rules_common_rule_set    = jsonencode(var.excluded_rules_common_rule_set)
  excluded_rules_ip_reputation_list = jsonencode(var.excluded_rules_ip_reputation_list)
  excluded_rules_known_bad_inputs   = jsonencode(var.excluded_rules_known_bad_inputs)
  excluded_rules_sqli               = jsonencode(var.excluded_rules_sqli)
  excluded_rules_linux_os           = jsonencode(var.excluded_rules_linux_os)
  excluded_rules_posix              = jsonencode(var.excluded_rules_posix)
  excluded_rules_anonymous_ip_list  = jsonencode(var.excluded_rules_anonymous_ip_list)
}

# Using a CloudFormation stack until AWS Terraform provider supports WAFv2
# https://github.com/terraform-providers/terraform-provider-aws/issues/11046
resource "aws_cloudformation_stack" "webacl" {
  name          = "${var.name}-webacl"
  template_body = <<STACK
Description: ${var.name} webacl
Resources:
  WebACL:
    Type: AWS::WAFv2::WebACL
    Properties:
      Name: ${var.name}webacl
      Scope: ${var.scope}
      Description: ${var.name} webacl
      DefaultAction:
        Allow: {}
      VisibilityConfig:
        SampledRequestsEnabled: true
        CloudWatchMetricsEnabled: true
        MetricName: ${var.name}webacl
      Rules:
        %{~if var.enable_common_rule_set~}
        - Name: CommonRuleSet
          Priority: 0
          OverrideAction:
            %{if var.count_common_rule_set}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: CommonRuleSet
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesCommonRuleSet
              ExcludedRules: ${local.excluded_rules_common_rule_set}
        %{~endif~}
        %{~if var.enable_ip_reputation_list~}
        - Name: IpReputationList
          Priority: 1
          OverrideAction:
            %{if var.count_ip_reputation_list}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: IpReputationList
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesAmazonIpReputationList
              ExcludedRules: ${local.excluded_rules_ip_reputation_list}
        %{~endif~}
        %{~if var.enable_known_bad_inputs~}
        - Name: KnownBadInputsRuleSet
          Priority: 2
          OverrideAction:
            %{if var.count_known_bad_inputs}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: KnownBadInputsRuleSet
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesKnownBadInputsRuleSet
              ExcludedRules: ${local.excluded_rules_known_bad_inputs}
        %{~endif~}
        %{~if var.enable_sqli~}
        - Name: SQLiRuleSet
          Priority: 3
          OverrideAction:
            %{if var.count_sqli}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: SQLiRuleSet
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesSQLiRuleSet
              ExcludedRules: ${local.excluded_rules_sqli}
        %{~endif~}
        %{~if var.enable_linux_os~}
        - Name: LinuxOS
          Priority: 4
          OverrideAction:
            %{if var.count_linux_os}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: LinuxOS
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesLinuxRuleSet
              ExcludedRules: ${local.excluded_rules_linux_os}
        %{~endif~}
        %{~if var.enable_posix~}
        - Name: POSIX
          Priority: 5
          OverrideAction:
            %{if var.count_posix}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: POSIX
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesUnixRuleSet
              ExcludedRules: ${local.excluded_rules_posix}
        %{~endif~}
        %{~if var.enable_anonymous_ip_list~}
        - Name: AnonymousIpList
          Priority: 6
          OverrideAction:
            %{if var.count_anonymous_ip_list}Count%{else}None%{endif}: {}
          VisibilityConfig:
            SampledRequestsEnabled: true
            CloudWatchMetricsEnabled: true
            MetricName: AnonymousIpList
          Statement:
            ManagedRuleGroupStatement:
              VendorName: AWS
              Name: AWSManagedRulesAnonymousIpList
              ExcludedRules: ${local.excluded_rules_anonymous_ip_list}
        %{~endif~}
Outputs:
  WebACLARN:
    Description: ARN of the ${var.name} webacl
    Value: !GetAtt WebACL.Arn
STACK
}
