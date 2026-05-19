Git-based local user Claude configuration file set.

To enable auto-sync:

1. Go to $HOME directory
2. Clone this repository into `.claude`:

        git clone git@github.com:artazar/claude-local.git .claude

    In case `claude` has already been initialized on the machine, it will be required to merge the files and solve conflicts manually. This is mostly intended for a fresh box setup for managed agents boxes.

3. Open either `~/.bashrc` on a Linux box or `~/.zshrc` on a MacOS machine. Add these lines:

        # Claude local configuration auto-sync:
        [ -f "$HOME/.claude/git-sync.sh" ] && source "$HOME/.claude/git-sync.sh"
