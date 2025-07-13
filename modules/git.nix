{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = config.my.variables.code_user;
    userEmail = config.my.variables.code_email;

    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      
      # Use SSH for git operations
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
        "ssh://git@gitlab.com/" = {
          insteadOf = "https://gitlab.com/";
        };
        "ssh://git@bitbucket.org/" = {
          insteadOf = "https://bitbucket.org/";
        };
      };
    };
    };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
  }; 

  programs.lazygit.enable = true;
}
