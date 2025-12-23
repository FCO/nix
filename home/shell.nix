{ pkgs, lib, config, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Welcome banner with Pokemon across terminals
      initContent = ''
        # zoxide init and alias cd -> z
        if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init zsh)"
          alias cd='z'
        fi

        # Ensure Raku home bin on PATH (for mi6)
        export PATH="$HOME/.raku/bin:$PATH"

        # Interactive shells: show a random Pokemon, then system info
        if [[ $- == *i* ]]; then
          base="${config.home.homeDirectory}/.local/share/pokemon-gen1"
          if command -v pokemon-colorscripts >/dev/null 2>&1; then
            pokemon-colorscripts -r || true
            if command -v fastfetch >/dev/null 2>&1; then
              command fastfetch --logo none || true
            elif command -v neofetch >/dev/null 2>&1; then
              neofetch || true
            fi
          elif [ -d "$base" ] && command -v raku >/dev/null 2>&1; then
            logo="$(raku -e "say '$base'.IO.dir.pick.absolute")"
            if command -v fastfetch >/dev/null 2>&1; then
              command fastfetch --logo "$logo" --logo-type iterm || true
            elif command -v neofetch >/dev/null 2>&1; then
              neofetch || true
            fi
          else
            if command -v fastfetch >/dev/null 2>&1; then
              fastfetch || true
            elif command -v neofetch >/dev/null 2>&1; then
              neofetch || true
            fi
          fi
        fi
      '';


    shellAliases = lib.mkMerge [
      {
        la = "ls -la";
        ".." = "cd ..";
        "hm" = "home-manager --flake ~/.config/nix#fernando";
        "vi" = "vim";
        "vim" = "nvim";
        ns = "nix-search";
        zi = "zoxide query -i";
        zri = "zoxide query -i --all";
      }
      (lib.mkIf pkgs.stdenv.isDarwin {
        "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
      })
    ];
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
