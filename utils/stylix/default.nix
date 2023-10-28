{ stylix, inputs, nix-colors, pkgs, config, lib, ... }:
let
  base16-schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "a9112eaae86d9dd8ee6bb9445b664fba2f94037a";
    sha256 = "5yIHgDTPjoX/3oDEfLSQ0eJZdFL1SaCfb9d6M0RmOTM=";
  };
  inherit (nix-colors.lib-contrib { inherit pkgs; })
    gtkThemeFromScheme nixWallpaperFromScheme;
in {
  stylix = {
    base16Scheme = "${base16-schemes}/gruvbox-dark-hard.yaml";
    image = "${nixWallpaperFromScheme {
      scheme = config.colorScheme;
      logoScale = 1.5;
      width = 1920;
      height = 1080;
    }}";
    polarity = "dark";
    fonts = {
      emoji = {
        name = "Twemoji";
        package = pkgs.twemoji-color-font;
      };
      monospace = {
       name = "Roboto Mono";
       package = pkgs.roboto-mono;
      };
      sansSerif = {
        name = "Roboto";
        package = pkgs.roboto;
      };
    };
    autoEnable = false;
  };
}

