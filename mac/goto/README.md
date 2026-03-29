# 📂 Directory Bookmark Engine
### by [Utkarsh Ojha](https://github.com/utkarsh-ojha)

> Persistent directory bookmarks for macOS & Linux — bookmark it, name it, jump to it, with a single command.

---

## Why?

You `cd` into the same deep directories every day. You type long paths over and over. Tab-completion only gets you so far. This tool lets you bookmark any directory with a short alias and jump back to it instantly — with sub-path support.

---

## Features

- **Persistent bookmarks** — saved to `~/.goto_registry`, survives reboots
- **Sub-pathing** — `goto myproj/src/components` jumps to bookmark + sub-path
- **Auto-naming** — `goto add` with no argument uses the current folder name
- **Dead link detection** — detects deleted paths and offers to clean them up
- **Shell function wrapper** — actually changes your terminal's directory (not a sub-shell)
- **Cross-platform** — works on macOS (BSD) and Linux (GNU)
- **ANSI-colored output** — clean, readable terminal UI with 🚀 jump feedback
- **No dependencies** — pure bash, nothing to install except the script

---

## Run the below script with sudo, to install this utility

```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/goto/goto -o ~/Downloads/goto && chmod +x ~/Downloads/goto && sudo mv ~/Downloads/goto /usr/local/bin/goto && goto install
```

## Install with, one step at a time

```bash
# Download and install
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/goto/goto -o ~/Downloads/goto
chmod +x ~/Downloads/goto
sudo mv ~/Downloads/goto /usr/local/bin/goto

# Apple Silicon (M1/M2/M3) — use this path instead:
# sudo mv ~/Downloads/goto /opt/homebrew/bin/goto

# Run install to inject shell function
goto install

# Restart terminal or source your shell config
source ~/.zshrc    # or source ~/.bashrc

# Verify
goto help
```

---

## Quick Start

```bash
# Install (one time)
goto install
source ~/.zshrc

# Bookmark your project
cd ~/projects/my-awesome-app
goto add myapp

# Jump back from anywhere
goto myapp

# Jump into a sub-directory
goto myapp/src/components
```

---

## All Commands

| Command | Description |
|---|---|
| `goto add [name]` | Bookmark current directory (default: folder name) |
| `goto <name>` | Jump to bookmarked directory |
| `goto <name>/sub/path` | Jump to bookmark + sub-path |
| `goto list` | Show all bookmarks with paths |
| `goto remove <name>` | Delete a specific bookmark |
| `goto clean` | Wipe all bookmarks (with y/n confirmation) |
| `goto install` | Install goto + inject shell function |
| `goto uninstall` | Remove symlink, shell function, and registry |
| `goto help` | Full help screen |

---

## Examples

```bash
# Bookmark directories
cd ~/projects/frontend
goto add frontend           # bookmark as 'frontend'

cd ~/projects/backend/api
goto add                    # auto-names as 'api' (folder name)

# Jump to bookmarks
goto frontend               # 🚀 jumps to ~/projects/frontend
goto api                    # 🚀 jumps to ~/projects/backend/api

# Sub-pathing
goto frontend/src           # jumps to ~/projects/frontend/src
goto api/routes/v1          # jumps to ~/projects/backend/api/routes/v1

# Manage bookmarks
goto list                   # see all bookmarks
goto remove frontend        # delete a bookmark
goto clean                  # wipe everything

# Install / uninstall
goto install                # one-time setup
goto uninstall              # undo everything
```

---

## How It Works

1. **Registry** — Bookmarks are stored in `~/.goto_registry` as `alias|path` pairs
2. **Shell Function** — `goto install` injects a function wrapper into `.zshrc` or `.bashrc`
3. **The cd Trick** — The script outputs a special `__goto_cd__:/path` string; the shell function captures it and runs `cd /path` in the parent shell
4. **Sub-pathing** — `goto myproj/src` splits into alias `myproj` + sub-path `/src`, then joins them
5. **Dead Links** — If a bookmarked path no longer exists, goto detects it and offers to remove the dead bookmark

### Why a Shell Function?

A standalone script runs in a sub-shell — it **cannot** change the directory of the terminal that called it. The `goto install` command solves this by injecting a thin shell function into your `.zshrc`/`.bashrc` that:

1. Calls the `goto` script
2. Captures the output
3. If the output contains a cd directive, runs `cd` in your current shell
4. Otherwise, prints the output normally

### Uninstall

Running `goto uninstall` reverses everything:

- Removes the shell function from `.zshrc`/`.bashrc`
- Removes the `/usr/local/bin/goto` symlink
- Deletes the `~/.goto_registry` file

---

## Platform Support

| Platform | Status |
|---|---|
| macOS Apple Silicon (M1/M2/M3) | ✅ Full support |
| macOS Intel | ✅ Full support |
| Linux (Ubuntu, Fedora, Arch, openSUSE) | ✅ Full support |

---

## License

GPL-3.0 — see [LICENSE](../../LICENSE) for details.

---

<p align="center">Made with 📂 by <a href="https://github.com/utkarsh-ojha">Utkarsh Ojha</a></p>
