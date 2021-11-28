locals {
  repos_defaults = {
    license = "gpl-2.0"
    topics  = []
    link    = null
    publish = []
    check   = []
    docs    = []
  }

  repos_repos = {
    meta = {}
    ADS124x = {
      topics = ["arduino"]
    }
    alexa-ping = {
    }
    ankle = {
      license = "bsd-2-clause"
    }
    aoc = {
      link    = "https://adventofcode.com/"
      license = "mit"
      topics  = ["advent-of-code"]
    }
    basic_remote_shell = {}
    binscript          = {}
    DockerFromScratch = {
      license = "mit"
      topics  = ["docker", "dockerfile"]
      publish = ["hub.docker.com"]
    }
    dockerhub = {
      check   = ["go"]
      publish = ["pkg.go.dev"]
      license = "mpl-2.0"
      version = "v2"
    }
    dogoban = {
      topics  = ["game"]
      check   = ["python3"]
      publish = ["pypi.org", "hub.docker.com"]
    }
    efm8 = {
      license = "bsd-3-clause"
      check   = ["python2", "python3"]
      apt     = ["libusb-1.0-0-dev", "libudev-dev"]
      publish = ["pypi.org", "readthedocs.org"]
      topics  = ["EFM8", "AN945", "HID", "Bootloader"]
      docs    = ["efm8_read", "u2fzero"]
      scripts = {
        efm8      = "efm8.__main__:main"
        efm8_read = "efm8.__main__:read"
        u2fzero   = "efm8.u2fzero:main"
      }
      requires = [
        "hidapi>=0.7.99.post21",
        "pythoncrc>=1.21",
        "typing; python_version < \"3\"",
      ]
    }
    email-report-checker = {
      license = "bsd-3-clause"
      check   = ["python3"]
      scripts = {
        "dmarc.py" = "email_report_checker.dmarc:main"
        "tls.py"   = "email_report_checker.tls:main"
      }
      publish = ["pypi.org", "readthedocs.org"]
    }
    htmloverpdf = {
      license = "bsd-3-clause"
      topics  = ["pdf"]
      scripts = {
        htmloverpdf = "htmloverpdf.__main__:main"
      }
      apt      = ["libgirepository1.0-dev", "gir1.2-poppler-0.18", "gir1.2-pango-1.0"]
      requires = ["weasyprint<53", "pygobject", "pycairo", "cairocffi", "lxml", "lxml-stubs"]
      check    = ["python3"]
      publish  = ["pypi.org", "readthedocs.org", "hub.docker.com"]
    }
    imax-b8-serial = {
      requires = ["pyserial"]
      scripts = {
        imax-b8-serial = "imax_b8_serial.__main__:main"
      }
      check   = ["python3"]
      publish = ["pypi.org", "readthedocs.org"]
    }
    kibblekhaos = {
      link   = "https://kibblekhaos.zi.is/"
      topics = ["game"]
    }
    "kvm.py" = {}
    lektor-make = {
      license  = "mit"
      topics   = ["lektor"]
      requires = ["lektor", "typing; python_version < \"3\"", ]
      check    = ["python2", "python3"]
      publish  = ["pypi.org", "readthedocs.org"]
      "lektor.plugins" = {
        make = "lektor_make:MakePlugin"
      }
    }
    pgwebsocket = {
      license  = "gpl-2.0"
      topics   = ["postgresql"]
      requires = ["aiohttp", "psycopg"]
      check    = ["python3"]
      publish  = ["pypi.org", "readthedocs.org"]
    }
    psycopg-pool-prometheus = {
      license = "mit"
      topics  = ["prometheus", "psycopg3"]
      check   = ["python3"]
      publish = ["pypi.org", "readthedocs.org"]
      requires = [
        "psycopg[pool]",
        "prometheus_client",
      ]
    }
    pynfc = {
      license = "bsd-3-clause"
      topics  = ["RFID", "NFC", "Mifare", "Desfire"]
      requires = [
        "typing; python_version < \"3\"",
      ]
      check         = ["python2", "python3"]
      publish       = ["pypi.org", "readthedocs.org"]
      apt           = ["libclang-dev", "libfreefare-dev"]
      build         = ["ctypeslib2 ; python_version > '3'"]
      use_py3_build = true
    }
    pypg = {}
    readthedocs = {
      check   = ["go"]
      publish = ["pkg.go.dev"]
      license = "mpl-2.0"
      version = "v3"
    }
    rov = {}
    scadhelper = {
      topics  = ["3d-printing", "openscad", "openscad-library"]
      license = "cc-by-4.0"
    }
    terraform-provider-dockerhub = {
      topics  = ["terraform", "terraform-provider", "dockerhub"]
      license = "mpl-2.0"
      check   = ["go"]
      publish = ["github.com", "registry.terraform.io"]
    }
    terraform-provider-macaroons = {
      topics  = ["terraform", "terraform-provider", "macaroons", "pypi"]
      license = "mpl-2.0"
      check   = ["go"]
      publish = ["github.com", "registry.terraform.io"]
    }
    terraform-provider-readthedocs = {
      topics  = ["terraform", "terraform-provider", "readthedocs"]
      license = "mpl-2.0"
      check   = ["go"]
      publish = ["github.com", "registry.terraform.io"]
    }
    tftool = {
      topics  = ["terraform"]
      license = "mpl-2.0"
      check   = ["python3"]
      publish = ["pypi.org", "readthedocs.org", "hub.docker.com"]
      scripts = {
        tftool = "tftool.__main__:main"
      }
    }
    things = {
      topics  = ["3d-printing"]
      license = null
    }
  }
  repos = { for k, v in merge(
    { for k, v in local.repos_repos : k => merge(local.repos_defaults, v) },
  ) : k => merge(v, { topics = toset(concat(local.repos_defaults.topics, v.topics)), description = try(file("src/${k}.description.md"), file("src/${k}.description.rst")) }) }

}
