resource "github_repository" "main" {
  for_each = local.repos

  name         = each.key
  description  = each.value.description
  homepage_url = each.value.link

  has_issues   = true
  has_projects = false
  has_wiki     = false

  allow_merge_commit = false

  allow_auto_merge       = true
  delete_branch_on_merge = true

  license_template = each.value.license

  archived = each.value.archived

  archive_on_destroy = true

  topics = each.value.topics

  vulnerability_alerts = true
}
