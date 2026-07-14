# TF Reviewer

On every PR that touches `terraform/**`, a agent runs `terraform plan`, checks the change against team standards, optionally investigates AWS drift via CloudTrail, and posts a review comment on the PR.


## The problem being solved



- **Plan ≠ code review.** A reviewer reading `.tf` can miss destroys, replacements, and data loss that only show up in `terraform plan`.

> Different from other code review based on AI, this gives the **plan**, to the ai to evaluate.

- **Watching for standards** Practices like: "Use company modules" and "require resource tags", if they aren't enforced in review, they get skipped.

> There standards are immediatly evaluated after the PR is created

- **Drifts automatically investigated.** Ad-hoc changes in via console or cli can happen; Or even double onwership of resources.

> This automatically explains *who* changed *what* and *when*.

- **Review bandwidth.** Senior infra people are the bottleneck; agents can do the first pass every PR.

> THe ai Agent might not have all the context, but it will, at minimun, help to raise questions


## Not In the scope (but it could be...)

- **Best Practices**: Suggest improvements
- **Cost Impact**: Estimates cost changes and provides optimization recommendations
- **Security Analysis**: Comprehensive security assessments including IAM, encryption, and access control


## Limitations

- This repository is dedicated to Github, and will not work outside Github + Github Actions


## How it works

```
PR opens / updates (paths: terraform/**)
    → GitHub Actions
        → AWS creds + Terraform init (remote state)
        → openai/codex-action with the review prompt
            → reads Team dos/don’ts
            → terraform plan
            → optional AWS / CloudTrail investigation
        → posts the final message as a PR comment
```

| Piece | Role |
|-------|------|
| [`.github/workflows/tf-codex-review.yml`](.github/workflows/tf-codex-review.yml) | CI: init Terraform, run Codex, comment on the PR |
| [`.github/codex/prompts/tf-plan-review.md`](.github/codex/prompts/tf-plan-review.md) | Agent brief / review checklist |
| [`.github/codex/dos-and-donts.md`](.github/codex/dos-and-donts.md) | Team ABC infrastructure standards |
| [`terraform/`](terraform/) | Demo stack (public + private S3 modules) used as the plan fixture |

The workflow is **plan + review only** — it does not apply.

## What the agent looks for

1. Plan summary vs PR intent (adds / changes / destroys / replacements)
2. Risky blast radius: public exposure, IAM, state, destroys
3. Compliance with [dos-and-donts](.github/codex/dos-and-donts.md) (modules, tags, remote/locked state, no secrets, no laptop applies)
4. Drift not explained by the PR code — with CloudTrail attribution when possible

Reviews are concrete: the prompt requires showing CLI commands used as evidence.

## Demo infrastructure

Root module only instantiates local modules:

- **`public_bucket`** — intentionally public (ACL, policy, website) so reviews can flag standing risk
- **`private_bucket`** — public access blocked, encryption, ownership controls
- Shared tags: `Project`, `BillingCode`, plus purpose/version tags
- Remote S3 backend (PoC may omit DynamoDB locking; the agent can call that out)

## Setup

### 1. GitHub secrets & variables

**Secrets** (Settings → Secrets and variables → Actions):

| Secret | Purpose |
|--------|---------|
| `OPENAI_API_KEY` | Codex via `openai/codex-action` |
| `AWS_ACCESS_KEY_ID` | Plan + optional CloudTrail / AWS CLI |
| `AWS_SECRET_ACCESS_KEY` | Same |

**Variables:**

| Variable | Purpose | Default |
|----------|---------|---------|
| `AWS_REGION` | AWS region | `us-east-1` |
| `TF_STATE_BUCKET` | Remote state bucket name | (required) |

### 2. Local Terraform (optional)

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # edit bucket names / tags
cp backend.hcl.example backend.hcl             # edit state bucket
terraform init -backend-config=backend.hcl
terraform plan
```

Create the state bucket out-of-band before the first init. `*.tfvars`, `backend.hcl`, and `.tfstate` files are gitignored.

### 3. Local secrets (optional tooling)

For local scripts such as [`get_token.sh`](get_token.sh) (GitHub App installation token):

```bash
cp .env.example .env   # fill AWS / OpenAI / GitHub App values
```

`.env` and `*.pem` are gitignored — never commit them.

## Triggering a review

- Open or update a PR that changes files under `terraform/**`
- Or run **Actions → Terraform Codex review → Run workflow** (`workflow_dispatch`)

On pull requests, the agent’s final message is posted as a comment. Example demos in this repo: drift attribution (PR #4) and a clean tag bump (PR #5).

## Repo layout

```
.github/
  workflows/tf-codex-review.yml
  codex/
    prompts/tf-plan-review.md
    dos-and-donts.md
terraform/
  s3.tf
  modules/public_bucket/
  modules/private_bucket/
PRESENTATION.md   # video / demo walkthrough
```

## Limits (PoC)

- Small S3 demo — not a full multi-account org setup
- Review assistant, not a sole merge gate; agent quality varies with prompt/model/permissions
- Drift forensics need CloudTrail and sufficient AWS rights
- Long-lived AWS keys in secrets; production hardening would use OIDC, required checks, and a gated apply job

See [`PRESENTATION.md`](PRESENTATION.md) for a longer walkthrough and demo script.

## License

PoC / demonstration project. Use and adapt as you like for your own pipelines.
