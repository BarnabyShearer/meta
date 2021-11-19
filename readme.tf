resource "github_repository_file" "readme" {
  for_each   = local.repos
  file       = contains(each.value.publish, "pypi.org") ? "README.rst" : "README.md"
  content    = <<EOF
%{if contains(each.value.publish, "pypi.org")}${join("", [for c in range(length(each.key)) : "="])}
${each.key}
${join("", [for c in range(length(each.key)) : "="])}%{else}# ${each.key}%{endif}
%{if contains(each.value.publish, "readthedocs.org")}.. image:: https://readthedocs.org/projects/${each.key}/badge/?version=latest
    :target: https://${each.key}.readthedocs.io/en/latest/?badge=latest
%{endif}%{if contains(each.value.publish, "pypi.org")}
.. image:: https://badge.fury.io/py/${each.key}.svg
    :target: https://badge.fury.io/py/${each.key}
%{endif}%{if contains(each.value.publish, "pkg.go.dev")}
[![go.dev](https://pkg.go.dev/badge/github.com/BarnabyShearer/${each.key}/)](https://pkg.go.dev/github.com/BarnabyShearer/${each.key}/${each.value.version})
%{endif}%{if contains(each.value.publish, "registry.terraform.io")}
[![registry.terraform.io](https://img.shields.io/badge/terraform-docs-success)](https://registry.terraform.io/providers/BarnabyShearer/${replace(each.key, "terraform-provider-", "")}/latest/docs)
%{endif}%{if each.value.link != null}
[${substr(each.value.link, 8, -1)}](${each.value.link})
%{endif}
${split("\n", each.value.description)[0]}
%{if contains(each.value.publish, "pypi.org")}
Install
-------

::

    %{if lookup(each.value, "apt", []) != []}sudo apt install%{for package in each.value.apt} ${package}%{endfor}
    %{endif}python3 -m pip install ${each.key}
%{endif}${join("\n", slice(split("\n", each.value.description), 1, length(split("\n", each.value.description))))}
EOF
  repository = github_repository.main[each.key].name
}
