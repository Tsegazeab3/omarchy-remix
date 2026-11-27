# omarchy-remix

**An opinionated take on an opinionated OS.**

[Omarchy](https://omarchy.org) is DHH's Arch + Hyprland setup with strong opinions baked in.
This repo holds my opinions on top of those: what I changed after a few months of daily use as an
engineering student who lives in the terminal, works on two monitors and a tablet, and
types in both English and Amharic.

Everything here sits in Omarchy's user layer (`~/.config`, `~/.local/bin`, user systemd units).
Nothing touches `/usr/share/omarchy`, so `omarchy update` keeps working.

---

## The opinions

### 1. Vim keys everywhere, and the modifiers live where my fingers are

| Physical key | Does | Why |
|---|---|---|
| Caps Lock | **Ctrl** | Pinky-friendly Ctrl for tmux, Vim, shells |
| Left Ctrl | **Esc** | Esc without leaving the home row |
| Esc | Caps Lock | Something has to be Caps Lock |
| Win ↔ Alt | **swapped** | Super sits next to the spacebar, under the thumb |
| Both Shifts | Caps Lock toggle | Rarely needed, still reachable |

Custom XKB option in [`config/xkb`](config/xkb), wired up in [`config/hypr/input.lua`](config/hypr/input.lua).

**Window management goes Vim-style** ([`bindings.lua`](config/hypr/bindings.lua)):

| Keys | Action |
|---|---|
| `Super + H/J/K/L` | Focus left / down / up / right |
| `Super + Shift + H/J/K/L` | Swap window in that direction |
| `Super + Tab` / `Super + Shift + Tab` | Jump to next / previous **monitor** (not workspace) |
| `Super + Grave` (the `` ` `` key) | Fuzzy window switcher across all workspaces |
| `Super + ,` | Quake-style drop-down console |
| `Super + Shift + S` | Throw the window into the scratchpad |
| Tap the physical Win key | Open the Omarchy menu |
| `Super/Alt + Space` | Switch keyboard layout (English ⇄ Amharic) |

The defaults that used to sit on J/K/L move to the physical Win key (Alt after the swap):
`Alt + J` toggle split, `Alt + K` keybindings cheat sheet, `Alt + L` workspace layout.

**tmux follows the same idea** ([`tmux.conf`](config/tmux/tmux.conf)): `C-b` prefix with Omarchy's
`C-Space` kept as a second prefix, `Alt + h/j/k/l` pane movement with no prefix, `v`/`s` splits,
1M lines of scrollback, mouse, OSC 52 clipboard, extended keys for kitty. It reloads itself
whenever the Omarchy theme changes (a `theme-set` hook).

### 2. The keyboard should also be the mouse

`Alt + P` / `Alt + O` run [`hypr-kbptr`](bin/hypr-kbptr), a window-aware wrapper around
[wl-kbptr](https://github.com/moverest/wl-kbptr). Click picks a window first, then a point in it,
so you can hit any button with a few keystrokes. Drag mode picks a source point, a destination
window (on another monitor if need be), and a drop point, then performs a real drag-and-drop.

### 3. AI lives one keystroke away, and the fast stuff runs locally

| Keys | Tool |
|---|---|
| `Super + A` | [`ai-scratchpad`](bin/ai-scratchpad): floating chat with a local Qwen 2.5 1.5B via Ollama |
| `Super + Q` | [`agy-quick-order`](bin/agy-quick-order): type an order, close the window, get a notification when the agent finishes it in the background |
| `Super + Shift + A` | [`super-fast-order`](bin/super-fast-order): local Qwen rewrites and routes the request; calendar jobs go to Gemini Flash with tool calls that write Obsidian notes |
| (shell) | [`git-ai-commit`](bin/git-ai-commit): conventional commit message from the staged diff, local model, edit/regenerate loop |

The Ollama model is pre-warmed at login so the first answer is instant. Scratchpads float
centered at a fixed size (window rules in [`hyprland.lua`](config/hypr/hyprland.lua)).

### 4. The tablet is a peripheral

A Samsung tablet over ADB (Tailscale or LAN) works as:

- **Second screen**: [`tab-display`](bin/tab-display) mirrors it with keyboard, mouse and clipboard
- **Keyboard target**: [`tab-keyboard`](bin/tab-keyboard), then `Alt + Shift + T` ([`tab-toggle`](bin/tab-toggle)) flips your physical keyboard between the PC and the tablet
- **Wireless microphone**: [`phone-mic`](bin/phone-mic) creates a PipeWire virtual mic fed by the tablet's mic, keeps your headphones as output, and cleans up on exit
- [`tab-connect`](bin/tab-connect) handles pairing and remembers the target

### 5. A laptop that is sometimes a desktop

- **Monitors** ([`monitors.lua`](config/hypr/monitors.lua)): 1.25× on the laptop panel, externals pinned to 1080p@60 on the right (a cheap HDMI adapter flickers at 1440p).
- **Lid close is a menu toggle**: "Lid Close Does Nothing" / "Lid Close Suspends" in the Omarchy menu ([`lid-close-toggle`](bin/lid-close-toggle), a `systemd-inhibit` user service). Close the lid with an external monitor attached and keep working.
- [`screen-watch`](bin/screen-watch) logs and notifies when an external display drops, using Hyprland events, kernel i915 errors and raw connector status. Built to diagnose a flaky dock.
- **Dual boot**: NTFS partitions auto-mount at login; [`mount-storage`](bin/mount-storage) handles the "dirty from Windows Fast Startup" read-only case.

### 6. Files go where I already am

- [`word-online`](bin/word-online): open any local `.docx` in Word for the web. Uploads to OneDrive over Microsoft Graph (one GET + one PUT with curl; rclone only refreshes the token), and never overwrites a copy that was edited online. `word-online --pullfile FILE` brings online edits back home; `word-online --pullfolder .` does it for every Office file under a folder. The old version is backed up first, and if both sides changed you get both files instead of losing one. Lets you keep Office-only coursework on Linux.
- Google Drive mounted at `~/GoogleDrive` with rclone ([service](config/systemd/user/rclone-gdrive.service)).
- [`omarchy-menu-dynamic-search`](bin/omarchy-menu-dynamic-search) and the forked menu plugin [`t.menu`](config/omarchy/plugins/t.menu): typing in the Omarchy menu also searches your files (`fd`) and offers web suggestions.

### 7. Guard rails for focus

- [`download-watch`](bin/download-watch) + [`long-video-check`](bin/long-video-check): any downloaded video longer than 10 minutes is deleted automatically. Short clips survive; procrastination fodder doesn't.
- Pomodoro set to 50/10 in a fork of [Clockwork](https://github.com/pjgeutjens/omarchy-clockwork) ([`t.clockwork`](config/omarchy/plugins/t.clockwork)) that also writes timer state to a file so other tools can react to it.
- [`mindgate.lua`](config/hypr/mindgate.lua): Hyprland side of a morning-journal gate. While the gate window exists, a submap with no binds swallows every shortcut, and a 2-second timer makes sure keys can never stay locked. The gate app itself is a separate project.

### 8. Smaller things

- **Bar** ([`shell.json`](config/omarchy/shell.json)): glassy background, media controls, world clock (Dubai, Addis Ababa, Florence, Washington DC), notification center, Tailscale, battery percentage.
- **Input methods**: fcitx5 + m17n for Ethiopic, Super+I left to Omarchy.
- `Alt + T` toggles Materialgram (Telegram) as a centered floating window; `Super/Alt + D` toggles on-screen drawing (wayscriber).
- Theme hooks keep tmux and Antigravity in sync with light/dark mode.
- Starship shows Vim mode in the prompt; kitty at 9 pt.

---

## Install

On a fresh Omarchy install:

```bash
git clone https://github.com/Tsegazeab3/omarchy-remix
cd omarchy-remix
./install.sh --dry-run     # see what would change
./install.sh               # configs + scripts (backs up anything it replaces)
./install.sh --packages    # ...and the extra packages
```

Before you do, look at the things that are mine and not yours:

- partition UUIDs in `config/hypr/autostart.lua` and `bin/mount-storage`
- monitor descriptions in `config/hypr/monitors.lua`
- the rclone remote names (`gdrive`, `onedrive`) in the Drive service and `word-online`
- `OPENROUTER_API_KEY` must be set in your environment for `super-fast-order`
- `OBSIDIAN_VAULT` (default `~/Documents/Obsidian Vault`) for the AI scratchpads

Take the parts you like. The file layout mirrors `~/.config` and `~/.local/bin`, so cherry-picking
one file is just a copy.

## Layout

```
config/          mirrors ~/.config
  hypr/          bindings, input, monitors, window rules, autostart, mindgate lock
  xkb/           custom Caps/Ctrl/Esc option
  tmux/ kitty/ fcitx5/ starship.toml
  omarchy/       bar (shell.json), menu extensions, theme hooks, plugins
  systemd/user/  download-watch, lid-ignore, mount-storage, rclone-gdrive, wayscriber
bin/             mirrors ~/.local/bin
packages.txt     official-repo packages added on top of Omarchy
packages-aur.txt AUR packages
install.sh       put it all on a machine
sync.sh          pull live changes back into the repo, commit, push
```

## Staying in sync

This repo follows my machine. A user timer (`omarchy-remix-sync.timer`, every 15 minutes)
runs [`sync.sh`](sync.sh), which copies any tracked file that changed in `~/.config` or
`~/.local/bin` back here, strips home paths, monitor serials and inline API keys, refuses to
commit anything that still looks like a credential, then commits and pushes.

## Credits

- [Omarchy](https://github.com/basecamp/omarchy). `t.menu` is a fork of its menu plugin.
- [Clockwork](https://github.com/pjgeutjens/omarchy-clockwork) by Pieter Geutjens (MIT). License kept in `t.clockwork/`.
- [wl-kbptr](https://github.com/moverest/wl-kbptr), [scrcpy](https://github.com/Genymobile/scrcpy), [rclone](https://rclone.org), [Ollama](https://ollama.com).

Take whatever you want.
