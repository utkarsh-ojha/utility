# 📋 Clipboard History Manager
### by [Utkarsh Ojha](https://github.com/utkarsh-ojha)

> Persistent clipboard history for macOS — copy it, find it, recall it, with a single command.

---

## Why?

You copy something, then copy something else, and the first thing is gone forever. macOS has no built-in clipboard history. Third-party apps are bloated and expensive. This tool gives you a fast, searchable, persistent clipboard history that lives in your terminal.

---

## Features

- **Persistent history** — every clipboard entry is saved to `~/.clip_history`
- **Base64 storage** — multi-line code, special characters, and quotes are stored safely
- **Instant recall** — `clip copy 3` pushes the 3rd most recent item back to your clipboard
- **Search** — `clip search "api key"` finds matching entries instantly (supports regex)
- **Pause / Resume** — `clip pause` temporarily pauses tracking without stopping the watcher
- **Auto-start on boot** — `clip install` installs a LaunchAgent so the watcher runs automatically
- **100-entry cap** — oldest entries are pruned automatically
- **Duplicate detection** — consecutive identical copies are ignored
- **ANSI-colored output** — clean, readable terminal UI
- **No dependencies** — pure bash, nothing to install except the script

---

## Run the below script with sudo, to install this utility

```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/clip/clip -o ~/Downloads/clip && chmod +x ~/Downloads/clip && sudo mv ~/Downloads/clip /usr/local/bin/clip
```

## Install with, one step at a time

```bash
# Download and install
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/clip/clip -o ~/Downloads/clip
chmod +x ~/Downloads/clip
sudo mv ~/Downloads/clip /usr/local/bin/clip

# Apple Silicon (M1/M2/M3) — use this path instead:
# sudo mv ~/Downloads/clip /opt/homebrew/bin/clip

# Verify
clip help
```

---

## Quick Start

```bash
# Set up auto-start (one time)
clip install

# View your clipboard history
clip history

# Re-copy something from history
clip copy 3

# Search for something you copied
clip search "SELECT"
```

After running `clip install`, the watcher starts automatically on every boot. No manual intervention needed.

---

## All Commands

| Command | Description |
|---|---|
| `clip history [n]` | Show last 50 (or last n) clipboard entries |
| `clip copy <n>` | Copy the n-th item back to system clipboard |
| `clip remove <n>` | Delete a specific entry and re-index |
| `clip search <query>` | Search history for a string or regex (case-insensitive) |
| `clip clean` | Wipe all history (with y/n confirmation) |
| `clip start` | Start the clipboard watcher manually |
| `clip stop` | Stop the clipboard watcher |
| `clip pause` | Pause the watcher (keeps process running, stops tracking) |
| `clip resume` | Resume a paused watcher |
| `clip status` | Check if the watcher is running (and if paused) |
| `clip install` | Install clip + auto-start watcher on boot |
| `clip uninstall` | Undo install — stop watcher, remove LaunchAgent & symlink |
| `clip help` | Full help screen |

---

## Examples

```bash
# View clipboard history
clip history              # last 50 entries
clip history 10           # last 10 entries

# Recall an item
clip copy 1               # re-copy the most recent item
clip copy 5               # re-copy the 5th most recent

# Search
clip search "password"    # find entries containing "password"
clip search "curl"        # find that curl command you copied

# Remove a specific entry
clip remove 3             # delete the 3rd entry

# Wipe everything
clip clean                # asks for confirmation first

# Watcher management
clip start                # start watching clipboard
clip stop                 # stop the watcher
clip pause                # pause tracking (watcher stays alive)
clip resume               # resume tracking
clip status               # is it running? is it paused?

# One-time install (creates symlink + auto-start on boot)
clip install

# Undo install (stop watcher, remove LaunchAgent & symlink)
clip uninstall
```

---

## How It Works

1. **Watcher** — A background process polls `pbpaste` every 1 second
2. **Storage** — Each new clipboard entry is Base64-encoded and appended to `~/.clip_history` with a timestamp
3. **Deduplication** — If the clipboard content matches the most recent entry, it's skipped
4. **Cap** — When history exceeds 100 entries, the oldest are pruned automatically
5. **Recall** — `clip copy <n>` decodes the entry and pipes it to `pbcopy`
6. **Pause** — `clip pause` creates a flag file; the watcher skips recording while paused

### Auto-Start (LaunchAgent)

Running `clip install` creates a macOS LaunchAgent at:

```
~/Library/LaunchAgents/com.user.clipbuddy.plist
```

This ensures the clipboard watcher starts automatically on every system boot via `launchctl`.

### Uninstall

Running `clip uninstall` reverses the install:

- Stops the running watcher process
- Unloads and removes the LaunchAgent plist
- Removes the `/usr/local/bin/clip` symlink
- Keeps `~/.clip_history` intact (delete manually if needed)

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `clip: command not found` | Re-run `clip install` or add the script location to your `$PATH` |
| Watcher not recording | Run `clip status` — if paused, run `clip resume` |
| Watcher dies on reboot | Run `clip install` to create the LaunchAgent |
| History file too large | `clip clean` wipes it; cap is 100 entries by default |
| `base64: invalid input` | Corrupt entry — remove it with `clip remove <n>` |

---

## Upgrade

```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/clip/clip -o ~/Downloads/clip && chmod +x ~/Downloads/clip && sudo mv ~/Downloads/clip /usr/local/bin/clip
```

Your history file (`~/.clip_history`) is untouched during upgrades.

---

## Platform Support

| Platform | Status |
|---|---|
| macOS Apple Silicon (M1/M2/M3) | ✅ Full support |
| macOS Intel | ✅ Full support |

> **Note:** This utility uses `pbcopy`/`pbpaste` which are macOS-specific. Linux support is not included.

---

## License

GPL-3.0 — see [LICENSE](../../LICENSE) for details.

---

<p align="center">Made with 📋 by <a href="https://github.com/utkarsh-ojha">Utkarsh Ojha</a></p>
