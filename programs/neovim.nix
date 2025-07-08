{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.lazyvim = {
    enable = true;

    # Enable specific LazyVim extras
    extras = {
      coding = {
        yanky.enable = true;
      };
      editor = {
        dial.enable = true;
        inc-rename.enable = true;
      };
      formatting = {
        prettier.enable = true;
      };
      lang = {
        json.enable = true;
        markdown.enable = true;
        nix.enable = true;
        python.enable = true;
        typescript.enable = true;
        yaml.enable = true;
      };
      ui = {
        mini-indentscope.enable = true;
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
