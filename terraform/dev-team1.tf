resource "aws_controltower_account_factory_account" "dev_team1" {
  account_email             = "mr.hemantksharma+devaccount-1@gmail.com"
  account_name              = "devaccount-1"
  organizational_unit_name  = "Sandbox"
  sso_user_email            = "mr.hemantksharma+devaccount-1@gmail.com"
  sso_user_first_name       = "Dev"
  sso_user_last_name        = "Account-1"
 
  tags = {
    owner = "Dev"
    env   = "sandbox"
  }
}
