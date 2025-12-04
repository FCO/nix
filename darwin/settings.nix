{ self, ... }:
{
  # touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # system defaults and preferences
  system = {
    stateVersion = 6;
    configurationRevision = self.rev or self.dirtyRev or null;

    startup.chime = false;

    activationScripts.ensureScreenshotsDir.text = ''
      mkdir -p /Users/fernando/Desktop/Screenshots
    '';

    defaults = {
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };
      
      finder = {
        AppleShowAllFiles = true; # hidden files
        AppleShowAllExtensions = true; # file extensions
        _FXShowPosixPathInTitle = true; # title bar full path
        ShowPathbar = true; # breadcrumb nav at bottom
        ShowStatusBar = true; # file count & disk space
        ShowHardDrivesOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
      };
      
      dock = {
        autohide = true;
        orientation = "right";
        magnification = true;
        largesize = 55;
      };

      screencapture = {
        location = "/Users/fernando/Desktop/Screenshots";
        type = "png";
        disable-shadow = false;
      };

      NSGlobalDomain = {
        # Dark Mode
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;

        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
      };
    };
  };
}
