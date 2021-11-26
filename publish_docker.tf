resource "dockerhub_repository" "main" {
  lifecycle {
    ignore_changes = [
      full_description,
    ]
  }
  for_each         = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  namespace        = "barnabyshearer"
  name             = lower(github_repository.main[each.key].name)
  description      = split("\n", each.value.description)[0]
  full_description = <<EOF
%{if contains(each.value.publish, "readthedocs.org")}[![readthedocs.io](https://readthedocs.org/projects/${each.key}/badge/?version=latest)](https://${each.key}.readthedocs.io/en/latest/?badge=latest)
%{endif}%{if contains(each.value.publish, "pypi.org")}[![pypi.org](https://img.shields.io/pypi/v/${each.key}?color=success)](https://pypi.org/project/${each.key}/)
%{endif}%{if contains(each.value.publish, "pkg.go.dev")}[![go.dev](https://pkg.go.dev/badge/github.com/BarnabyShearer/${each.key})](https://pkg.go.dev/github.com/BarnabyShearer/${each.key}/${each.value.version})
%{endif}[![issues](https://img.shields.io/github/issues/BarnabyShearer/${each.key})](https://github.com/BarnabyShearer/${each.key}/issues)

[Dockerfile](https://github.com/BarnabyShearer/${each.key}/blob/main/Dockerfile)%{if each.value.link != null}
[${substr(each.value.link, 8, -1)}](${each.value.link})%{endif}
${join("\n", slice(split("\n", each.value.description), 1, length(split("\n", each.value.description))))}
EOF
}

resource "dockerhub_token" "main" {
  label  = "github"
  scopes = ["repo:admin"]
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
  plaintext_value = dockerhub_token.main.token
}
