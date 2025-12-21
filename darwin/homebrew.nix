{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "aerospace"
      "cleanshot"
      "hiddenbar"
       "raycast"
       "betterdisplay"
 
        # dev
      "wezterm"

       # messaging
       "signal"

       # AI
       "chatgpt"


      # other
      "1password"
      "zen"
      "setapp"

      "orbstack"

      "utm"

      "nordvpn"

    ];
    brews = [
      "docker"
      "colima"
      "opencode"
      "rakudo"
      "bat"
      "fzf"
    ];
    taps = [
      "nikitabobko/tap"
      "1password/tap"
      "mas-cli/tap"
    ];

    masApps = {
      # Amphetamine (App Store)
      "Amphetamine" = 937984704;
    };
  };
}
