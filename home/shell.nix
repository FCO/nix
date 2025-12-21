_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Welcome banner rendering random Gen1 Pokemon (WezTerm)
      initContent = ''
        # zoxide init and alias cd -> z
        if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init zsh)"
          alias cd='z'
        fi

        # Ensure Raku home bin on PATH (for mi6)
        export PATH="$HOME/.raku/bin:$PATH"

        # Override fastfetch to always pick a random logo via Raku
        if command -v fastfetch >/dev/null 2>&1; then
          fastfetch() {
            command fastfetch --logo "$(raku -e 'say "%*ENV<HOME>/.local/share/pokemon-gen1/".IO.dir.pick.absolute')" --logo-type iterm "$@"
          }
        fi

        if [[ $- == *i* ]]; then
          if command -v wezterm >/dev/null 2>&1; then
            if command -v fastfetch >/dev/null 2>&1; then
              fastfetch || true
            fi
          fi
        fi
      '';


    shellAliases = {
      la = "ls -la";
      ".." = "cd ..";
       "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
       "hm" = "home-manager --flake ~/.config/nix#fernando";
      "vi" = "vim";
      "vim" = "nvim";
      ns = "nix-search";
      zi = "zoxide query -i";
      zri = "zoxide query -i --all";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
    };
  };
}
