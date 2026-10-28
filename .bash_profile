# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";
export PATH="/usr/local/bin:$PATH";
export PATH="/usr/local/sbin:$PATH";
export PATH="$HOME/.local/bin:$PATH";

# Set PATH, MANPATH, etc., for Homebrew (Apple Silicon, Intel macOS, or Linux),
# if it's installed.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
	if [ -x "$brew_bin" ]; then
		eval "$("$brew_bin" shellenv)";
		break;
	fi;
done;
unset brew_bin;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Put mise-managed tools (Elixir/Erlang, etc.) on PATH, per-directory via mise.toml/.tool-versions
if which mise > /dev/null; then eval "$(mise activate bash)"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Load bash-completion: Homebrew's (ensuring existing v1 completions continue to
# work), or else the system's, e.g. the `bash-completion` package on Debian.
if [[ -n "$HOMEBREW_PREFIX" && -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
	export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_PREFIX/etc/bash_completion.d";
	. "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh";
elif [[ -r /usr/share/bash-completion/bash_completion ]]; then
	. /usr/share/bash-completion/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`. System
# bash-completion loads git's completion lazily, so load it up front if needed.
if ! type -t __git_complete > /dev/null && [[ -r /usr/share/bash-completion/completions/git ]]; then
	. /usr/share/bash-completion/completions/git;
fi;
type -t __git_complete > /dev/null && __git_complete g __git_main;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

# Only if this machine has the terminfo entry for it (minimal Linux images may not)
infocmp screen-256color > /dev/null 2>&1 && export TERM=screen-256color;

[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
