# 1. Lookup the target division
data "genesyscloud_auth_division" "home" {
  name = var.division_name
}

# 2. Create the integration role
resource "genesyscloud_auth_role" "integration_role" {
  name        = var.auth_role_name
  description = "Role granting ServiceNow the permissions it needs in Genesys Cloud"

  permission_policies {
    domain      = "integration"
    entity_name = "cxCloudSN"
    action_set  = ["add", "delete", "edit", "view"]
  }

  permission_policies {
    domain      = "conversation"
    entity_name = "*"
    action_set  = ["*"]
  }

  permission_policies {
    domain      = "messaging"
    entity_name = "*"
    action_set  = ["*"]
  }
}

# 3. Create the Client Credentials OAuth client
resource "genesyscloud_oauth_client" "servicenow_integration" {
  name                          = var.oauth_client_name
  access_token_validity_seconds = var.oauth_token_validity_seconds
  authorized_grant_type         = "CLIENT-CREDENTIALS"
  state                         = "active"

  roles {
    role_id     = "d27b6d3f-0682-496d-b93b-e1e9f5797529"
    division_id = "f267d1b7-dd0d-4b0c-97fe-d7cf3b6e85e7"
  }
}

resource "genesyscloud_integration_credential" "credential" {
  credential_type_name = "pureCloudOAuthClient"
  fields = {
    clientId = var.clientId
    clientSecret = var.clientSecret
  }
}