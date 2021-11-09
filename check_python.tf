resource "github_repository_file" "pyproject" {
  for_each   = { for k, v in local.repos : k => v if contains(v.check, "python3") }
  file       = "pyproject.toml"
  content    = <<EOF
[build-system]
requires = ["setuptools", "wheel", "setuptools_scm"]
build-backend = "setuptools.build_meta"

[tool.setuptools_scm]

[tool.mypy]
strict = true
mypy_path = "$MYPY_CONFIG_FILE_DIR/types"

[tool.isort]
profile = "black"

[tool.flake8]
max-line-length = 88
extend-ignore = "D202,D403,E203"
max-complexity = 10

[tool.coverage.run]
branch = true
command_line = "-m pytest -v"
omit = [".tox/*"]

[tool.coverage.report]
show_missing = true

[tool.pytest.ini_options]
addopts = "-p no:cacheprovider"

[tool.tox]
legacy_tox_ini = """
[tox]
isolated_build = True
envlist = %{if contains(each.value.check, "python2")}py27,%{endif}py3{7,8,9,10}

[gh-actions]
python =
%{if contains(each.value.check, "python2")}    2.7: py27%{endif}
    3.7: py37
    3.8: py38
    3.9: py39
    3.10: py310

[testenv]
deps =
    mypy%{if contains(each.value.check, "python2")}[python2]%{endif}
    black
    isort
    pytest
    coverage
    pep8-naming
    flake8-docstrings
    pyproject-flake8
commands =
    black --check --diff .
    isort --check --diff .
    mypy .
    pflake8 .
    coverage run
    coverage report --fail-under=100
%{if contains(each.value.check, "python2")}
[testenv:py27]
deps =
    mock
    pytest
    coverage[toml]
commands =
    coverage run
    coverage report --fail-under=100
%{endif}
"""
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "ci_python" {
  for_each   = { for k, v in local.repos : k => v if contains(v.check, "python3") }
  file       = ".github/workflows/ci.yml"
  content    = <<EOF
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [%{if contains(each.value.check, "python2")}'2.7', %{endif}'3.7', '3.8', '3.9', '3.10']
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v2
      with:
        python-version: $${{ matrix.python-version }}
%{if lookup(each.value, "apt", []) != []}    - run: sudo apt install -y%{for package in each.value.apt} ${package}%{endfor}
%{endif}    - run: pip install tox tox-gh-actions
    - run: tox
EOF
  repository = github_repository.main[each.key].name
}


resource "github_repository_file" "setup_cfg" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "pypi.org") }
  file       = "setup.cfg"
  content    = <<EOF
[metadata]
name = ${each.key}
description = ${each.value.description}
long_description = file: README.rst
keywords =%{for keyword in each.value.topics} ${keyword}%{endfor}
author = Barnaby Shearer
author_email = b@zi.is
repository = "https://github.com/BarnabyShearer/${each.key}"
%{if contains(each.value.publish, "readthedocs.io")}documentation = "http://${each.key}.readthedocs.io/en/latest/"
%{endif}classifiers =
    Development Status :: 5 - Production/Stable
%{if each.value.license == "bsd-3-clause"}    License :: OSI Approved :: BSD License
%{endif}%{if each.value.license == "mit"}    License :: OSI Approved :: MIT License
%{endif}%{if contains(each.value.check, "python2")}    Programming Language :: Python :: 2
%{endif}    Programming Language :: Python :: 3

[options]
packages = find:
install_requires = %{for dep in lookup(each.value, "requires", [])}
    ${dep}%{endfor}
python_requires = >=%{if contains(each.value.check, "python2")}2.7%{else}3.7%{endif}
include_package_data = True

[options.package_data]
* = py.typed
%{if lookup(each.value, "scripts", {}) != {} }
[options.entry_points]
console_scripts = %{for script, entry in each.value.scripts}
    ${script} = ${entry}%{endfor}
%{endif}
EOF
  repository = github_repository.main[each.key].name
}

resource "github_repository_file" "publish_python" {
  for_each   = { for k, v in local.repos : k => v if contains(v.publish, "pypi.org") }
  file       = ".github/workflows/publish.yml"
  content    = <<EOF
name: Publish to PyPI

on:
  push:
    tags: [ 'v*' ]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v2
      with:
        python-version: '3.x'
    - run: pip install build
    - run: python -m build
    - uses: pypa/gh-action-pypi-publish@v1.4.2
      with:
        user: __token__
        password: $${{ secrets.PYPI_API_TOKEN }}
EOF
  repository = github_repository.main[each.key].name
}

