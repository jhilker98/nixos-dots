{stdenv, fetchFromGitHub, ...}:
{
    eisvogelTemplate = stdenv.mkDerivation {
        name = "eisvogel-pandoc-template";
        src = fetchFromGitHub {
            owner = "Wandmalfarbe";
            repo = "pandoc-latex-template";
            rev = "0fd152d9d1054b34befcb3c56106d2dd6ebc2c47"; # eisvogel 
            sha256 = "J0INJBMuiK9WKYfeK+TShJXv6BrUdEyeaVfxGQq4kx0="; # eisvogel
        };
        installPhase = ''
            cp -r . $out/
            ls $out/
        '';
    };

}