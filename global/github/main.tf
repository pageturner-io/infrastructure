resource "github_membership" "inf0rmer_organization_membership" {
  username = "inf0rmer"
  role     = "admin"
}

resource "github_repository" "infrastructure" {
  name        = "infrastructure"
  description = "Pageturner Infrastructure as Code"
}

resource "github_repository" "website" {
  name        = "website"
  description = "Pageturner website"
}

resource "github_team" "admins" {
  name        = "admins"
  description = "Pageturner Administrators"
  privacy     = "closed"
}

resource "github_team_membership" "inf0rmer-admins-membership" {
  team_id  = "${github_team.admins.id}"
  username = "inf0rmer"
  role     = "maintainer"
}

resource "github_team_repository" "infrastructure" {
  team_id    = "${github_team.admins.id}"
  repository = "${github_repository.infrastructure.name}"
  permission = "push"
}

resource "github_team_repository" "website" {
  team_id    = "${github_team.admins.id}"
  repository = "${github_repository.website.name}"
  permission = "push"
}
