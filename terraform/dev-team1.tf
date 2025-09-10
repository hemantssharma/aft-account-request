module "dev_team1" {
  source  = "aws-ia/control_tower_account_factory_request/aws"
  version = "~> 1.0" # or the version you want to pin

  control_tower_parameters = {
    AccountEmail              = "mr.hemantksharma+devaccount-3@gmail.com"
    AccountName               = "devaccount-3"
    ManagedOrganizationalUnit = "Sandbox"
    SSOUserEmail              = "mr.hemantksharma+devaccount-3@gmail.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "Account-3"
  }

  account_tags = {
    owner = "Dev"
    env   = "sandbox"
  }
}
