{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = config.my.variables.full_name;
    userEmail = config.my.variables.code_email;
    
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = false;
      
      # Better diffs
      diff.algorithm = "histogram";
      
      # Helpful aliases
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };
}