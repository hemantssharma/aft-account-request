Perfect 🚀 — let’s build **5 ready-to-use repo skeletons**. Each repo will contain the minimum Terraform + GitHub Actions workflow you need to get started. You can fork them into your GitHub org, update account IDs, and push.
 
---
 
# 🔹 1. `aft-bootstrap` (deploy the AFT framework)
 
**Repo structure:**
 
```
aft-bootstrap/
├─ main.tf
├─ versions.tf
├─ variables.tf
└─ .github/workflows/deploy.yml
```
 
**main.tf**
 
```hcl
terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "my-terraform-state-bucket"  # replace with your bucket
    key            = "aft-bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-locks"
  }
}
 
provider "aws" {
  region = "us-east-1"
}
 
module "aft" {
source = "github.com/aws-ia/terraform-aws-control_tower_account_factory"
 
  ct_management_account_id  = "111111111111"   # <-- replace
  aft_management_account_id = "222222222222"   # <-- replace
  ct_home_region            = "us-east-1"
 
  vcs_provider                                = "github"
  account_request_repo_name                   = "your-github-user/aft-account-request"
  account_request_repo_branch                 = "main"
  global_customizations_repo_name             = "your-github-user/aft-global-customizations"
  account_customizations_repo_name            = "your-github-user/aft-account-customizations"
  account_provisioning_customizations_repo_name = "your-github-user/aft-provisioning-customizations"
}
```
 
**.github/workflows/deploy.yml**
 
```yaml
name: Deploy AFT
on:
  workflow_dispatch:
 
jobs:
  terraform:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
 
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
 
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::222222222222:role/AFTBootstrapGitHubRole
          aws-region: us-east-1
 
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
 
      - name: Terraform Init
        run: terraform init
 
      - name: Terraform Plan
        run: terraform plan -out=tfplan
 
      - name: Terraform Apply
        run: terraform apply -auto-approve tfplan
```
 
---
 
# 🔹 2. `aft-account-request` (declare new accounts)
 
**Repo structure:**
 
```
aft-account-request/
├─ terraform/
│ └─ dev-team1.tf
└─ .github/workflows/apply.yml
```
 
**terraform/dev-team1.tf**
 
```hcl
module "dev-team1" {
  source = "./modules/aft-account-request"
 
  control_tower_parameters = {
    AccountEmail              = "dev-team1@example.com"
    AccountName               = "dev-team1"
    ManagedOrganizationalUnit = "Sandbox"
    SSOUserEmail              = "lead@example.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "Team1"
  }
 
  account_tags = {
    owner = "team1"
    env   = "sandbox"
  }
}
```
 
**.github/workflows/apply.yml**
 
```yaml
name: Apply Account Requests
on:
  push:
    branches: [ "main" ]
    paths:
      - 'terraform/**.tf'
 
jobs:
  terraform:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
 
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4
 
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::222222222222:role/AFTGitHubRole
          aws-region: us-east-1
 
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
 
      - name: Terraform Init
        run: terraform init
 
      - name: Terraform Apply
        run: terraform apply -auto-approve
```
 
---
 
# 🔹 3. `aft-global-customizations` (applies everywhere)
 
**Repo structure:**
 
```
aft-global-customizations/
├─ terraform/
│ └─ main.tf
└─ .github/workflows/apply.yml
```
 
**terraform/main.tf**
 
```hcl
# Example: enable GuardDuty in all accounts
resource "aws_guardduty_detector" "this" {
  enable = true
}
```
 
**.github/workflows/apply.yml** (same as account-request but runs on all changes)
 
```yaml
name: Apply Global Customizations
on:
  push:
    branches: [ "main" ]
 
jobs:
  terraform:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
 
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::222222222222:role/AFTGitHubRole
          aws-region: us-east-1
      - uses: hashicorp/setup-terraform@v3
      - run: terraform init
      - run: terraform apply -auto-approve
```
 
---
 
# 🔹 4. `aft-account-customizations` (per-account extras)
 
**Repo structure:**
 
```
aft-account-customizations/
├─ dev-team1/
│ └─ main.tf
└─ .github/workflows/apply.yml
```
 
**dev-team1/main.tf**
 
```hcl
# Example: create IAM role in dev-team1 account
resource "aws_iam_role" "dev_role" {
  name = "DevTeam1Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::111111111111:root" }
      Action = "sts:AssumeRole"
    }]
  })
}
```
 
---
 
# 🔹 5. `aft-provisioning-customizations` (advanced tweaks)
 
**Repo structure:**
 
```
aft-provisioning-customizations/
└─ terraform/
└─ main.tf
```
 
**terraform/main.tf**
 
```hcl
# Example placeholder - advanced provisioning hooks
output "provisioning" {
  value = "Custom provisioning logic goes here"
}
```
 
---
 
# 🔹 How they all connect
 
* `aft-bootstrap` → deploys AFT into your **AFT management account**.
* AFT is configured (via bootstrap) to watch your 4 GitHub repos.
* When you push:
 
  * `aft-account-request` → provisions new AWS accounts.
  * `aft-global-customizations` → runs in *all* accounts.
  * `aft-account-customizations` → runs in specific accounts.
  * `aft-provisioning-customizations` → modifies how provisioning happens.
 
---
 
⚡ Next Step for You:
Fork/create these repos in your GitHub org.
Update:
 
* `ct_management_account_id`
* `aft_management_account_id`
* `your-github-user` in repo names
* OIDC IAM role ARNs
 
Then trigger `Deploy AFT` workflow in **`aft-bootstrap`** to wire everything together.
 
---
 
👉 Do you want me to also generate an **IAM policy + trust policy** example for the `AFTGitHubRole` so you can copy it directly when creating that role in your AFT management account?
