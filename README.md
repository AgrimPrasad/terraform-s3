# Terraform for S3 Static Website

This is a set of Terraform files to set up a static website in AWS. It makes use of the following resources:

- S3
- Route53
- CloudFront
- Certificate Manager

The end result is a website that supports:

- a primary and secondary domain (typically apex and www domains)
- HTTPS
- redirect from secondary to primary

## Usage

1. Install Terraform
1. Configure your AWS profile
1. `git clone git@github.com:alimac/terraform-s3.git`
1. `cd terraform-s3`

Specify S3 as the state backend for Terraform. This is important since the state file is used by Terraform for reconstruction of your infrastructure.
1. Create a `backend_config.tfvars` file (refer to `backend_config.tfvars.sample`) and specify the key (i.e. name) for the state file + the bucket where it should be saved. We add the aws account number to the S3 bucket name here since S3 bucket names are supposed to be globally unique.
1. Create this new S3 bucket (if it has not been created before) with `terraform apply -target aws_s3_bucket.terraform-state-storage-s3` Make sure versioning is enabled on this bucket, so that the terraform state doesn't get deleted by mistake.
1. Initialize this S3 backend with `terraform init -backend-config="./backend_config.tfvars"`
1. `terraform apply`

You will be prompted to provide values for primary and secondary domain.

In addition to typing values at the prompt, you can create a `terraform.tfvars` file:

```
primary_domain = "example.com"
secondary_domain = "www.example.com"
```

If AWS is not your domain registrar, you will need to set your domain's name servers
to AWS name servers associated with your hosted zone. Terraform will output those
automatically:

```
Outputs:

name_servers = [
    ns-1500.awsdns-59.org,
    ns-1595.awsdns-07.co.uk,
    ns-619.awsdns-13.net,
    ns-63.awsdns-07.com
]
```
