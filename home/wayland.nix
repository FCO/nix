{ pkgs, lib, config, ... }:
{
  # Linux-only compositor config files
  home.file = lib.mkIf pkgs.stdenv.isLinux {
    ".config/sway/config".text = ''
      set $mod Mod4
      font pango:Fira Code 12
      bindsym $mod+Return exec foot
      bindsym $mod+Shift+Return exec wezterm
      bindsym $mod+d exec wofi --show drun
      bindsym $mod+Shift+q kill
      bindsym $mod+h focus left
      bindsym $mod+j focus down
      bindsym $mod+k focus up
      bindsym $mod+l focus right
      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+j move down
      bindsym $mod+Shift+k move up
      bindsym $mod+Shift+l move right
      bindsym $mod+space layout toggle split
      bindsym $mod+f fullscreen toggle
      exec mako
      exec waybar
      exec swww-daemon
      input * xkb_layout br
    '';

    ".config/hypr/hyprland.conf".text = ''
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = NIXOS_OZONE_WL,1
      exec-once = waybar &
      exec-once = mako &
      exec-once = swww-daemon &
      kb_layout = br
      bind = SUPER, RETURN, exec, foot
      bind = SUPER_SHIFT, RETURN, exec, wezterm
      bind = SUPER, D, exec, wofi --show drun
      bind = SUPER_SHIFT, Q, killactive
      bind = SUPER, H, movefocus, l
      bind = SUPER, J, movefocus, d
      bind = SUPER, K, movefocus, u
      bind = SUPER, L, movefocus, r
      bind = SUPER_SHIFT, H, movewindow, l
      bind = SUPER_SHIFT, J, movewindow, d
      bind = SUPER_SHIFT, K, movewindow, u
      bind = SUPER_SHIFT, L, movewindow, r
      bind = SUPER, F, fullscreen, 0
    '';

    ".config/niri/config.kdl".text = ''
      // Minimal Niri config
      config {
        keyboard {
          layout "br"
        }
        startup {
          command "waybar"
          command "mako"
          command "swww-daemon"
        }
        binds {
          bind "Mod4+Return" { exec "foot" }
          bind "Mod4+Shift+Return" { exec "wezterm" }
          bind "Mod4+D" { exec "wofi --show drun" }
          bind "Mod4+Shift+Q" { close }
          bind "Mod4+H" { focus left }
          bind "Mod4+J" { focus down }
          bind "Mod4+K" { focus up }
          bind "Mod4+L" { focus right }
          bind "Mod4+Shift+H" { move left }
          bind "Mod4+Shift+J" { move down }
          bind "Mod4+Shift+K" { move up }
          bind "Mod4+Shift+L" { move right }
          bind "Mod4+F" { fullscreen }
        }
      }
    '';

    ".config/waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "modules-left": ["workspaces"],
        "modules-center": ["clock"],
        "modules-right": ["cpu", "memory", "network", "battery"]
      }
    '';

    ".config/mako/config".text = ''
      font=Fira Code 12
      default-timeout=5000
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#89b4fa
    '';

    ".config/wofi/config".text = ''
      allow_images=true
      width=600
      height=400
      prompt=Run:
    '';
  };
}
