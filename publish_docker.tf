resource "dockerhub_repository" "main" {
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
${replace(replace(join("\n", slice(split("\n", each.value.description), 1, length(split("\n", each.value.description)))), "\n.. code-block:: bash\n", ""), "Usage\n-----\n\n", "## Usage\n\n    alias ${each.key}=\"docker run --rm --interactive barnabyshearer/${lower(each.key)}\"\n")}
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

data "github_repository_file" "dockerfile" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  file       = "Dockerfile"
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "docker-bake-hcl" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") && k != "DockerFromScratch" }
  file       = "docker-bake.hcl"
  content    = <<EOF
target "docker-metadata-action" {
  context = "./"
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}

group "default" {
  targets = [${join(", ", [for match in regexall("FROM .* AS (?P<target>.*)", data.github_repository_file.dockerfile[each.key].content) : "\"${match.target}\""])}]
}
%{for match in regexall("FROM .* AS (?P<target>.*)", data.github_repository_file.dockerfile[each.key].content)}
target "${match.target}" {
  inherits = ["docker-metadata-action"]
  target = "${match.target}"
}
%{endfor}
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "ci-docker" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") }
  file       = ".github/workflows/ci-docker.yml"
  content    = <<EOF
name: CI Docker

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: hadolint/hadolint-action@v1.6.0
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "publish-docker" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "hub.docker.com") && k != "DockerFromScratch" }
  file       = ".github/workflows/publish-docker.yml"
  content    = <<EOF
name: Publish Docker image

on:
  push:
    tags: [ 'v*' ]

jobs:
  publish:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        flavor:%{for match in regexall("FROM .* AS (?P<target>.*)", data.github_repository_file.dockerfile[each.key].content)}
        - ${match.target}%{endfor}
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v2
      - uses: docker/login-action@v1.10.0
        with:
          username: $${{ secrets.DOCKER_USERNAME }}
          password: $${{ secrets.DOCKER_PASSWORD }}
      - uses: docker/login-action@v1.10.0
        with:
          registry: ghcr.io
          username: $${{ github.actor }}
          password: $${{ secrets.GITHUB_TOKEN }}
      - uses: docker/metadata-action@v3.6.0
        id: meta
        with:
          images: |
            $${{ github.repository }}
            ghcr.io/$${{ github.repository }}
          flavor: |
            latest=$${{ matrix.flavor == 'latest' }}
            suffix=-$${{ matrix.flavor }}
          tags: |
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=semver,pattern={{major}}
      - uses: docker/setup-qemu-action@v1.2.0
        with:
          platforms: linux/arm64
      - uses: docker/setup-buildx-action@v1.6.0
      - uses: docker/bake-action@v1.6.0
        with:
          push: true
          files: |
            ./docker-bake.hcl
            $${{ steps.meta.outputs.bake-file }}
          targets: $${{ matrix.flavor }}
EOF
  repository = github_repository.main[each.key].name
}
