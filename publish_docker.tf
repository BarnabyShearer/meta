resource "dockerhub_repository" "main" {
  for_each         = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  namespace        = "barnabyshearer"
  name             = lower(github_repository.main[each.key].name)
  description      = split("\n", each.value.description)[0]
  full_description = github_repository_file.readme[each.key].content
}

resource "dockerhub_token" "main" {
  for_each = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  label    = github_repository.main[each.key].name
  scopes   = ["repo:admin"]
}

resource "github_actions_secret" "docker_username" {
  for_each        = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  repository      = github_repository.main[each.key].name
  secret_name     = "DOCKER_USERNAME"
  plaintext_value = "barnabyshearer"
}

resource "github_actions_secret" "docker_password" {
  for_each        = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  repository      = github_repository.main[each.key].name
  secret_name     = "DOCKER_PASSWORD"
  plaintext_value = dockerhub_token.main[each.key].token
}
