locals {
  repos_defaults = {
    description = null
    license  = "gpl2"
    topics   = ["hacktoberfest"]
    archived = false
    link     = null
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
      topic       = ["arduino"]
    }
    alexa-ping = {
      description = "Amazon Alexa skill to check website is responding."
    }
    ankle = {
      description = "A UI for visualizing a stream of location events, such as showing packages being delivered."
      license     = "bsd2"
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
      license     = "bsd3"
      publish     = ["pypi.org", "readthedocs.org"]
    }
    email-report-checker = {
      description = "RFC 7489 & 8460 SMTP Report Monitoring Utilities."
      license     = "bsd3"
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
      publish     = ["pypi.org", "readthedocs.org"]
    }
    psycopg-pool-prometheus = {
      description = "Exposes the pool stats maintained by psycopg3's connection pool to prometheus."
      license     = "mit"
      topics      = ["prometheus", "psycopg3"]
      publish     = ["pypi.org", "readthedocs.org"]
    }
    pynfc = {
      description = "`ctypeslib` converted libnfc and libfreefare."
      license     = "bsd3"
      publish     = ["pypi.org", "readthedocs.org"]
    }
    pypg = {
      description = "Minimal Toy PGP in pure python."
    }
    rov = {
      desription = "Underwater ROV Prototype."
    }
    scadhelper = {
      description = "A library to make SCAD easier."
      topics      = ["3d-printing", "openscad", "openscad-library"]
      license     = "https://creativecommons.org/licenses/by/3.0/legalcode.txt"
    }
    things = {
      description = "Designs for lasercutting, 3D printing, milling etc."
      topics      = ["3d-printing"]
      license     = null
    }
  }
  repos_archived = {
    "64bit" = {
      description = "Firmware for https://github.com/BarnabyShearer/signalsignal"
      link        = "https://github.com/BarnabyShearer/signalsignal"
    }
    Anders = {
      description = "WIP Android app for Chinesium BLE cooking/BBQ thermometers."
      license     = "gpl3"
      topic       = ["android", "ble"]
    }
    anemopen = {
      description = "Opensource Anemometer."
      topic       = ["arduino", "3d-printing"]
    }
    arm = {
      description = "¯\\_(ツ)_/¯"
      topic       = ["hack"]
    }
    async_or_not = {
      description = "Help chose performance trade offs."
      topic       = ["benchmark"]
    }
    autopi = {
      description = "Quick and dirty script to get a headless Raspberry Pi ready to use."
      license     = "apache"
    }
    aux_lcd = {
      description = "Ultra compact PCB using a battery, memory lcd, and bluetooth chip."
    }
    ble_temp_probe_decoder = {
      description = "Bluetooth LE Cooking/BBQ temperature sensor."
      license     = "apache"
    }
    dash = {
      description = "Amazon Dash button utils."
    }
    DroidRap = {
      description = "Minimal G-Code host for Android."
      license     = "gpl3"
      topic       = ["android"]
    }
    eyepatch = {
      description = "Android camera monitor headset (phone are cheeper then eyes when using lasers)."
      license     = "gpl3"
      topic       = ["android"]
    }
    falcon = {
      description = "Demos for the Novint Falcon haptic controler."
      license     = "bsd3"
    }
    gcode2mint = {
      description = "Allows driving the Denford MicroMill 2000 (and hopfully similar devices) via standard g-code. "
    }
    genuary = {
      description = "My genuary."
      link        = "https://genuary2021.github.io/"
    }
    MemoryLCD = {
      description = "STM32F4 Sharp Memory LCD."
      license     = "bsd3"
      topics      = ["arduino"]
    }
    microformats = {
      description = "Micoroformats."
      link        = "https://microformats.org/wiki/what-are-microformats"
    }
    microg = {
      description = "Micro-g toy g-code interpritor designed to be highly portable; but initially on AVR."
    }
    nodemcu_proxy = {
      description = "Simple UART->TCP port 6789 proxy."
    }
    pcb_workshop_sensor = {
      description = "Simple lowpower MSP and Temp sensor PCB for a PCB design workshop."
    }
    phone_chord = {
      description = "An 8-key chording BLE HID keyboard."
      license     = "mit"
      topics      = ["arduino"]
    }
    PiSlideshow = {
      description = "Updatable slideshow kiosk on Raspberry Pi."
    }
    ppm2joy = {
      description = "vjoy module with decodes a 6 channel PPM signal captured via SUMP."
      license     = "gpl3"
    }
    pyquiz = {
      description = "Run a simple button mashing quiz."
      license     = "apache"
      topic       = ["game"]
    }
    rt100 = {
      description = "UMI RT100 Robot Arm controller."
    }
    rtlapt = {
      description = "NOAA Automatic Picture Transmission (Wether) reception via RTL SDR."
    }
    rust-minimal-wayland-egl-opengles = {
      description = "Test rust and opgengl."
    }
    signalsignal = {
      description = "PCB for cheep high-density IO."
    }
    slushie = {
      description = "Smothieboard derivative."
      license     = "https://ohwr.org/project/cernohl/uploads/505f27c2a8a10e528b079be3c9d876c5/cern_ohl_v_1_2.txt"
    }
    stereo = {
      description = "Try and get two USB cameras in sync to create stereo images."
    }
    terraform-provider-wait-srv = {
      description = "Allow terraform to wait for a SRV record to exist."
    }
    u2f-zero = {
      description = "U2F USB token optimized for physical security, affordability, and style."
      license     = "bsd3"

    }
    wavey = {
      description = "Exeperiment on non-plainer layers on RepRap."
      topics      = ["3d-printing"]
    }
    wireless_serial_camera = {
      description = "Wireless serial camera between Arduino and RaspberryPi."
    }
    xarcade = {
      description = "Simple interface to plug an X-Arcade controller in as a USB keyboard."
      license     = "mit"
    }
    xkcdris = {
      description = "Game inspired by xkcd \"Hell\"."
      link        = "https://xkcd.com/724/"
      license     = "mit"
      topic       = ["xkcd", "tetris"]
    }
    yugioh = {
      description = "Make consistent collectable cards."
      license     = null
    }
    zsl = {
      description = "Curses interface to control UVC cameras."
    }
  }
  repos = { for k, v in merge(
    { for k, v in local.repos_repos : k => merge(local.repos_defaults, v) },
    { for k, v in local.repos_archived : k => merge(local.repos_defaults, v, { archived = true }) },
  ) : k => merge(v, { topics = concat(local.repos_defaults.topics, v.topics) }) }
}
