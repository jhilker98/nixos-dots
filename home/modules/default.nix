{ config, lib, pkgs, ... }:

{
  services.drink-water = import ./services/drink-water.nix;
}
