resource "readthedocs_project" "readthedocs" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "readthedocs.org") }
  name       = github_repository.main[each.key].name
  repository = github_repository.main[each.key].http_clone_url
}

resource "github_repository_file" "readthedocs" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "readthedocs.org") }
  file       = ".readthedocs.yaml"
  content    = <<EOF
version: 2
formats: all
build:
  os: ubuntu-20.04
  tools:
    python: "3.10"%{if lookup(each.value, "apt", []) != []}
  apt_packages:%{for package in each.value.apt}
  - ${package}%{endfor}%{endif}
python:
  install:
  - requirements: docs/requirements.txt
  - path: .
sphinx:
  configuration: docs/conf.py
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "docs_config" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "readthedocs.org") }
  file       = "docs/conf.py"
  content    = <<EOF
#!/usr/bin/env python3
"""Sphinx config."""

extensions = ["sphinxcontrib.autoprogram", "sphinx.ext.autodoc"]

project = "${split("\n", each.value.description)[0]}"
copyright = "2021, Barnaby Shearer"
author = "Barnaby Shearer"

master_doc = "index"
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "docs_requirments" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "readthedocs.org") }
  file       = "docs/requirements.txt"
  content    = <<EOF
sphinxcontrib-autoprogram
docutils<0.18
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "docs_makefile" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "readthedocs.org") }
  file       = "docs/Makefile"
  content    = <<EOF
# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = EFM8Bootloader
SOURCEDIR     = .
BUILDDIR      = _build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
EOF
  repository = github_repository.main[each.key].name
}
