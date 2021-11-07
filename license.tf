locals {
    license = {for k, v in data.http.license: k => try(v.body.body, v.body)}
}
data "http" "license" {
    for_each = toset(distinct([for repos in local.repos: repos.license if repos.license != null]))
    url = substr(each.key,0,4) == "http" ? each.key : "https://raw.githubusercontent.com/licenses/license-templates/master/templates/${each.key}.txt"
}


resource "github_repository_file" "license" {
    for_each = {for k, v in local.repos: k => v if v.license != null && !v.archived}
    file = "LICENSE"
    content = replace(replace(local.license[each.value.license], "{{ year }}", "2021"), "{{ organization }}", "Barnaby Shearer <b@zi.is>")
    repository = github_repository.main[each.key].name
}
