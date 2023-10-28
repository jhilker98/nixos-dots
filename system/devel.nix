{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    #enable = true;
    vimAlias = true;
    viAlias = true;
  #  defaultEditor = true;
};

  environment.shells = with pkgs; [
    zsh
    bashInteractive
    fish
  ];
  programs.fish.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };
}
