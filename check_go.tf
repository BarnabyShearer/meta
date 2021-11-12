resource "github_repository_file" "goreleaser" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "github.com") }
  file       = ".goreleaser.yml"
  content    = <<EOF
builds:
- env:
    - CGO_ENABLED=0
  mod_timestamp: '{{ .CommitTimestamp }}'
  flags:
    - -trimpath
  ldflags:
    - '-s -w -X main.version={{.Version}} -X main.commit={{.Commit}}'
  goos:
    - freebsd
    - windows
    - linux
    - darwin
  goarch:
    - amd64
    - '386'
    - arm
    - arm64
  ignore:
    - goos: darwin
      goarch: '386'
  binary: '{{ .ProjectName }}_v{{ .Version }}'
archives:
- format: zip
  name_template: '{{ .ProjectName }}_{{ .Version }}_{{ .Os }}_{{ .Arch }}'
checksum:
  name_template: '{{ .ProjectName }}_{{ .Version }}_SHA256SUMS'
  algorithm: sha256
signs:
  - artifacts: checksum
    args:
      - "--batch"
      - "--local-user"
      - "{{ .Env.GPG_FINGERPRINT }}"
      - "--output"
      - "$${signature}"
      - "--detach-sign"
      - "$${artifact}"
release:
changelog:
  skip: true
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "ci_go" {
  for_each   = { for k, v in local.repos : k => v if contains(v.check, "go") }
  file       = ".github/workflows/ci.yml"
  content    = <<EOF
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
%{if lookup(each.value, "version", "") != ""}
defaults:
  run:
    working-directory: ${each.value.version}
%{endif}
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.4.0
      - uses: actions/setup-go@v2.1.4
        with:
          go-version: 1.17
      - run: go version
      - run: go build .
      - run: go vet .
EOF
  repository = github_repository.main[each.key].name
}


resource "github_repository_file" "publish_go" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "github.com") }
  file       = ".github/workflows/publish.yml"
  content    = <<EOF
name: Publish as Release

on:
  push:
    tags: [ 'v*' ]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.4.0
      - uses: actions/setup-go@v2.1.4
        with:
          go-version: 1.17
      - uses: crazy-max/ghaction-import-gpg@v4
        id: import_gpg
        with:
          gpg_private_key: $${{ secrets.GPG_PRIVATE_KEY }}
      - uses: goreleaser/goreleaser-action@v2.8.0
        with:
          version: latest
          args: release --rm-dist
        env:
          GPG_FINGERPRINT: $${{ steps.import_gpg.outputs.fingerprint }}
          GITHUB_TOKEN: $${{ secrets.GITHUB_TOKEN }}
EOF
  repository = github_repository.main[each.key].name
}

resource "pgp_key" "ci" {
  name    = "Barnaby Shearer Github Actions"
  email   = "b+terraform@zi.is"
  comment = "Used in Github actions to sign releases."
}

resource "github_actions_secret" "gpg_private_key" {
  for_each        = { for k, v in local.repos : k => v if contains(v.publish, "github.com") }
  repository      = github_repository.main[each.key].name
  secret_name     = "GPG_PRIVATE_KEY"
  plaintext_value = pgp_key.ci.private_key
}
