{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = config.my.variables.full_name;
    userEmail = config.my.variables.code_email;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;

      };
    };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
      settings = {
        editor = "nvim";
        git_protcol = "ssh";
        };
    }; 

   programs.lazygit.enable = true;
  };
}
