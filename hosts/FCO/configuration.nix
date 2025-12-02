{
  pkgs,
  primaryUser,
  ...
}:
{
  networking.hostName = "FCO";

  # host-specific homebrew casks
  homebrew.casks = [
    # "slack"
  ];

  # host-specific home-manager configuration
  home-manager.users = {
    ${primaryUser} = {
      home.packages = with pkgs; [
        graphite-cli
      ];

      programs = {
        zsh = {
          initContent = ''
            # Source shell functions
            source ${./shell-functions.sh}
          '';
        };
      };
    };
  };

  # LaunchAgent to run updates weekly
  launchd.user.agents.update-all = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/zsh"
        "-lc"
        "update-all"
      ];
      StartCalendarInterval = [
        { Weekday = 1; Hour = 3; Minute = 0; }
      ];
      StandardOutPath = "/Users/${primaryUser}/Library/Logs/update-all.log";
      StandardErrorPath = "/Users/${primaryUser}/Library/Logs/update-all.err";
      RunAtLoad = false;
    };
  };

  # On switch: For newly-created family users (no home yet), require password change at next login
  system.activationScripts.requirePasswordChangeForNewUsers.text = ''
    set -e

    for u in fernanda sophia aline; do
      if id -u "$u" >/dev/null 2>&1; then
        # Consider "new" if no home directory exists yet
        if [ ! -d "/Users/$u" ]; then
          echo "[activation] Marking $u to change password at next login"
          /usr/bin/pwpolicy -u "$u" -setpolicy "newPasswordRequired=1" || true
        else
          echo "[activation] Skipping $u (home exists)"
        fi
      fi
    done
  '';

}
