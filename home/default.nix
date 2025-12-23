{ pkgs, lib, config, primaryUser, nvimRepo, ... }:
let
  githubUser = "FCO";
  repos = [ "Red" "Cromponent" "Crolite" "RedFactory" "ASTQuery" ];
  reposList = builtins.concatStringsSep " " repos;
in
{
  imports = [
    ./packages.nix
    ./git.nix
    ./shell.nix
  ] ++ lib.optional (builtins.pathExists ./wayland.nix) ./wayland.nix;

  home = {
    username = primaryUser;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${primaryUser}" else "/home/${primaryUser}";
    stateVersion = "25.05";
    sessionVariables = {
      # shared environment variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Ensure ~/Projects exists and clone/update selected GitHub repos
    activation.ensureProjects = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      set -euo pipefail
      PROJECTS_DIR="${config.home.homeDirectory}/Projects"
      mkdir -p "$PROJECTS_DIR"

       GIT_BIN="${pkgs.git}/bin/git"
       if [ "$(uname)" = "Darwin" ]; then
         export PATH="/usr/bin:/opt/homebrew/bin:/nix/var/nix/profiles/default/bin:$PATH"
       else
         export PATH="/usr/bin:/nix/var/nix/profiles/default/bin:$PATH"
       fi
       if ! command -v ssh >/dev/null 2>&1; then
         echo "[ensureProjects] ssh not found in PATH; skipping repo updates"
         exit 0
       fi


      echo "[ensureProjects] Ensuring repos in $PROJECTS_DIR"
      for repo in ${reposList}; do
        REPO_DIR="$PROJECTS_DIR/$repo"
        REMOTE_SSH="git@github.com:${githubUser}/$repo.git"
        REMOTE_HTTPS="https://github.com/${githubUser}/$repo.git"
        if [ -d "$REPO_DIR/.git" ]; then
          echo "[ensureProjects] Repo $repo already exists (no action)"
        elif [ -d "$REPO_DIR" ]; then
          echo "[ensureProjects] Found directory without git: $repo (skipping)"
        else
          echo "[ensureProjects] Cloning $repo (SSH, fallback to HTTPS)"
          if ! "$GIT_BIN" clone "$REMOTE_SSH" "$REPO_DIR"; then
            echo "[ensureProjects] SSH failed for $repo, trying HTTPS"
            "$GIT_BIN" clone "$REMOTE_HTTPS" "$REPO_DIR" || true
          fi
        fi
      done
    '';


    # Install Raku App::Mi6 via zef
    activation.installRakuMi6 = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      set -euo pipefail
      ZEF_BIN="${pkgs.zef}/bin/zef"
      RAKU_BIN="${pkgs.rakudo}/bin/raku"
      export HOME="${config.home.homeDirectory}"
      if "$RAKU_BIN" -e 'use App::Mi6'; then
        echo "[raku] App::Mi6 already available"
      else
        echo "[raku] Installing App::Mi6 + Fez via zef (home repo)"
        "$ZEF_BIN" install --install-to=home --/test --force-install Fez App::Mi6 || true
        if "$RAKU_BIN" -e 'use App::Mi6'; then
          echo "[raku] App::Mi6 installed successfully in ~/.raku"
        else
          echo "[raku] Failed to load App::Mi6 after install"
        fi
      fi
    '';

    # create .hushlogin file to suppress login messages
    file.".hushlogin".text = "";
    file.".config/nvim".source = nvimRepo;
    # Aerospace window manager configuration (embed inline to avoid git source issues)
    file.".aerospace.toml" = lib.mkIf pkgs.stdenv.isDarwin {
      text = ''
# Aerospace config generated via Home Manager
# Reference: https://nikitabobko.github.io/AeroSpace/

# Basic settings
start-at-login = true

# macOS integration
[gaps]
inner = { horizontal = 6, vertical = 6 }
outer = { horizontal = 12, vertical = 12 }

[mode.main.binding]
# Focus
alt-h = "focus left"
alt-j = "focus down"
alt-k = "focus up"
alt-l = "focus right"

# Move window
alt-shift-h = "move left"
alt-shift-j = "move down"
alt-shift-k = "move up"
alt-shift-l = "move right"

# Resize (width/height)
alt-ctrl-h = "resize width -5"
alt-ctrl-j = "resize height +5"
alt-ctrl-k = "resize height -5"
alt-ctrl-l = "resize width +5"

# Workspace switching
alt-1 = "workspace 1"
alt-2 = "workspace 2"
alt-3 = "workspace 3"
alt-4 = "workspace 4"
alt-5 = "workspace 5"

# Send to workspace
alt-shift-1 = "move-node-to-workspace 1"
alt-shift-2 = "move-node-to-workspace 2"
alt-shift-3 = "move-node-to-workspace 3"
alt-shift-4 = "move-node-to-workspace 4"
alt-shift-5 = "move-node-to-workspace 5"

# Misc
alt-q = "close"

alt-space = "layout tiling"
alt-f = "fullscreen"

# Rules examples
[[on-window-detected]]
if.app-id = "com.apple.finder"
run = ["layout floating"]

[[on-window-detected]]
if.app-id = "com.apple.systempreferences"
run = ["layout floating"]
'';
    };

    file.".wezterm.lua".text = ''
 local wezterm = require 'wezterm'
 local act = wezterm.action
 return {
   font = wezterm.font_with_fallback({ 'FiraCode Nerd Font', 'FiraCode Nerd Font Mono', 'Fira Code' }),
   font_size = 18.0,
   keys = {
     {
       key = 'k', mods = 'SUPER',
       action = act.Multiple{
         act.ClearScrollback 'ScrollbackAndViewport',
         act.SendKey{ key = 'L', mods = 'CTRL' },
       },
     },
     {
       key = 'k', mods = 'CMD',
       action = act.Multiple{
         act.ClearScrollback 'ScrollbackAndViewport',
         act.SendKey{ key = 'L', mods = 'CTRL' },
       },
     },
   },
 }
 '';


    # Duplicate wezterm config skipped; rely on .wezterm.lua



  };
}
