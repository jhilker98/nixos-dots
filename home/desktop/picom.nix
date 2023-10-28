{ pkgs, config, ...}: {

  services.picom = {
    enable = true;
    package = pkgs.picom.overrideAttrs (old: {
      src = pkgs.fetchFromGitHub {
        owner = "jonaburg";
        repo = "picom";
        rev = "e3c19cd7d1108d114552267f302548c113278d45"; 
        sha256 = "19nglw72mxbr47h1nva9fabzjv51s4fy6s1j893k4zvlhw0h5yp2";
      };
    });
    backend = "glx";
    fade = true;
    fadeDelta = 2;
    activeOpacity = 0.9;
    inactiveOpacity = 0.75;
    opacityRules = [
      "100:class_g='firefox'"
    ];
    settings = {
      blur = {
        method = "dual_kawase";
        blur_strength = 7;
      };
      corner-radius = 5;
    };
  };

}
