_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Welcome banner rendering random Gen1 Pokemon (WezTerm)
    initContent = ''
      if [[ $- == *i* ]]; then
        if command -v wezterm >/dev/null 2>&1; then
          if [ -x "$HOME/.nix-profile/bin/pokewelcome" ]; then
            "$HOME/.nix-profile/bin/pokewelcome" || true
          fi
        fi
      fi
    '';

    shellAliases = {
      la = "ls -la";
      ".." = "cd ..";
      "nix-switch" = "sudo darwin-rebuild switch --flake ~/.config/nix";
      "vi" = "vim";
      "vim" = "nvim";
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
