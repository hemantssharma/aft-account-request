module "dev_team1" {
  source  = "aws-ia/account-request/aws"
  version = "~> 1.2" # pin to latest compatible release

  control_tower_parameters = {
    AccountEmail              = "mr.hemantksharma+devaccount-3@gmail.com"
    AccountName               = "devaccount-3"
    ManagedOrganizationalUnit = "Sandbox"   # must exist in Control Tower
    SSOUserEmail              = "mr.hemantksharma+devaccount-3@gmail.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "Account-3"
  }

  account_tags = {
    owner = "Dev"
    env   = "sandbox"
  }
}
