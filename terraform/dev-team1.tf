module "dev_team1" {
  source = "git::https://oauth2:${var.github_token}@github.com/aws-ia/terraform-aws-control_tower_account_factory_request.git?ref=v1.3.3"

  control_tower_parameters = {
    AccountEmail              = "mr.hemantksharma+devaccount-1@gmail.com"
    AccountName               = "devaccount-1"
    ManagedOrganizationalUnit = "Sandbox"
    SSOUserEmail              = "mr.hemantksharma+devaccount-1@gmail.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "Account-1"
  }

  account_tags = {
    owner = "Dev"
    env   = "sandbox"
  }
}
