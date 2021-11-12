locals {
  repos_defaults = {
    description = ""
    license     = "gpl-2.0"
    topics      = ["hacktoberfest"]
    link        = null
    publish     = []
    check       = []
  }

  repos_todo = {
    htmloverpdf = {}
    pgwebsocket = {}
  }

  repos_repos = {
    meta = {
      description = "Version control for my Github Repositories."
    }
    ADS124x = {
      description = "ADS124x library for arduino."
      topics      = ["arduino"]
    }
    alexa-ping = {
      description = "Amazon Alexa skill to check website is responding."
    }
    ankle = {
      description = "A UI for visualizing a stream of location events, such as showing packages being delivered."
      license     = "bsd-2-clause"
    }
    aoc = {
      description = "My Advent of Code."
      link        = "https://adventofcode.com/"
      license     = "mit"
      topics      = ["advent-of-code"]
    }
    basic_remote_shell = {
      description = "Minimum code needed to connect to a OpenSSH Server."
    }
    binscript = {
      description = "Minimal self hosting Asembler."
    }
    DockerFromScratch = {
      description = "Docker From Scratch."
      license     = "mit"
      topics      = ["docker", "dockerfile"]
    }
    dogoban = {
      description = "Your trusty sheepdog is hungry. Help them corral the animals needed to produce their balanced food."
      topics      = ["game"]
    }
    efm8 = {
      description = "Flash via AN945: EFM8 Factory Bootloader HID."
      license     = "bsd-3-clause"
      check       = ["python2", "python3"]
      apt         = ["libusb-1.0-0-dev", "libudev-dev"]
      publish     = ["pypi.org", "readthedocs.org"]
      topics      = ["EFM8", "AN945", "HID", "Bootloader"]
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
      description = "RFC 7489 & 8460 SMTP Report Monitoring Utilities."
      license     = "bsd-3-clause"
    }
    imax_b8_serial = {
      description = "Serial interface to monitor LiPo charger."
    }
    kibblekhaos = {
      description = "Your trusty space dog is hungry. You have travelled to the farm belt where the nutrient asteroids grow."
      link        = "https://kibblekhaos.zi.is/"
      topics      = ["game"]
    }
    "kvm.py" = {
      description = "Minimalist python to run amd64 code via kvm."
    }
    lektor-make = {
      description = "Lektor plugin to run `make lektor` for custom build systems."
      license     = "mit"
      topics      = ["lektor"]
      requires    = ["lektor"]
      check       = ["python2", "python3"]
      publish     = ["pypi.org", "readthedocs.org"]
    }
    psycopg-pool-prometheus = {
      description = "Exposes the pool stats maintained by psycopg3's connection pool to prometheus."
      license     = "mit"
      topics      = ["prometheus", "psycopg3"]
      check       = ["python3"]
      publish     = ["pypi.org", "readthedocs.org"]
      requires = [
        "psycopg[pool]",
        "prometheus_client",
      ]
    }
    pynfc = {
      description = "`ctypeslib` converted libnfc and libfreefare."
      license     = "bsd-3-clause"
      topics      = ["RFID", "NFC", "Mifare", "Desfire"]
      check       = ["python2", "python3"]
      publish     = ["pypi.org", "readthedocs.org"]
      apt         = ["libclang-dev", "libfreefare-dev"]
      build       = ["ctypeslib2"]
    }
    pypg = {
      description = "Minimal Toy PGP in pure python."
    }
    readthedocs = {
      description = "Golang API client."
      check       = ["go"]
      license     = "mpl-2.0"
      version     = "v3"
    }
    rov = {
      desription = "Underwater ROV Prototype."
    }
    scadhelper = {
      description = "A library to make SCAD easier."
      topics      = ["3d-printing", "openscad", "openscad-library"]
      license     = "cc-by-4.0"
    }
    terraform-provider-macaroons = {
      description = <<EOF
Macaroons are flexible authorization credentials that support decentralized delegation, attenuation, and verification. Given an existing credential this provider can attenuate it for a specific use.

At the moment it is tested for scoping a pypi.org's API token per project (PRs for other uses welcome).
EOF
      topics      = ["terraform", "terraform-provider", "macaroons", "pypi"]
      license     = "mpl-2.0"
      check       = ["go"]
      publish     = ["github.com", "registry.terraform.io"]
    }
    terraform-provider-readthedocs = {
      description = "Register readthedocs.org projects."
      topics      = ["terraform", "terraform-provider", "readthedocs"]
      license     = "mpl-2.0"
      check       = ["go"]
      publish     = ["github.com", "registry.terraform.io"]
    }
    things = {
      description = "Designs for lasercutting, 3D printing, milling etc."
      topics      = ["3d-printing"]
      license     = null
    }
  }
  repos = { for k, v in merge(
    { for k, v in local.repos_repos : k => merge(local.repos_defaults, v) },
  ) : k => merge(v, { topics = toset(concat(local.repos_defaults.topics, v.topics)) }) }

}
