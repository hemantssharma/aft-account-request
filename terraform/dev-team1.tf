module "dev-team1" {
  source = "./modules/aft-account-request"
 
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
