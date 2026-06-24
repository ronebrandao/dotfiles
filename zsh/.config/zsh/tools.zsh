# Tool integrations for modern CLI utilities installed by install.sh.
# Sourced from ~/.zshrc. Each block is guarded so a missing binary is harmless.

# zoxide -- smarter cd (use `z <dir>` to jump, `zi` for interactive).
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# eza -- modern ls replacement.
if command -v eza >/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --git --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
fi

# bat -- nicer pager/theme. No `cat` override, to keep scripts safe.
command -v bat >/dev/null && export BAT_THEME="ansi"
