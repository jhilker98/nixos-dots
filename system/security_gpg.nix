{ config, lib, pkgs, ... }:

{
  programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };

  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = ["jhilker"];
      keepEnv = true;
      persist = true;
    }];
  };
  #environment.shellAliases.sudo = "doas $argv";

  security.pam.services = {
    sddm.enableKwallet = true;
  };

  security.polkit = {
    enable = true;
  };
}
