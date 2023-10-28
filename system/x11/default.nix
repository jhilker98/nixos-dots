{ config, lib, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    layout = "us"; ## configure keymap
    xkbOptions = "terminate:ctrl_alt_bksp, eurosign:e,caps:escape"; # map caps to escape
    libinput.enable = true;  # Enable touchpad support (enabled default in most desktopManager).
    displayManager = {
      defaultSession = "none+qtile"; 
      sddm = {
        enable = true;
        # theme = "clairvoyance";
        theme = "sugar-dark";
      };
    };
    windowManager = {
      awesome = {
        enable = true;
      };
      qtile = {
        enable = true;
        extraPackages = python3Packages: with python3Packages; [
          qtile-extras
        ];
      };
      openbox.enable = true;
    };
  };

  services.printing.enable = true;
  programs.sway.enable = true;
  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
