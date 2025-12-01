{ primaryUser, ... }:
{
  programs.git = {
    enable = true;
    userName = "Fernando Correa de Oliveira";
    userEmail = "fco@cpan.org";

    lfs.enable = true;

    ignores = [ "**/.DS_STORE" ];

    extraConfig = {
      github = {
        user = primaryUser;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
