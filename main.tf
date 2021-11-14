resource "github_repository" "main" {
  for_each = local.repos

  name         = each.key
  description  = split("\n", each.value.description)[0]
  homepage_url = each.value.link != null ? each.value.link : contains(each.value.publish, "readthedocs.org") ? "https://${each.key}.readthedocs.io/en/latest/" : contains(each.value.publish, "pkg.go.dev") ? "https://pkg.go.dev/github.com/BarnabyShearer/${each.key}/${each.value.version}" : contains(each.value.publish, "registry.terraform.io") ? "https://registry.terraform.io/providers/BarnabyShearer/${replace(each.key, "terraform-provider-", "")}/latest/docs" : null

  auto_init = true

  has_issues   = true
  has_projects = false
  has_wiki     = false

  allow_merge_commit = false

  allow_auto_merge       = true
  delete_branch_on_merge = true

  archive_on_destroy = true

  topics = [for topic in each.value.topics : lower(topic)]

  vulnerability_alerts = true
}
