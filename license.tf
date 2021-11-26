variable "GITHUB_TOKEN" {
  type = string
}

locals {
  license = { for k, v in data.http.license : k => jsondecode(v.body).body }
}

data "http" "license" {
  for_each = toset(distinct([for repos in local.repos : repos.license if repos.license != null]))
  url      = "https://api.github.com/licenses/${each.key}"
  request_headers = {
    Authorization = "Barer ${var.GITHUB_TOKEN}"
  }
}

resource "github_repository_file" "license" {
  lifecycle {
    ignore_changes = [
      content,
    ]

  }
  for_each   = { for k, v in local.repos : k => v if v.license != null }
  file       = "LICENSE"
  content    = "fish" #replace(replace(local.license[each.value.license], "[year]", "2021"), "[fullname]", "Barnaby Shearer <b@zi.is>")
  repository = github_repository.main[each.key].name
}
