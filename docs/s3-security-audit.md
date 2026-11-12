# AWS S3 Security & Configuration Audit

## Audit Overview

- **Service:** Amazon Simple Storage Service (S3)
- **Region:** Asia Pacific (Sydney) - `ap-southeast-2`
- **Audit Date:** November 13, 2026
- **Infrastructure Management:** Terraform
- **Audit Method:** AWS CLI inspection and Terraform state comparison
- **Scope:** Existing S3 bucket configuration

## Objective

This audit evaluates the security-related configuration and operational
settings of an existing Amazon S3 bucket.

The purpose is to identify enabled security controls, missing
configurations, and differences between Terraform-managed infrastructure
and the live AWS environment.

No AWS resources were created, modified, or deleted during this audit.

## Audit Findings

### 1. Public Access Block

**Status: All four protections enabled**

The following settings were verified using the AWS CLI:

| Configuration | Result |
|---|---|
| BlockPublicAcls | Enabled |
| IgnorePublicAcls | Enabled |
| BlockPublicPolicy | Enabled |
| RestrictPublicBuckets | Enabled |

These controls help prevent unintended public access through S3 ACLs
and bucket policies.

### 2. Default Encryption

**Status: Enabled**

- Encryption algorithm: AES-256 (SSE-S3)
- S3 Bucket Key: Disabled
- SSE-C encryption type: Blocked

Default server-side encryption helps protect objects stored in the bucket.

### 3. Bucket Ownership Controls

**Status: BucketOwnerEnforced**

The live AWS configuration reports `BucketOwnerEnforced`.

This setting disables ACL-based access control and ensures the bucket
owner owns uploaded objects.

This ownership configuration is present in the live AWS environment
but is not explicitly defined in the inspected Terraform configuration.

### 4. Bucket Versioning

**Status: Not configured**

The AWS CLI returned no versioning status, and Terraform state reports
versioning as disabled.

Enabling versioning can help recover previous object versions after
accidental overwrites or deletions.

### 5. Bucket Policy

**Status: No custom bucket policy found**

The AWS CLI returned `NoSuchBucketPolicy`.

Terraform state also reports the bucket policy as null.

This does not mean IAM-based access controls are absent.

### 6. Lifecycle Configuration

**Status: Not configured**

The AWS CLI returned `NoSuchLifecycleConfiguration`.

Lifecycle rules can automate storage transitions and object expiration
to help manage storage costs.

### 7. Server Access Logging

**Status: Not enabled**

The AWS CLI returned an empty logging configuration.

Server access logging can help record requests made to an S3 bucket.

### 8. Stored Objects

**Status: Empty bucket**

- Total objects: 0
- Total storage size: 0 bytes

The bucket contained no objects during the inspection.

### 9. Incomplete Multipart Uploads

**Status: No pending uploads returned**

The multipart upload listing returned no upload entries.

This indicates that no incomplete multipart uploads were listed
at the time of inspection.

## Terraform and Live AWS Comparison

The following resources were found in Terraform state:

1. `aws_s3_bucket.portfolio`
2. `aws_s3_bucket_public_access_block.portfolio`
3. `aws_s3_bucket_server_side_encryption_configuration.portfolio`

| Configuration | Terraform State | Live AWS |
|---|---|---|
| S3 bucket | Recorded | Found |
| Public access block | All four enabled | All four enabled |
| Default encryption | AES256 | AES256 |
| Versioning | Disabled | Not configured |
| Ownership controls | Not explicitly defined | BucketOwnerEnforced |
| Bucket policy | Null | No custom policy |
| Lifecycle rules | Not defined | Not configured |

Terraform state represents recorded infrastructure information.
It should not be treated as a substitute for checking live AWS settings.

## Security Recommendations

1. Consider enabling S3 Versioning if object recovery is required.
2. Explicitly manage ownership controls through Terraform to keep
   infrastructure configuration consistent.
3. Evaluate S3 Lifecycle rules according to actual storage requirements.
4. Consider server access logging or CloudTrail data events when
   additional access auditing is required.
5. Continue enforcing all four S3 public access block settings.
6. Retain default encryption for stored objects.
7. Follow the principle of least privilege when granting IAM permissions.

These are recommendations, not changes performed during this audit.

## Cost and Safety Considerations

- AWS CLI inspection commands used in this audit were read-only.
- No AWS resources were created, modified, or deleted.
- S3 storage and request charges may apply when the bucket is used.
- Additional logging, monitoring, and encryption services may introduce
  additional charges.
- Review AWS pricing before enabling additional services.

## Skills Demonstrated

- AWS CLI
- Amazon S3 security inspection
- S3 public access controls
- Server-side encryption
- S3 Object Ownership
- Terraform state inspection
- Infrastructure configuration comparison
- Cloud security documentation
- Cost awareness and safe operational practices

## Limitations

This audit represents a point-in-time inspection of selected S3
configuration settings.

It is not a complete AWS security assessment. IAM policies, CloudTrail
configuration, account-level security controls, and other services
require separate inspection.

No claim is made that the bucket is completely secure based only
on these findings.
