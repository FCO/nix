_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Welcome banner with pokemonsay on interactive shells
    initExtra = ''
      if [[ $- == *i* ]]; then
        if command -v pokemonsay >/dev/null 2>&1; then
          pokemonsay "Seja bem-vindo $USER"
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
