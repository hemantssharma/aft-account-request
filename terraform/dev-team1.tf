module "dev_team1" {
  source  = "aws-ia/control-tower-account-factory-request/aws"
  version = "1.3.3"

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
