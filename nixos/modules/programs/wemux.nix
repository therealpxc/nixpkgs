{ config, lib, pkgs, ... }:

with lib;

let 
  
  cfge = config.environment;
  cfg = config.programs.wemux;

in 

{
  options = {
    programs.wemux = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable wemux support.
        '';
        type = types.bool;
      };

      users = mkOption {
        default = [];
        description = ''
          List of usernames for whom to enable wemux hosting.
        '';
        type = types.listOf types.bool;
      };

      allowPairMode = mkOption {
        default = false;
        description = ''
          Allow users to attach to the wemux server in pair mode.
        '';
        type = types.bool;
      };

      allowRogueMode = mkOption {
        default = false;
        description = ''
          Allow users to attach to the wemux server in rogue mode.
        '';
        type = types.bool;
      };

      defaultClientMode = mkOption {
        default = "mirror";
        description = ''
          Overrides default client mode.
        '';
        type = types.str;
      };

      allowKickUser = mkOption {
        default = true;
        description = ''
          Allow hosts to kick SSH users from the server and remove the kicked users' wemux sessions.
        '';
        type = types.bool;
      };

      allowServerChange = mkOption {
        default = false;
        description = ''
          Allow users to change their server for multi-host environments.
        '';
        type = types.bool;
      };

      defaultServerName = mkOption {
        default = "wemux";
        description = ''
          Set name for default wemux server. Will be used with wemux reset and when allow_server_change is disabled.
        '';
        type = types.str;
      };

      allowServerList = mkOption {
        default = false;
        description = ''
          Allow users to list all currently running wemux sockets/servers.
        '';
        type = types.bool;
      };

      allowUserList = mkOption {
        default = false;
        description = ''
          Allow users to see list of currently connected wemux users.
        '';
        type = types.bool;
      };

      announceAttach = mkOption {
        default = true;
        description = ''
          Announce when users attach/detach from a tmux server.
        '';
        type = types.bool;
      };

      announceServerChange = mkOption {
        default = true;
        description = ''
          Announce when users change the wemux server they are using.
        '';
        type = types.bool;
      };

      socketPrefix = mkOption {
        default = "/tmp/wemux";
        description = ''
          Location of tmux socket, will have server name appended to end.
        '';
        type = types.str;
      };

      tmuxOptions = mkOption {
        default = "-u";
        description = ''
          Any commandline options to be passed to tmux.
          Defaults to "-u" to have tmux always attempt to use utf-8 mode.
        '';
        type = types.str;
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Any additional configuration options, to be appended to /etc/wemux.conf.
        '';
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.wemux ];
  };
}
