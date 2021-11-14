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
      description = <<EOF
A UI for visualizing a stream of location events, such as showing packages being delivered.

    npm install
    npm start
    docker-compose up -d
    pipenv run ./feed.py
EOF
      license     = "bsd-2-clause"
    }
    aoc = {
      description = "My Advent of Code."
      link        = "https://adventofcode.com/"
      license     = "mit"
      topics      = ["advent-of-code"]
    }
    basic_remote_shell = {
      description = <<EOF
Minimum code needed to connect to a OpenSSH Server.

Note: This dose **NOT** attempt to be a _conformant_ implementation. Its goal is to take every shortcut in creating low-traffic, short lived sessions to modern OpenSSH servers.

Note: Whilst my aim is keep this secure; I don't know what I am doing and you **MUST** assume it isn't.
EOF
    }
    binscript = {
      description = "Minimal self hosting Asembler."
    }
    DockerFromScratch = {
      description = <<EOF
Builds docker images for a simple Python + Postgres App from scratch.

Made possible by [Linux From Scratch](http://www.linuxfromscratch.org/).

![That is not a Dockerfile](./meme.jpg)

Favours:
- Up to date
- Stable
- Default configuration
- Most common features enabled
- Minimal programs and libraries in each image

Build and run a Nginx, uWSGI + Python, Postgres stack:

    DOCKER_CONTENT_TRUST=1 COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker-compose up -d
 
You can also cross-compile:

    docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
    docker buildx build --platform linux/arm64 --tag=scratch-nginx --target=nginx .
EOF
      license     = "mit"
      topics      = ["docker", "dockerfile"]
    }
    dogoban = {
      description = <<EOF
Your trusty sheepdog is hungry. Help them corral the animals needed to produce their balanced food.
     ./dogoban level001.txt

Your dog responds to commands for the compass cardinal points: WASD.
They can only herd animals away from them; so be careful not to get stuck in a corner.

## Screenshot

    　　　⬛⬛⬛⬛⬛　　
    　　⬛　　　　　⬛　
    　⬛　　　🐕　　　⬛
    　⬛　　　　　　　⬛
    　⬛　　　🎯　　　⬛
    　⬛　　　　　　　⬛
    　⬛　　　🐓　　　⬛
    　　⬛　　　　　⬛　
    　　　⬛⬛⬛⬛⬛　　
EOF
      topics      = ["game"]
    }
    efm8 = {
      description = <<EOF
Flash via AN945: EFM8 Factory Bootloader HID.

::

    sudo apt install libusb-1.0-0-dev libudev-dev python-dev
    pip install efm8
    efm8 firmware.hex

Also includes an example that resets a https://u2fzero.com/ into the bootloader and flashes in one command.

::

    u2fzero firmware.hex

And a way to (slowly) read the firmware back

::

    efm8_read firmware.hex
EOF
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
      description = <<EOF
RFC 7489 & 8460 SMTP Report Monitoring Utilities.

Note these are for my hobby domain, do not try running them on even moderate traffic MTAs

## RFC 7489 Domain-based Message Authentication, Reporting, and Conformance (DMARC)

First ensure your DMARC DNS TXT record contains `rua` and `ruf` to request reports:

    _dmarc.zi.is.		3600	IN	TXT	"v=DMARC1; p=reject; pct=100; ruf=mailto:b+dmarc@zi.is; rua=mailto:b+dmarc@zi.is; adkim=s; aspf=s"

Then load the reports via IMAP:

    ./dmarc.py m.zi.is b@zi.is Archive > dmarc.json

And report your statistics

    jq '[ .[].record.row | select(.source_ip == "68.183.35.248") | select(.policy_evaluated.dkim == "pass") | .count | tonumber] | add' dmarc.json
    jq '[ .[].record.row | select(.source_ip == "68.183.35.248") | select(.policy_evaluated.dkim == "fail") | .count | tonumber] | add' dmarc.json


## RFC 8460 SMTP TLS Reporting

First create a DNS TXT record to request reports:

    _smtp._tls.zi.is.	3600	IN	TXT	"v=TLSRPTv1;rua=mailto:b+tls@zi.is"

Then load the reports via IMAP:

    ./tls.py m.zi.is b@zi.is Archive > tls.json

And report your statistics

    jq '[.[] | [.policies[].summary["total-successful-session-count"]] | add] | add' tls.json
    jq '[.[] | [.policies[].summary["total-failure-session-count"]] | add] | add' tls.json
EOF
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
      requires    = ["lektor", "typing; python_version < \"3\"", ]
      check       = ["python2", "python3"]
      publish     = ["pypi.org", "readthedocs.org"]
    }
    psycopg-pool-prometheus = {
      description = "Expose metrics maintained by psycopg3's connection pool to prometheus."
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
      description = <<EOF
`ctypeslib` converted libnfc and libfreefare.

Install
-------
::

    sudo apt install libfreefare-dev
    pip install pynfc

Usage
-----
::

    from pynfc import Nfc, Desfire, Timeout
    
    n = Nfc("pn532_uart:/dev/ttyUSB0:115200")
    
    DESFIRE_DEFAULT_KEY = b'\x00' * 8
    MIFARE_BLANK_TOKEN = b'\xFF' * 1024 * 4
    
    for target in n.poll():
        try:
            print(target.uid, target.auth(DESFIRE_DEFAULT_KEY if type(target) == Desfire else MIFARE_BLANK_TOKEN))
        except TimeoutException:
            pass

Develop
-------
::

    sudo apt install libfreefare-dev libclang-5.0-dev
    git clone https://github.com/BarnabyShearer/pynfc.git
    cd pynfc
    python3 setup.py develop --user
EOF
      license     = "bsd-3-clause"
      topics      = ["RFID", "NFC", "Mifare", "Desfire"]
      requires = [
        "typing; python_version < \"3\"",
      ]
      check         = ["python2", "python3"]
      publish       = ["pypi.org", "readthedocs.org"]
      apt           = ["libclang-dev", "libfreefare-dev"]
      build         = ["ctypeslib2 ; python_version > '3'"]
      use_py3_build = true
    }
    pypg = {
      description = "Minimal Toy PGP in pure python."
    }
    readthedocs = {
      description = "Golang API client."
      check       = ["go"]
      publish     = ["pkg.go.dev"]
      license     = "mpl-2.0"
      version     = "v3"
    }
    rov = {
      desription = <<EOF
Underwater ROV Prototype.
Underwater ROV Prototype.

Target specifications:
- Live 1080p video.
- 0-100m depth.
- Cost efficient and reproducable.

## Development

Editable in [OpenSCAD](https://www.openscad.org/downloads.html).

[Preview](./rov.stl)

[BOM](./BOM.txt)

![Full](./rov001.png)

![Transparent](./rov002.png)

![](./rov003.png)
EOF
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
