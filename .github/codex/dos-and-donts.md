# Team ABC — Infrastructure Dos and Don'ts

Team ABC recommendations for creating infrastructure with Terraform.

## Dos

1. **Use approved company modules** for shared resources (S3, IAM, networking, etc.) so defaults, tags, and security controls stay consistent.
2. **Require standard tags** on every resource — at least `Project` and `BillingCode` — so ownership and cost allocation work at scale.
3. **Keep state remote and locked** (S3 + DynamoDB / Terraform Cloud, etc.). Never commit local `.tfstate` or share state files out of band.
4. **Review plans before apply** — treat `terraform plan` output as the change request. Flag destroys, replacements, public exposure, and IAM changes.

## Don'ts

1. **Never create Terraform resources of any kind unless using the company's module.** No hand-rolled `aws_s3_bucket`, IAM roles, VPCs, etc. outside approved modules.
2. **Don't open resources to the public by hand** (public ACLs, broad bucket policies, `0.0.0.0/0` security groups) unless a company module and review process explicitly allow it.
3. **Don't hardcode secrets** in `.tf` files, tfvars committed to git, or CI logs. Use a secrets manager / OIDC / CI secret store.
4. **Don't apply from a laptop to shared/prod accounts.** Changes go through the pipeline (plan → review → apply) with the designated runner role.
