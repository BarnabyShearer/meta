resource "github_repository_file" "license" {
  for_each   = { for k, v in local.repos : k => v if v.license != null }
  file       = "LICENSE"
  content    = replace(replace(file("src/${each.value.license}"), "[year]", "2021"), "[fullname]", "Barnaby Shearer <b@zi.is>")
  repository = github_repository.main[each.key].name
}
