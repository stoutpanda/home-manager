{ config, lib, pkgs, ... }:

{
  # Enable Thunderbird
  programs.thunderbird = {
    enable = true;

    profiles = {
      default = {
        isDefault = true;
      };
    };
  };

  # Configure email accounts
  accounts.email.accounts = {
    personal = {
      primary = true;
      address = config.my.variables.personal_email;
      realName = config.my.variables.full_name;
      userName = config.my.variables.personal_email;

      imap = {
        host = config.my.variables.email_servers.notacc.imap.host;
        port = config.my.variables.email_servers.notacc.imap.port;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };

      smtp = {
        host = config.my.variables.email_servers.notacc.smtp.host;
        port = config.my.variables.email_servers.notacc.smtp.port;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };

      passwordCommand = "cat ${config.age.secrets.email-personal-password.path}";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };

    # Personal Gmail
    personal-gmail = {
      primary = false;
      address = config.my.variables.personal_gmail;
      realName = config.my.variables.full_name;
      userName = config.my.variables.personal_gmail;

      imap = {
        host = config.my.variables.email_servers.gmail.imap.host;
        port = config.my.variables.email_servers.gmail.imap.port;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };

      smtp = {
        host = config.my.variables.email_servers.gmail.smtp.host;
        port = config.my.variables.email_servers.gmail.smtp.port;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      passwordCommand = "cat ${config.age.secrets.email-personal-gmail-password.path}";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };

    work = {
      primary = false;
      address = config.my.variables.work_email;
      realName = config.my.variables.full_name;
      userName = config.my.variables.work_email;

      imap = {
        host = config.my.variables.email_servers.trendhr.imap.host;
        port = config.my.variables.email_servers.trendhr.imap.port;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };

      smtp = {
        host = config.my.variables.email_servers.trendhr.smtp.host;
        port = config.my.variables.email_servers.trendhr.smtp.port;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      passwordCommand = "cat ${config.age.secrets.email-work-password.path}";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };

    tdfw = {
      primary = false;
      address = config.my.variables.tdfw_email;
      realName = config.my.variables.full_name;
      userName = config.my.variables.tdfw_email;

      imap = {
        host = config.my.variables.email_servers.touchupdfw.imap.host;
        port = config.my.variables.email_servers.touchupdfw.imap.port;
        tls = {
          enable = true;
          useStartTls = false;
        };
      };

      smtp = {
        host = config.my.variables.email_servers.touchupdfw.smtp.host;
        port = config.my.variables.email_servers.touchupdfw.smtp.port;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      passwordCommand = "cat ${config.age.secrets.email-tdfw-password.path}";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };
  };
}
