{ config, lib, pkgs, ... }:

{
  services.accounts-daemon.enable = true;
      # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.fish;
  users.users.jhilker = {
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = [ "wheel" "networkmanager"]; # Enable ‘sudo’ for the user.
      initialPassword = "jhilker";
      shell = pkgs.fish;
      home = "/home/jhilker";
        #uid = 999; ## was used for lightdm issue
  };
}
