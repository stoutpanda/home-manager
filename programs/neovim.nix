{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.lazyvim = {
    enable = true;

    # Enable specific LazyVim extras based on available options
    extras = {
      coding = {
        yanky.enable = true;
      };
      editor = {
        dial.enable = true;
        inc-rename.enable = true;
      };
      lang = {
        nix.enable = true;
      };
      test = {
        core.enable = true;
      };
      util = {
        dot.enable = true;
        mini-hipatterns.enable = true;
      };
    };
  };

  # Additional neovim-specific configurations can go here
  # For example, setting EDITOR environment variable
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
