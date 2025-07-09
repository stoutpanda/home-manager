{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./modules/secrets.nix
    ./modules/variables.nix
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/theme.nix
    ./modules/neovim.nix
    ./modules/de/default.nix
  ]
#importing privae variables. 
 ++ lib.optional (builtins.pathExists ./private/variables.nix) ./private/variables.nix;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = config.my.variables.local_user;
  home.homeDirectory = "/home/${config.my.variables.local_user}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # System tools
    pkgs.wget
    pkgs.curl
    pkgs.vim
    pkgs.bitwarden-cli
    pkgs.sqlite
    pkgs.asciinema
    pkgs.du-dust
    pkgs.xh
    pkgs.p7zip
  ];
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jason/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR is now set in programs/neovim.nix
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Fix nix.conf generation
  nix.package = pkgs.nix;

  programs.htop.enable = true;
  programs.btop.enable = true;
  programs.jq.enable = true;
  programs.ripgrep.enable = true;
  programs.lazygit.enable = true;

  # Browser configuration
  modules.browsers = {
    enable = true;
    defaultBrowser = "firefox";
    
    firefox.enable = true;
    chromium.enable = true;
    brave.enable = true;
    ladybird.enable = true;
  };
}
