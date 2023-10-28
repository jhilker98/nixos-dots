{ stdenv
, lib
, fetchFromGitHub
, bash
, fzf
, rofi
, subversion
, makeWrapper
}:
  stdenv.mkDerivation {
    pname = "libby";
    version = "1d30163";
    src = fetchFromGitHub {
      # https://github.com/Decad/github-downloader
      owner = "carterprince";
      repo = "libby";
      rev = "1d30163ca0489404f975d75ab50f7c214e6942b5";
      sha256 = "wZ/ILyA+mV3avLCltYm+Coj67Jfn0Lt5b4q05Ixh6J0=";
    };
    buildInputs = [ bash subversion fzf rofi];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp libby $out/bin/libby
      wrapProgram $out/bin/libby \
        --prefix PATH : ${lib.makeBinPath [ bash subversion ]}
    '';
  }
