{ config, lib, pkgs, ... }:

{
  nix = {
    settings = {
     auto-optimise-store = true;
    };
      gc = {
        automatic = true;
        dates = "daily";
      };
       extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

    nixpkgs.config.allowUnfree = true;
}
