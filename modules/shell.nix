{ config, lib, pkgs, ... }:

{
  # Enable Fish shell as primary shell
  programs.fish = {
    enable = true;
    
  };

  # Enable Bash shell
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyFileSize = 10000;
    historySize = 10000;
  };

  # Starship prompt for both shells
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    
  };

  # FZF with shell integrations
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    # File preview
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always --line-range=:100 {}'" ];
    # History search
    historyWidgetOptions = [ "--sort" "--exact" ];
    # Directory navigation
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -100'" ];
  };

  # Eza (modern ls replacement) with shell integrations
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    git = true;
    icons = true;
    
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  # Add useful shell packages
  home.packages = with pkgs; [
    # Shell utilities that work with our config
    fd # Better find, used by fzf
    bat # Better cat, used by fzf preview
    tree # Directory tree view, used by fzf
  ];
}
