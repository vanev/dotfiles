# Evan’s dotfiles

## Setup on a new machine

Clone the repo (I keep it in `~/Projects/dotfiles`) and run the bootstrap script, which copies the files into your home folder:

```bash
git clone https://github.com/vanev/dotfiles.git && cd dotfiles && source bootstrap.sh
```

Then, after installing [Homebrew](https://brew.sh/):

```bash
./brew.sh   # install formulae/casks these dotfiles depend on
./.macos    # set sensible macOS defaults (optional, requires a restart to fully apply)
```

To pull down changes later, `cd` back into the repo and re-run `source bootstrap.sh` (or `set -- -f; source bootstrap.sh` to skip the overwrite confirmation prompt).

### Local overrides

- `~/.path`, if present, is sourced first and can extend `$PATH` before anything else (including [ls-flavor detection](.aliases#L21-L28)) runs.
- `~/.extra`, if present, is sourced last. I use mine for git credentials that shouldn't be committed:

  ```bash
  GIT_AUTHOR_NAME="Evan Siegel"
  GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
  git config --global user.name "$GIT_AUTHOR_NAME"
  GIT_AUTHOR_EMAIL="siegel.evan@gmail.com"
  GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  git config --global user.email "$GIT_AUTHOR_EMAIL"
  ```

Neither file is tracked by this repo.

### Linux servers (homelab, Proxmox, VMs, etc.)

The shell config also works on Linux. It skips Homebrew when it isn’t installed and uses the system’s bash-completion instead. It shows `user@host` in the prompt over SSH, and it doesn’t shadow iproute2’s `ip` (the public-IP alias is `publicip`). `bootstrap.sh` needs `git` and `rsync`, and it overwrites `~/.bashrc` and `~/.bash_profile`. Use `source bootstrap.sh -f` for unattended setup.

Worth installing (Debian/Proxmox package names):

```bash
apt install git rsync bash-completion tmux ncurses-term dnsutils
```

Neovim needs 0.11 or newer, which is usually newer than the distro package, so install it from the [GitHub releases](https://github.com/neovim/neovim/releases). On first launch the full config installs LSP servers, formatters and treesitter parsers, which needs node, python, a C compiler, `make` and the `tree-sitter` CLI. On machines where that’s overkill, add this to `~/.extra` to skip those plugins:

```bash
export DOTFILES_MINIMAL=1
```

If `en_US.UTF-8` hasn’t been generated (`dpkg-reconfigure locales`), the shell falls back to `C.UTF-8`.

## Feedback

Suggestions/improvements [welcome](https://github.com/vanev/dotfiles/issues)!

## Author

[Evan Siegel](http://evan.siegel.hiphop/)

Forked from [Mathias Bynens](https://mathiasbynens.be/)’s [dotfiles](https://github.com/mathiasbynens/dotfiles).
