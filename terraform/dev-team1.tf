module "dev-team1" {
  source = "./modules/aft-account-request"
 
  control_tower_parameters = {
    AccountEmail              = "mr.hemantksharma+devaccount-4@gmail.com"
    AccountName               = "devaccount-4"
    ManagedOrganizationalUnit = "Sandbox"
    SSOUserEmail              = "mr.hemantksharma+devaccount-4@gmail.com"
    SSOUserFirstName          = "Dev"
    SSOUserLastName           = "Account-4"
  }
 
  account_tags = {
    owner = "Dev"
    env   = "sandbox"
  }
}
