{ config, lib, pkgs, ... }:
{
  fonts = {
    fontconfig = {
      #ultimate.enable = true; # This enables fontconfig-ultimate settings for better font rendering
      defaultFonts = {
        monospace = ["Roboto Mono" "Josevka Mono"];
        sansSerif = ["Roboto" "Josevka Book Sans"];
        emoji = ["Twemoji"];
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      roboto
      roboto-mono
      #(iosevka.override {
      #  privateBuildPlan = builtins.readFile ./iosevka.toml;
      #  set = "josevka-mono";
      #})
      #(iosevka.override {
      #  privateBuildPlan = builtins.readFile ./iosevka.toml;
      #  set = "josevka-book-sans";
      #})

      terminus_font
      noto-fonts
      twemoji-color-font

      (stdenv.mkDerivation {
        pname = "symbols-nerd-font";
        version = "2.2.0";
        src = fetchFromGitHub {
          owner = "ryanoasis";
          repo = "nerd-fonts";
          rev = "a07648b1eef52c87670fcd5b567c55493c0b3205"; ## nerd_font_symbols
          sha256 = "1g60wi07awxliq9gfypsvp2wjgpg7qz6k1k7iph7iqmjydan3b9k"; ## nerd_font_symbols
          sparseCheckout = ''
            10-nerd-font-symbols.conf
            patched-fonts/NerdFontsSymbolsOnly
          '';
        };
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall

          fontconfigdir="$out/etc/fonts/conf.d"
          install -d "$fontconfigdir"
          install 10-nerd-font-symbols.conf "$fontconfigdir"

          fontdir="$out/share/fonts/truetype"
          install -d "$fontdir"
          install "patched-fonts/NerdFontsSymbolsOnly/complete/Symbols-2048-em Nerd Font Complete.ttf" "$fontdir"

          runHook postInstall
        '';
        enableParallelBuilding = true;
      })


    ];
  };
}
