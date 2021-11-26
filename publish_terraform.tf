resource "github_repository_file" "tools" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "registry.terraform.io") }
  file       = "tools.go"
  content    = <<EOF
//go:build tools
// +build tools

package tools

import (
	_ "github.com/hashicorp/terraform-plugin-docs/cmd/tfplugindocs"
)
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "terraform_index" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "registry.terraform.io") }
  file       = "templates/index.md.tmpl"
  content    = <<EOF
---
layout: ""
page_title: "Provider: ${replace(each.key, "terraform-provider-", "")}"
description: |-
  ${split("\n", each.value.description)[0]}
---

# ${replace(each.key, "terraform-provider-", "")} Provider

${each.value.description}

## Example Usage

{{tffile "examples/provider/provider.tf"}}

{{ .SchemaMarkdown | trimspace }}
EOF
  repository = github_repository.main[each.key].name
}
