resource "github_repository_file" "security" {
  for_each   = local.repos
  file       = "SECURITY.md"
  content    = <<EOF
# Security Policy

## Supported Versions

Latest release only.

## Reporting a Vulnerability

Please report security issues directly to <b@zi.is> ideally using gpg #9B99D8A9846EA13F0E21F23A1F5B4AEDA0D1EABC
EOF
  repository = github_repository.main[each.key].name
}
