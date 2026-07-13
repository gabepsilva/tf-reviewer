Explain the Terraform plan output.

You have `aws` CLI and `terraform` available. You are an agent running on a GitHub Actions workflow.

Working directory for Terraform is `terraform/`. Backend config is already initialized (`backend.hcl` + `terraform.tfvars` are present).

Use the tools to:
1. Inspect the Terraform code and the current plan (`terraform plan -no-color -input=false` in `terraform/`).
2. Confirm the plan matches what the code intends.
3. Call out any risky operations (destroys, replacements, public exposure, IAM, state, etc.).

Be concrete and concise.
