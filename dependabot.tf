resource "github_repository_file" "dependabot" {
  for_each   = { for k, v in local.repos : k => v if v.check != [] }
  file       = ".github/dependabot.yml"
  content    = <<EOF
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "daily"
%{if contains(each.value.check, "python3")}
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "daily"
%{endif}
%{if contains(each.value.check, "go")}
  - package-ecosystem: "gomod"
    directory: "/"
    schedule:
      interval: "daily"
%{endif}
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "codeql" {
  for_each   = { for k, v in local.repos : k => v if v.check != [] }
  file       = ".github/workflows/codeql-analysis.yml"
  content    = <<EOF
name: "CodeQL"

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '39 13 * * 1'

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      security-events: write

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v1
      with:
        languages:%{if contains(each.value.check, "python3")} python%{endif}%{if contains(each.value.check, "go")} go%{endif}

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v1
EOF
  repository = github_repository.main[each.key].name
}


