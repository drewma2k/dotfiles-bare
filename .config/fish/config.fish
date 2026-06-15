if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_hybrid_key_bindings
    set PATH $PATH /opt/homebrew/bin ~/.local/bin
    set SHELL /opt/homebrew/bin/fish
    set fish_greeting

    # Ghostty isn't in fish 3.7.1's cursor-capable terminal allowlist, so force it
    set fish_vi_force_cursor 1
    set fish_cursor_default block blink
    set fish_cursor_insert block blink
    fish_vi_cursor
    function fish_mode_prompt; end

    # editing config files
    abbr --add aliases 'nvim ~/.config/oh-my-zsh-custom/aliases.zsh'
    abbr --add zebrc 'nvim ~/.zshrc'
    abbr --add nvrc 'nvim ~/.config/nvim/init.lua'
    abbr --add src 'cd ~/src'
    abbr --add reload 'source ~/.config/fish/config.fish'

    # formatted date
    abbr --add ddef 'date +%Y-%m-%d'

    # eza
    abbr --add eza 'eza --group-directories-first'
    abbr --add l 'eza -l --no-filesize --no-user --no-time --no-permissions --git --git-repos'
    abbr --add ls 'eza -1 --no-filesize'
    abbr --add la 'eza -l -a --no-filesize --no-user --no-time --no-permissions'
    abbr --add ll 'eza -l'

    # nvim
    abbr --add nv 'nvim'

    # general
    abbr --add cl 'clear'
    abbr --add ict 'kitten icat'
    abbr --add db '/opt/homebrew/Cellar/databricks/0.226.0/bin/databricks'
    abbr --add lst 'tree --dirsfirst -a -L 1'

    # git: zsh-muscle-memory alias for plugin's gpu
    abbr --add gpsup 'git push origin (__git.current_branch) --set-upstream'

    # git worktree helpers
    function gwtx --description 'Create new worktree and branch'
        set -l git_common_dir (git rev-parse --git-common-dir)
        set -l project_name (basename (cd "$git_common_dir" && pwd -P) | sed 's#/\.git$##')
        set -l sanitized_branch (string replace -a '/' '.' $argv[1])
        git worktree add "../$project_name.$sanitized_branch" $argv[1] \
            && cd "../$project_name.$sanitized_branch" \
            && git submodule update --init --recursive
    end

    function gwta --description 'Create worktree for existing branch'
        set -l git_common_dir (git rev-parse --git-common-dir)
        set -l project_name (basename (cd "$git_common_dir" && pwd -P) | sed 's#/\.git$##')
        set -l sanitized_branch (string replace -a '/' '.' $argv[1])
        git worktree add "../$project_name.$sanitized_branch" $argv[1] \
            && cd "../$project_name.$sanitized_branch" \
            && git submodule update --init --recursive
    end

    # completion for gwtx - show existing branches
    complete -c gwtx -f -a "(git branch -a --format='%(refname:short)' | sed 's#^remotes/origin/##' | sort -u)"

    # dotfiles bare repo: git-dir in ~/.dotfiles, work-tree in $HOME
    function config --description 'Manage $HOME dotfiles via bare repo'
        git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
    end

	zoxide init fish | source
end
