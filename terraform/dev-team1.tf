locals {
  account_requests = {
    dev-team1 = {
      control_tower_parameters = {
        AccountEmail              = "mr.hemantksharma+devaccount-2@gmail.com"
        AccountName               = "devaccount-2"
        ManagedOrganizationalUnit = "Sandbox"
        SSOUserEmail              = "mr.hemantksharma+devaccount-2@gmail.com"
        SSOUserFirstName          = "Dev"
        SSOUserLastName           = "Account-2"
      }
 
      account_tags = {
        owner = "Dev"
        env   = "sandbox"
      }
    }
  }
}
