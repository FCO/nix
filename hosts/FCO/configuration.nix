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

  # Homepage Dashboard: LaunchDaemon at boot
  launchd.daemons.homepage-dashboard = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.homepage-dashboard}/bin/homepage" ];
      EnvironmentVariables = {
        PORT = "3000";
        HOMEPAGE_CONFIG_DIR = "/var/lib/homepage-dashboard";
        NIXPKGS_HOMEPAGE_CACHE_DIR = "/var/cache/homepage-dashboard";
      };
      WorkingDirectory = "/var/lib/homepage-dashboard";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/homepage-dashboard.log";
      StandardErrorPath = "/var/log/homepage-dashboard.err";
    };
  };

  # Ensure homepage config/cache directories exist
  system.activationScripts.homepage-dashboard.text = ''
    mkdir -p /var/lib/homepage-dashboard
    mkdir -p /var/cache/homepage-dashboard
  '';

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

  # Enable Screen Sharing, Remote Management (ARD) and SMB service
   system.activationScripts.enableSharing.text = ''
     set -e
 
     echo "[activation] Enabling Screen Sharing"
     /bin/launchctl enable system/com.apple.screensharing || true
     /bin/launchctl kickstart -k system/com.apple.screensharing || true
 
     echo "[activation] Enabling Remote Management (ARD)"
     KICK="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
     if [ -x "$KICK" ]; then
       "$KICK" -activate -configure -access -on -users "${primaryUser}" -privs -all -restart -agent || true
     else
       echo "[activation] ARD kickstart not found"
     fi
 
     echo "[activation] Enabling SMB (file sharing) daemon"
     /bin/launchctl enable system/com.apple.smbd || true
     /bin/launchctl kickstart -k system/com.apple.smbd || true
 
     echo "[activation] Configuring SMB share 'Public'"
     if /usr/sbin/sharing -l | /usr/bin/grep -q "^Public"; then
       echo "[activation] SMB share 'Public' already exists"
     else
       /usr/sbin/sharing -a "/Users/${primaryUser}/Public" -S "Public" -s || true
     fi
   '';


 }
