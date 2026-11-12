# Terraform AWS Infrastructure

## Security Inspection Summary

- AWS Region: Sydney (`ap-southeast-2`)
- S3 public access: All four blocking settings enabled
- Default encryption: AES-256
- Object ownership: `BucketOwnerEnforced`
- Versioning, lifecycle rules, and server access logging: Not configured
- No custom bucket policy or objects found during inspection

See the [S3 Security & Configuration Audit](docs/s3-security-audit.md) for detailed findings.

## Project Overview

This project demonstrates Infrastructure as Code (IaC) using Terraform to define a secure Amazon S3 bucket in the AWS Sydney region (`ap-southeast-2`).

The infrastructure is described as code and can be reviewed with Terraform validation and planning before any resources are deployed.

## Architecture

- **Terraform:** Defines and manages infrastructure configuration.
- **Amazon S3:** Object storage bucket.
- **Public Access Block:** Configures all four S3 public-access protections.
- **Server-Side Encryption:** Configures default AES-256 encryption.
- **Resource Tags:** Identifies resources managed by Terraform.

## Security Practices

- Blocks public ACLs and public bucket policies.
- Enables default server-side encryption.
- Uses variables instead of hardcoding the bucket name.
- Excludes Terraform state files and downloaded provider files from Git.
- Keeps deployment separate from validation and planning.

## Prerequisites

- Terraform installed
- AWS account and appropriately configured credentials for AWS planning or deployment
- A globally unique S3 bucket name

## Files

- `main.tf` — Terraform version requirements and AWS provider configuration
- `variables.tf` — AWS region and bucket-name variables
- `s3.tf` — S3 bucket, public-access block, and encryption configuration
- `.gitignore` — Excludes local Terraform files and state files
- `.terraform.lock.hcl` — Locks provider dependency selections

## Validate the Configuration

```bash
terraform init
terraform fmt
terraform validate
```

## Review the Deployment Plan

After configuring AWS credentials and supplying a unique bucket name, review the proposed changes:

```bash
terraform plan -var="bucket_name=YOUR_UNIQUE_BUCKET_NAME"
```

Replace `YOUR_UNIQUE_BUCKET_NAME` with a globally unique name you control.

`terraform plan` previews proposed changes; it does not create the bucket.

## Cost and Deployment Notes

The existing S3 bucket was inspected using the AWS CLI. Its public-access block and AES-256 default encryption were verified during the audit.

S3 storage and requests may incur charges if resources are created and used. Review AWS pricing before deployment. Do not run `terraform apply` unless you intentionally want to create the resources and have reviewed the plan.

## Skills Demonstrated

- Terraform and Infrastructure as Code
- AWS provider configuration
- S3 resource configuration
- AWS storage security controls
- Variables, resource references, and tags
- Configuration formatting and validation
- Infrastructure planning and cost awareness

## Limitations

The security report documents a point-in-time inspection of selected S3 settings. It is not a complete AWS security audit. Terraform state records resource information but does not independently prove the full deployment history or guarantee that live infrastructure will remain unchanged.
