{ pkgs, config, nix-colors, stylix, ... }: {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
    settings = {
      global = {
        width = 200;
        height = 200;
        origin = "bottom-right";
        offset = "10x50";
        format = ''
          %a
          <i>%s</i>
          %b'';
        align = "right";
      };

    };
  };
  stylix.targets.dunst.enable = true;

  gtk = {
    enable = true;

    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
  };

  #xdg.configFile."qtile/config.py".text = builtins.readFile ./config/qtile/config.py

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    font = "Josevka 12";
    pass.enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji rofi-power-menu rofi-rbw ];
    extraConfig = {
      modi =
        "drun,window,emoji,calc,ssh,p:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      ##      icon-theme = "${config.gtk.iconTheme.name}";
      display-drun = "Apps";
      display-power-menu = "Power Menu";
    };
    theme = "material";
  };
  xdg.configFile."rofi" = {
    source = ../config/rofi;
    recursive = true;
  };

}
