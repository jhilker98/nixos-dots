{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.waterNotifier;
in {
  options = {
    services.waterNotifier = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable water break notifier.
        '';
      };
      message = mkOption {
        default = "Drink some water.";
        description = ''
          Message to send.
        '';
      };

      interval = mkOption {
        default = 10;
        description = ''
        How frequently you want to be reminded to drink water, in minutes.
       '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers."water-break" = {
      Unit = {
        Description = "water break notifier";
      };
      Service = {
        PassEnvironment = ["DISPLAY" "PATH"];
        ExecStart = ''
          ${pkgs.libnotify}/bin/notify-send -u 'critical' -a 'waterbot' 'Drink water.' "${builtins.toString cfg.message}"
          '';
      };
      Timer = {
        OnUnitActiveSec = "${builtins.toString cfg.interval}m";
        OnBootSec = "${builtins.toString cfg.interval}m";
        Unit = "water-break.service";
      };
    };
    systemd.user.services."water-break" = {
      Unit.Description = "water break notifier";
      serviceConfig.PassEnvironment = "DISPLAY";
      Service.ExecStart = ''
        ${pkgs.libnotify}/bin/notify-send -u "critical" -a "water-break" "Drink water." "${builtins.toString cfg.message}"
      '';
    };
  };

}
