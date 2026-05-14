# AirConnect: AirPlay → Chromecast bridge

This repository builds `aircast`, the Chromecast/Google Home target for AirPlay audio.
It is intended for a Raspberry Pi or other Linux host that receives audio from an iOS device and forwards it to Chromecast devices on the same local network.

It will detect Chromecast players (e.g. Google Home Speakers), create as many virtual AirPlay devices as needed, and act as a bridge/proxy between AirPlay clients (iPhone, iPad, iTunes, MacOS, AirFoil ...) and the real Chromecast players.

## Attribution and repo structure

This project is a fork from Philippe44/AirConnect, hardened by fixing vulnerablities detected with CodeQL and Dependabot, and minimized to focus on the iOS → Google Home use case, thus removing all unnecessary features and dependencies.
For the full-featured functionality, including Sonos and UPnP compatibility and different platform build options, see the original repo (or the `master` branch of this one: see below). The original README file also includes a much more in-depth explanation of the inner workings of the software.

The default branch is `hardened`. The `master` branch mirrors the original upstream repo, and is used to pull changes which are then imported into `hardened`. See `sync-upstream.sh`.

## What this repo provides

- `aircast/` — the component that bridges AirPlay input to Chromecast output
- shared libraries under `common/` needed by `aircast`
- build scripts for native or cross-platform compilation

## Build from source (Raspberry Pi/Linux)

1. Clone the repository and initialize submodules:

```bash
git clone https://github.com/GiuliaLo/AirConnect.git
cd AirConnect
git submodule update --init --recursive
```

2. Build only the `aircast` component.

For a 64-bit Raspberry Pi OS:

```bash
cd aircast
make CC=gcc HOST=linux PLATFORM=aarch64 -j$(nproc)
```

For a 32-bit Raspberry Pi OS:

```bash
cd aircast
make CC=gcc HOST=linux PLATFORM=arm -j$(nproc)
```

3. The executable is written to `bin/aircast-<host>-<platform>`.
For example:

```bash
ls -l bin/aircast-linux-aarch64
```

## Run

Run the built `aircast` binary from the repository root.

```bash
./bin/aircast-linux-aarch64 -Z
```

Useful runtime options:

- `-Z` : disable interactive mode
- `-z` : disable interactive mode and self-daemonize
- `-h` : show help and available command-line options
- `-c mp3|aac|flac` : choose the audio codec used for Chromecast output
- `-v <scale>` : set Chromecast volume factor
- `-b <ip|iface>` : bind to a specific network interface or address
- `-N "<name>"` : set the AirPlay device name

If you want the process to run in the background, use `-z` or create a systemd unit that starts the `aircast` binary with `-Z`/`-z`.

## Network requirements

- Your Raspberry Pi and Chromecast devices must be on the same local network.
- UDP port `5353` must be reachable for mDNS discovery.
- Each device uses 1 port permanently (RTSP) and when playing adds 1 port for HTTP and 3 ports for RTP (use `-g`or \<ports\> parameter, default is random)
- If running inside Docker, use host networking so Chromecast discovery works.