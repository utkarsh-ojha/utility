# 🧰 Utility
### by [Utkarsh Ojha](https://github.com/utkarsh-ojha)

> A collection of lightweight, zero-dependency CLI utilities for macOS and Linux — built in pure bash.

---

## About

This repository is a growing toolkit of single-file bash scripts that solve everyday developer annoyances: managing Java versions, freeing up ports, tracking clipboard history, and more. Each utility is self-contained, requires no external dependencies, and can be installed with a single `curl` command.

---

## Utilities

| # | Utility | Description | Install |
|---|---------|-------------|---------|
| 1 | [☕ jvm](mac/jvm/) | **Java Version Manager** — install, switch, and manage multiple Java versions | `curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/jvm/jvm -o ~/Downloads/jvm && chmod +x ~/Downloads/jvm && sudo mv ~/Downloads/jvm /usr/local/bin/jvm` |
| 2 | [🔌 portman](mac/portman/) | **Port Manager** — find what's running on any port, kill it, list all active ports | `curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/portman/portman -o ~/Downloads/portman && chmod +x ~/Downloads/portman && sudo mv ~/Downloads/portman /usr/local/bin/portman` |
| 3 | [📋 clip](mac/clip/) | **Clipboard History Manager** — persistent clipboard history with search and recall | `curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/clip/clip -o ~/Downloads/clip && chmod +x ~/Downloads/clip && sudo mv ~/Downloads/clip /usr/local/bin/clip` |
| 4 | [📂 goto](mac/goto/) | **Directory Bookmark Engine** — persistent directory bookmarks with sub-pathing | `curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/goto/goto -o ~/Downloads/goto && chmod +x ~/Downloads/goto && sudo mv ~/Downloads/goto /usr/local/bin/goto && goto install` |

---

## Quick Look

### ☕ jvm — Java Version Manager

Manage multiple Java versions without the headache. Auto-detects every JVM on your machine, writes `JAVA_HOME` to your shell profile, supports named aliases, per-project `.java-version` files, and includes a built-in doctor command.

```bash
jvm install 21        # install Java 21
jvm use 21            # switch to it
jvm list              # see all installed versions
jvm doctor            # diagnose issues
```

> [Full documentation →](mac/jvm/README.md)

---

### 🔌 portman — Port Manager

Find, inspect, and kill processes on any port. Labels well-known ports automatically, supports live-watching, and keeps a history of operations.

```bash
portman 3000           # what's on port 3000?
portman kill 3000      # kill it
portman list           # all active listening ports
portman watch 8080     # live-watch a port
```

> [Full documentation →](mac/portman/README.md)

---

### 📋 clip — Clipboard History Manager

Persistent clipboard history for macOS. Every copy is saved, searchable, and recallable. Supports pause/resume and auto-starts on boot via LaunchAgent.

```bash
clip install              # one-time install + auto-start
clip history              # see your clipboard history
clip copy 3               # re-copy the 3rd most recent item
clip search "api key"     # find matching entries
clip pause                # pause tracking without stopping
```

> [Full documentation →](mac/clip/README.md)

---

### 📂 goto — Directory Bookmark Engine

Bookmark any directory with a short alias and jump back instantly. Supports sub-pathing, fuzzy matching, jump history, export/import, tab completion, and dead link detection.

```bash
cd ~/projects/myapp
goto add myapp            # bookmark this directory
goto myapp                # 🚀 jump back from anywhere
goto myapp/src            # jump into a sub-path
goto history              # see recent jumps
goto export > bk.txt      # backup bookmarks
```

> [Full documentation →](mac/goto/README.md)

---

## Platform Support

| Platform | Status |
|---|---|
| macOS Apple Silicon (M1/M2/M3) | ✅ Full support |
| macOS Intel | ✅ Full support |
| Linux (Ubuntu, Fedora, Arch, openSUSE) | ✅ Full support |

---

## Philosophy

- **Single-file scripts** — no build step, no framework, no runtime
- **Zero dependencies** — pure bash, works out of the box
- **One-liner install** — `curl`, `chmod`, `mv` — done
- **Cross-platform** — macOS and Linux with automatic platform detection

---

## License

GPL-3.0 — see [LICENSE](LICENSE) for details.

---

<p align="center">Made by <a href="https://github.com/utkarsh-ojha">Utkarsh Ojha</a></p>
