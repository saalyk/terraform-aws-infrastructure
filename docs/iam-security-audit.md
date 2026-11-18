# AWS IAM Security Audit & Least Privilege Analysis

## Audit Overview

- **Service:** AWS Identity and Access Management (IAM)
- **Region:** Asia Pacific (Sydney) - `ap-southeast-2`
- **Audit Date:** November 18, 2026
- **Audit Method:** AWS CLI read-only inspection
- **Scope:** IAM users, roles, trust policies, managed policies, account security settings and credential report

## Objective

This audit evaluates selected IAM security configurations in an AWS training environment.

The objective is to identify excessive permissions, review role trust relationships, inspect credential security indicators and document least-privilege recommendations.

No IAM users, roles, policies, or other AWS resources were created, modified, or deleted during this audit. Credential report generation was requested for inspection.

## Audit Findings

### 1. IAM Users

**Status: No IAM users found**

- Total IAM users: 0
- IAM groups: 0

No IAM users were returned by the AWS CLI.

The environment appears to rely on role-based access rather than IAM user accounts.

### 2. IAM Roles Inventory

**Status: 12 roles identified**

The account contained 12 IAM roles, including:

- AccountFullAccessRole
- AWSManagedAccountManagementAccessRole
- AWSManagedAdvancedFeaturesActivationRole
- AWSServiceRoleForIAMRoleManager
- CloudWatchAgentEC2Role
- Other AWS service-linked roles

Eight roles were identified under the `/aws-service-role/` path.

Service-linked roles support integrations with their respective AWS services.

### 3. Administrator Access

**Status: Broad administrator permissions identified**

The `AccountFullAccessRole` has the AWS-managed `AdministratorAccess` policy attached.

The inspected policy document contains:

- Effect: `Allow`
- Action: `*`
- Resource: `*`

This grants unrestricted action and resource scope within the policy, subject to other applicable AWS controls.

**Security risk:** Broad administrator access increases the potential impact of compromised credentials or unintended operations.

**Recommendation:**

- Use narrowly scoped permissions for routine workloads.
- Separate administrative access from operational roles.
- Apply least-privilege policies wherever practical.
- Retain broad access only where explicitly required and controlled.

### 4. Role Trust Relationships

**Status: Selected trust relationships inspected**

The following roles were inspected:

- `AccountFullAccessRole`
- `CloudWatchAgentEC2Role`
- `AWSManagedAccountManagementAccessRole`
- `AWSManagedAdvancedFeaturesActivationRole`
- `AWSServiceRoleForIAMRoleManager`

Findings:

- AccountFullAccessRole trusts the `account-access.amazonaws.com` service principal.
- CloudWatchAgentEC2Role trusts `ec2.amazonaws.com`.
- AWS-managed account roles use specific service or account principals with conditions where applicable.
- AWSServiceRoleForIAMRoleManager trusts `role-manager.iam.amazonaws.com`.

No wildcard principal was found in these inspected trust policies.

This is a review of selected roles, not every trust relationship in the account.

### 5. Inline Policies

**Status: No inline policies found**

All 12 IAM roles were checked.

| Check | Result |
|---|---:|
| Total roles | 12 |
| Roles with inline policies | 0 |
| Roles without inline policies | 12 |

Role permissions are assigned through attached managed policies rather than inline policies.

### 6. IAM Password Policy

**Status: No custom account password policy configured**

The AWS CLI returned `NoSuchEntity` when retrieving the account password policy.

No IAM users were present during the audit.

A custom password policy should be configured if IAM users are introduced in the future.

### 7. Root Account MFA and Credentials

**Status: MFA not enabled according to inspected indicators**

The IAM account summary returned:

- AccountMFAEnabled: 0
- AccountAccessKeysPresent: 0
- AccountPasswordPresent: 0
- MFADevices: 0
- IAM users: 0

The credential report also indicated:

- Root password enabled: false
- Root MFA active: false
- Root access key 1 active: false
- Root access key 2 active: false

**Security risk:** The inspected indicators show that root MFA is not enabled.

**Recommendation:**

- Enable MFA on the AWS root account.
- Avoid using root credentials for routine operations.
- Do not create root access keys.
- Protect root account recovery and authentication methods.

### 8. AccountFullAccessRole Usage

**Status: Recently used**

- Last-used date: November 18, 2026
- Last-used region: `us-east-1`

The role has broad `AdministratorAccess` permissions.

Its recent use makes administrative access controls and session monitoring particularly important.

### 9. CloudWatchAgentEC2Role

**Status: Monitoring and management policies attached**

Attached policies:

- `CloudWatchAgentServerPolicy`
- `AmazonSSMManagedInstanceCore`

Additional observations:

- No inline policies.
- Trust principal: `ec2.amazonaws.com`.
- Last used: November 2, 2026.
- Last-used region: `ap-southeast-2`.

The inspected permissions support CloudWatch monitoring, log publishing, tracing and Systems Manager instance management.

### 10. CloudWatchAgentServerPolicy

**Status: Selected service permissions**

The inspected default policy version was `v4`.

Permissions include selected actions for:

- CloudWatch metric publishing
- CloudWatch Logs management and publishing
- EC2 volume and tag descriptions
- AWS X-Ray trace and telemetry publishing
- Reading selected CloudWatch-related Systems Manager parameters

The first permission statement uses `Resource: "*"`.

**Recommendation:** Evaluate resource-level restrictions for production workloads where supported.

### 11. AmazonSSMManagedInstanceCore

**Status: Systems Manager permissions inspected**

The inspected default policy version was `v2`.

Permission groups include:

- Systems Manager instance management
- Systems Manager messaging channels
- EC2 messaging operations

The policy uses selected actions rather than an unrestricted `Action: "*"` permission.

All three inspected statements use `Resource: "*"`.

**Recommendation:** Review whether narrower resource restrictions are practical for the intended environment.

### 12. AWSManagedAccountManagementAccessRole

**Status: Scoped IAM management permissions**

The attached AWS-managed policy allows selected IAM role management operations, including:

- Creating and deleting roles
- Attaching and detaching policies
- Updating role trust policies
- Managing role permissions boundaries
- Reading role configuration

The resource scope is restricted to the `managed/` IAM role path.

Its AssumeRole permission also includes an organization-related condition.

**Assessment:** Powerful IAM management operations are restricted by resource path and applicable conditions.

### 13. AWSManagedAdvancedFeaturesActivationRole

**Status: Single account-level IAM action**

The inspected policy allows:

- `iam:PutAccountProperties`

The statement uses `Resource: "*"`.

Although the resource scope is broad, the policy contains only this specific action.

### 14. AWSServiceRoleForIAMRoleManager

**Status: Service-linked policy inspected**

The attached AWS-managed policy allows:

- `access-analyzer:CreateServiceLinkedAnalyzer`
- `access-analyzer:DeleteServiceLinkedAnalyzer`
- `iam:CreateServiceLinkedRole`

The role creation permission includes a condition restricting the AWS service name to `access-analyzer.amazonaws.com`.

These permissions are consistent with the role's IAM Role Manager and Access Analyzer integration purpose.

### 15. Other AWS Service-Linked Roles

**Status: Eight service-linked roles identified**

The inventory included roles associated with:

- AWS User Notifications
- AWS Budgets Spend Limit
- Notifications Contact Associations
- AWS Organizations
- AWS Resource Explorer
- AWS Support
- AWS Trusted Advisor
- AWS IAM Role Manager

These roles were identified by their AWS service-linked role paths.

Not every attached policy or trust relationship for these roles was individually inspected.

## Account Summary

Selected account-level results:

| Configuration | Observed result |
|---|---:|
| IAM users | 0 |
| IAM groups | 0 |
| IAM roles | 12 |
| Customer-managed policies | 0 |
| MFA devices | 0 |
| Account access keys | 0 |
| Inline policies across roles | 0 |

AWS-managed policies were present despite the absence of customer-managed policies.

## Security Recommendations

1. Enable MFA for the AWS root account.
2. Avoid using unrestricted administrator permissions for routine workloads.
3. Apply least-privilege policies to operational roles.
4. Review role trust relationships periodically.
5. Restrict resource scope where supported by AWS services.
6. Review unused or unnecessary roles and permissions before making changes.
7. Monitor administrator role usage and privileged sessions.
8. Reassess IAM configuration whenever new users, roles or services are introduced.
9. Configure a custom password policy if IAM users are created in the future.

These are recommendations only. No IAM configuration changes were performed.

## Cost and Safety Considerations

- AWS CLI inspection commands were read-only.
- Credential report generation was requested for inspection.
- No AWS infrastructure resources were created, modified or deleted.
- No IAM policies, roles or permissions were changed.
- IAM inspection was performed using temporary AWS credentials.
- Review AWS pricing before enabling additional security monitoring services.

## Skills Demonstrated

- AWS IAM
- AWS CLI
- IAM policy inspection
- Managed and inline policy analysis
- Role trust relationship analysis
- AWS service-linked roles
- Least-privilege security principles
- Root account security
- MFA and credential report analysis
- Cloud security auditing
- Security documentation
- Safe, read-only cloud operations

## Limitations

This audit represents a point-in-time inspection of selected IAM configurations.

It does not constitute a complete AWS security assessment.

Not every service-linked policy, trust relationship, resource policy, session or effective permission was inspected.

The audit does not independently verify root authentication recovery methods, organizational security controls or all applicable service-level restrictions.

No claim is made that the AWS account is completely secure based only on these findings.
