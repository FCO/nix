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

      # other
      "1password"
      "zen"

      "orbstack"

    ];
    brews = [
      "docker"
      "colima"
      "opencode"
      "rakudo"
    ];
    taps = [
      "nikitabobko/tap"
      "1password/tap"
    ];
  };
}
