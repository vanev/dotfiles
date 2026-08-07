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

### Neovim

[`.config/nvim/init.lua`](.config/nvim/init.lua) is a single-file Neovim config using [lazy.nvim](https://github.com/folke/lazy.nvim), with LSP (via Mason), Telescope, Treesitter, completion, and git integration. See the comment block at the top for a keybinding quick reference. `EDITOR`/`VISUAL` are set to `nvim` in `.exports`, and `vim`/`vimdiff` are aliased to it in `.aliases`.

### tmux

[`.tmux.conf`](.tmux.conf) configures tmux, including pane navigation that integrates with Neovim splits via [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator), so `Ctrl+h/j/k/l` moves seamlessly between tmux panes and vim splits.

## Feedback

Suggestions/improvements [welcome](https://github.com/vanev/dotfiles/issues)!

## Author

[Evan Siegel](http://evansiegel.name/)

Forked from [Mathias Bynens](https://mathiasbynens.be/)’s [dotfiles](https://github.com/mathiasbynens/dotfiles).
