resource "github_repository_file" "gitignore" {
  for_each   = { for k, v in local.repos : k => v if v.check != [] }
  file       = ".gitignore"
  content    = <<EOF
%{if contains(each.value.check, "go")}${each.key}%{endif}
%{if contains(each.value.check, "python3")}*.py[oc]
/build
/dist
*.egg-info
/.cache
docs/_build/
.coverage
.tox%{endif}
EOF
  repository = github_repository.main[each.key].name
}

