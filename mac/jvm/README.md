# ☕ Java Version Manager
### by [Utkarsh Ojha](https://github.com/utkarsh-ojha)

> Install, switch, and manage multiple Java versions on macOS and Linux — with a single command.

---

## Why?

Managing Java versions on macOS is painful. `JAVA_HOME` breaks, Homebrew installs go missing, and switching between Java 8, 17, and 21 for different projects is a mess. This tool fixes all of that.

---

## Features

- **One command to switch** — `jvm use 21` just works
- **Auto-detects** every JVM on your machine (Homebrew, JetBrains, Temurin, Zulu, Corretto, system installs)
- **Writes `JAVA_HOME`** to your shell profile automatically — permanent across terminals
- **Named aliases** — `jvm alias work 17` then `jvm use work`
- **Pin versions** — protect a JDK from accidental removal
- **Per-project files** — `.java-version` support like nvm
- **Doctor command** — diagnoses broken `JAVA_HOME`, bad symlinks, profile conflicts
- **Full history** — timestamped log of every switch
- **Cross-platform** — macOS Apple Silicon, macOS Intel, Linux (apt/dnf/pacman/zypper)
- **No dependencies** — pure bash, nothing to install except the script

---


## Run the below script with sudo, to install this utility

```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/main/mac/jvm -o ~/Downloads/jvm && chmod +x ~/Downloads/jvm && sudo mv ~/Downloads/jvm /usr/local/bin/jvm
```

## Install with, one step at a time

```bash
# Download and install
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/blob/main/mac/jvm -o ~/Downloads/jvm
chmod +x ~/Downloads/jvm
sudo mv ~/Downloads/jvm /usr/local/bin/jvm

# Apple Silicon (M1/M2/M3) — use this path instead:
# sudo mv ~/Downloads/jvm /opt/homebrew/bin/jvm

# Verify
jvm help
```

---

## Quick Start

```bash
# Install Java 21 (recommended — works on all Macs)
jvm install 21       # pick temurin@21 from the menu

# Switch to it
jvm use 21

# Apply in current terminal
source ~/.zshrc

# Verify everything is healthy
jvm doctor
```

From this point on, every new terminal automatically has the correct Java. No `source` needed.

---

## All Commands

| Command | Description |
|---|---|
| `jvm use <version>` | Switch Java version (auto-selects if only one match) |
| `jvm list` | List all installed Java versions |
| `jvm current` | Show active version and `JAVA_HOME` |
| `jvm search [version]` | Search Homebrew / pkg manager for JDKs |
| `jvm install <version>` | Install a JDK without switching |
| `jvm remove <version>` | Uninstall a version (respects pins) |
| `jvm clean` | Remove everything except the active JDK |
| `jvm pin <version>` | Protect a version from removal |
| `jvm unpin <version>` | Remove pin protection |
| `jvm pins` | List pinned versions |
| `jvm doctor` | Diagnose `JAVA_HOME`, PATH, and symlink issues |
| `jvm env [version]` | Print export commands for CI/CD |
| `jvm history` | Show timestamped switch log |
| `jvm alias <name> <ver>` | Create a named shortcut |
| `jvm aliases` | List all aliases |
| `jvm project [version]` | Set/read per-project `.java-version` file |
| `jvm update` | Self-update to the latest version |
| `jvm help [command]` | Full help, or deep-dive a command |

---

## Examples

```bash
# Switch versions
jvm use 17
jvm use 21

# Use aliases
jvm alias work 21
jvm alias legacy 8
jvm use work

# Per-project Java version
cd ~/my-project
jvm project 17        # writes .java-version
jvm use               # auto-reads .java-version next time

# CI/CD pipelines
eval $(jvm env 17)    # apply Java 17 inline in any script

# Pin a version so clean/remove can't touch it
jvm pin 17
jvm clean             # removes everything except active + pinned

# Diagnose issues
jvm doctor
```

---

## How Version Switching Works

`jvm use` writes a `JAVA_HOME` export block into your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# >>> jvm-manager (managed — do not edit manually)
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"
# <<< jvm-manager
```

Every new terminal picks this up automatically. For the **current terminal**, run `source ~/.zshrc` once after switching.

---

## Platform Support

| Platform | Package Manager | Status |
|---|---|---|
| macOS Apple Silicon (M1/M2/M3) | Homebrew | ✅ Full support |
| macOS Intel | Homebrew | ✅ Full support |
| Ubuntu / Debian | apt | ✅ Full support |
| Fedora / RHEL | dnf / yum | ✅ Full support |
| Arch Linux | pacman | ✅ Full support |
| openSUSE | zypper | ✅ Full support |

---

## First-Time Setup (Full Guide)

**1. Download and install the script**
```bash
curl -fsSL https://raw.githubusercontent.com/utkarsh-ojha/utility/blob/main/mac/jvm -o ~/Downloads/jvm
chmod +x ~/Downloads/jvm
sudo mv ~/Downloads/jvm /usr/local/bin/jvm
```

**2. Install Homebrew (macOS, if not already installed)**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**3. Install your first Java version**
```bash
jvm install 21
# Select temurin@21 from the menu
```

**4. Switch to it and apply**
```bash
jvm use 21
source ~/.zshrc
```

**5. Verify**
```bash
java -version
echo $JAVA_HOME
jvm doctor
```

---

## License

MIT — free to use, modify, and distribute.

---

<p align="center">Made with ☕ by <a href="https://github.com/utkarshojha">Utkarsh Ojha</a></p>
