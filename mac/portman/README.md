# 🔌 Port Manager
### by [Utkarsh Ojha](https://github.com/utkarsh-ojha)

> Find what's running on any port, kill it, list all active ports — with a single command.

---

## Why?

Tracking down what's hogging a port is annoying. You end up Googling `lsof` flags, piping through `grep`, and manually killing PIDs every time. This tool wraps all of that into simple, memorable commands.

---

## Features

- **One command to inspect** — `portman 3000` shows exactly what's using the port
- **Kill with confirmation** — `portman kill 3000` terminates the process safely (SIGTERM → SIGKILL fallback)
- **List all ports** — `portman list` shows every active listening port with process info
- **Live watch** — `portman watch 8080` refreshes every 2s until you stop it
- **Well-known port labels** — auto-labels ports like 5432 (PostgreSQL), 3000 (Node/React), 6379 (Redis)
- **Operation history** — timestamped log of every inspect and kill
- **Cross-platform** — macOS and Linux (lsof, ss, netstat)
- **No dependencies** — pure bash, nothing to install except the script

---

## Run the below script with sudo, to install this utility

```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/portman/portman -o ~/Downloads/portman && chmod +x ~/Downloads/portman && sudo mv ~/Downloads/portman /usr/local/bin/portman
```

## Install with, one step at a time

```bash
# Download and install
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/portman/portman -o ~/Downloads/portman
chmod +x ~/Downloads/portman
sudo mv ~/Downloads/portman /usr/local/bin/portman

# Apple Silicon (M1/M2/M3) — use this path instead:
# sudo mv ~/Downloads/portman /opt/homebrew/bin/portman

# Verify
portman help
```

---

## Quick Start

```bash
# Check what's running on port 3000
portman 3000

# Kill it
portman kill 3000

# See all active listening ports
portman list
```

---

## All Commands

| Command | Description |
|---|---|
| `portman <port>` | Show what's running on a port |
| `portman kill <port>` | Kill the process(es) on a port |
| `portman list` | List all active listening ports |
| `portman watch <port>` | Live-watch a port (refreshes every 2s) |
| `portman history` | Show recent portman operations |
| `portman help` | Full help screen |

---

## Examples

```bash
# Inspect a port
portman 3000              # what's on port 3000?
portman 5432              # check PostgreSQL

# Kill a process on a port
portman kill 3000         # kill whatever is on port 3000
portman kill 8080         # free up port 8080

# List all active ports
portman list              # shows port, process, PID, user, and service label

# Live-watch a port
portman watch 8080        # refreshes every 2s, Ctrl+C to stop

# View history
portman history           # see your recent inspect and kill operations
```

---

## Well-Known Ports

portman automatically labels these common ports:

| Port | Service |
|---|---|
| 80 | HTTP |
| 443 | HTTPS |
| 3000 | Node/React dev |
| 3306 | MySQL |
| 4200 | Angular dev |
| 5000 | Flask/Python |
| 5173 | Vite dev |
| 5432 | PostgreSQL |
| 6379 | Redis |
| 8000 | Django/Python |
| 8080 | HTTP alt / Java |
| 8888 | Jupyter |
| 9200 | Elasticsearch |
| 27017 | MongoDB |

---

## Platform Support

| Platform | Tools Used | Status |
|---|---|---|
| macOS Apple Silicon (M1/M2/M3) | lsof | ✅ Full support |
| macOS Intel | lsof | ✅ Full support |
| Linux | ss / netstat / lsof | ✅ Full support |

---

## How It Works

- **Inspect** uses `lsof` (macOS) or `ss`/`netstat` (Linux) to find processes bound to a port
- **Kill** sends `SIGTERM` first, waits briefly, then escalates to `SIGKILL` if the process is still alive — with sudo fallback for permission issues
- **History** is stored in `~/.portman/history` as a timestamped log

---

## License

MIT — free to use, modify, and distribute.

---

<p align="center">Made with 🔌 by <a href="https://github.com/utkarsh-ojha">Utkarsh Ojha</a></p>
