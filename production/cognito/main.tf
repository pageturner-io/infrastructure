data "template_file" "verification_message_template_content" {
  template = "${file("./production/cognito/templates/verification_message_template_content.tpl")}"
}

resource "aws_cognito_user_pool" "pageturner_production" {
  name = "pageturner-production"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_LINK"
    email_message_by_link = "${data.template_file.verification_message_template_content.rendered}"
  }

  password_policy {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  tags {
    "Environment" = "production"
  }
}

resource "aws_cognito_identity_provider" "google_provider_production" {
  user_pool_id  = "${aws_cognito_user_pool.pageturner_production.id}"
  provider_name = "Google"
  provider_type = "Google"

  provider_details {
    authorize_scopes              = "profile email"
    client_id                     = "${var.google_oauth_client_id}"
    client_secret                 = "${var.google_oauth_client_secret}"
    attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
    attributes_url_add_attributes = "true"
    authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
    oidc_issuer                   = "https://accounts.google.com"
    token_request_method          = "POST"
    token_url                     = "https://www.googleapis.com/oauth2/v4/token"
  }

  attribute_mapping {
    email    = "email"
    name     = "name"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "facebook_provider_production" {
  user_pool_id  = "${aws_cognito_user_pool.pageturner_production.id}"
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details {
    authorize_scopes              = "email"
    client_id                     = "${var.facebook_app_id}"
    client_secret                 = "${var.facebook_app_secret}"
    attributes_url                = "https://graph.facebook.com/me?fields="
    attributes_url_add_attributes = "true"
    authorize_url                 = "https://www.facebook.com/v2.9/dialog/oauth"
    token_request_method          = "GET"
    token_url                     = "https://graph.facebook.com/v2.9/oauth/access_token"
  }

  attribute_mapping {
    email    = "email"
    name     = "name"
    username = "id"
  }
}

resource "aws_cognito_user_pool_client" "pageturner_web_production" {
  name = "pageturner-web-production"

  user_pool_id = "${aws_cognito_user_pool.pageturner_production.id}"

  supported_identity_providers = [
    "COGNITO",
    "Facebook",
    "Google",
  ]

  depends_on = [
    "aws_cognito_identity_provider.facebook_provider_production",
    "aws_cognito_identity_provider.google_provider_production",
  ]
}
