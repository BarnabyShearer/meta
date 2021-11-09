resource "github_repository" "main" {
  for_each = local.repos

  name         = each.key
  description  = each.value.description
  homepage_url = each.value.link

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
