resource "github_repository_file" "readme" {
  for_each   = local.repos
  file       = contains(each.value.publish, "pypi.org") ? "README.rst" : "README.md"
  content    = <<EOF
%{if contains(each.value.publish, "pypi.org")}${join("", [for c in range(length(each.key)) : "="])}
${each.key}
${join("", [for c in range(length(each.key)) : "="])}%{else}# ${each.key}%{endif}
%{if contains(each.value.publish, "readthedocs.org")}.. image:: https://readthedocs.org/projects/${each.key}/badge/?version=latest
    :target: https://${each.key}.readthedocs.io/en/latest/
%{endif}%{if contains(each.value.publish, "pypi.org")}.. image:: https://img.shields.io/pypi/v/${each.key}?color=success
    :target: https://pypi.org/project/${each.key}
%{endif}%{if contains(each.value.publish, "pypi.org") && contains(each.value.publish, "hub.docker.com")}.. image:: https://img.shields.io/docker/v/barnabyshearer/${lower(each.key)}/latest?color=success&label=docker
    :target: https://hub.docker.com/repository/docker/barnabyshearer/${lower(each.key)}
%{endif}%{if !contains(each.value.publish, "pypi.org") && contains(each.value.publish, "hub.docker.com")}[![hub.docker.io](https://img.shields.io/docker/v/barnabyshearer/${lower(each.key)}/latest?color=success&label=docker)](https://hub.docker.com/repository/docker/barnabyshearer/${lower(each.key)})
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

.. code-block:: bash

    %{if lookup(each.value, "apt", []) != []}sudo apt install%{for package in each.value.apt} ${package}%{endfor}
    %{endif}python3 -m pip install ${each.key}
%{endif}${join("\n", slice(split("\n", each.value.description), 1, length(split("\n", each.value.description))))}
EOF
  repository = github_repository.main[each.key].name
}
