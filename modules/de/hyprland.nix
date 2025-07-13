{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "dolphin";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";

      # Monitor configuration - adjust as needed
      monitor = ",preferred,auto,1";

      # Execute on startup
      exec-once = [
        "waybar"
        "hyprpaper"
        "dunst"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(f5c2e7ee) 45deg";
        "col.inactive_border" = "rgba(6c7086aa)";
        layout = "dwindle";
        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 10;
        blur = {
          enabled = false;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a2aee)";
      };

      # Animations - minimal and fast
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 2, myBezier"
          "windowsOut, 1, 2, default, popin 80%"
          "border, 1, 3, default"
          "borderangle, 1, 2, default"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      # Gestures
      gestures = {
        workspace_swipe = true;
      };

      # Misc
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      # Window rules for workspace assignment
      windowrulev2 = [
        # Workspace 1: Terminal/Development
        "workspace 1, class:^(kitty)$"
        "workspace 1, class:^(Alacritty)$"
        "workspace 1, class:^(ghostty)$"
        
        # Workspace 2: Web Browser
        "workspace 2, class:^(firefox)$"
        "workspace 2, class:^(brave-browser)$"
        "workspace 2, class:^(chromium-browser)$"
        "workspace 2, class:^(zen-alpha)$"
        
        # Workspace 3: Communication
        "workspace 3, class:^(discord)$"
        "workspace 3, class:^(Signal)$"
        "workspace 3, class:^(telegram-desktop)$"
        "workspace 3, class:^(thunderbird)$"
        
        # Workspace 4: File Management
        "workspace 4, class:^(dolphin)$"
        "workspace 4, class:^(org.kde.ark)$"
        
        # Workspace 5: Media
        "workspace 5, class:^(mpv)$"
        "workspace 5, class:^(vlc)$"
        "workspace 5, class:^(spotify)$"
        
        # Workspace 6: Documents
        "workspace 6, class:^(libreoffice)$"
        "workspace 6, class:^(okular)$"
        "workspace 6, class:^(evince)$"
        
        # Workspace 7: Development Tools
        "workspace 7, class:^(code)$"
        "workspace 7, class:^(jetbrains)$"
        
        # Workspace 8: System Tools
        "workspace 8, class:^(pavucontrol)$"
        "workspace 8, class:^(nm-connection-editor)$"
        
        # Workspace 9: Gaming
        "workspace 9, class:^(Steam)$"
        "workspace 9, class:^(steam)$"
        "workspace 9, class:^(heroic)$"
        
        # Float rules
        "float, class:^(pavucontrol)$"
        "float, class:^(nm-connection-editor)$"
        "float, class:^(blueman-manager)$"
        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, class:^(Lxappearance)$"
        "float, class:^(.blueman-manager-wrapped)$"
        "float, class:^(qt5ct)$"
        "float, class:^(qt6ct)$"
        
        # Size rules for floating windows
        "size 800 600, class:^(pavucontrol)$"
        "center, class:^(pavucontrol)$"
      ];

      # Keybindings
      bind = [
        # Main bindings
        "$mod, T, exec, $terminal"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, Space, exec, $menu"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, F, fullscreen"
        
        # Move focus with mod + vim keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Move windows with mod + shift + vim keys
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        
        # Resize windows with mod + alt + vim keys
        "$mod ALT, H, resizeactive, -20 0"
        "$mod ALT, L, resizeactive, 20 0"
        "$mod ALT, K, resizeactive, 0 -20"
        "$mod ALT, J, resizeactive, 0 20"
        
        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to workspace with mod + shift + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        
        # Screenshot bindings
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast copy screen"
        "$mod, Print, exec, grimblast save area"
        
        # Media keys
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        
        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        
        # Lock screen
        "$mod, X, exec, hyprlock"
        
        # Browser
        "$mod, B, exec, $browser"
        
        # Clipboard history
        "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Hyprpaper configuration
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/wallpaper.png
    wallpaper = ,~/Pictures/wallpaper.png
    splash = false
    ipc = off
  '';

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "tray"];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            urgent = "";
            focused = "";
            default = "";
          };
        };
        
        "hyprland/window" = {
          max-length = 50;
        };
        
        clock = {
          timezone = "America/Chicago";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        
        cpu = {
          format = " {usage}%";
          tooltip = false;
        };
        
        memory = {
          format = " {}%";
        };
        
        temperature = {
          critical-threshold = 80;
          format = " {temperatureC}°C";
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
        
        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname}";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", FontAwesome, sans-serif;
        font-size: 13px;
      }
      
      window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: .5s;
      }
      
      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }
      
      button:hover {
        background: inherit;
        box-shadow: inset 0 -3px #cdd6f4;
      }
      
      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #cdd6f4;
      }
      
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }
      
      #workspaces button.active {
        background-color: #313244;
        box-shadow: inset 0 -3px #f5c2e7;
      }
      
      #workspaces button.urgent {
        background-color: #f38ba8;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 0 4px;
        color: #cdd6f4;
      }
      
      #battery.charging, #battery.plugged {
        color: #a6e3a1;
      }
      
      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
      }
      
      #network.disconnected {
        background-color: #f38ba8;
      }
      
      #pulseaudio.muted {
        background-color: #313244;
        color: #a6adc8;
      }
      
      #temperature.critical {
        background-color: #f38ba8;
      }
    '';
  };

  # Rofi configuration
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      sidebar-mode = true;
    };
  };

  # Dunst configuration
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x50";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#89b4fa";
        separator_color = "frame";
        sort = "yes";
        font = "JetBrainsMono Nerd Font 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 32;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      urgency_low = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_normal = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#1e1e2e";
        foreground = "#cdd6f4";
        frame_color = "#f38ba8";
        timeout = 0;
      };
    };
  };
}
