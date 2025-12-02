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
}
