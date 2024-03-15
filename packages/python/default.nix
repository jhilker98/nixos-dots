{ config, lib, pkgs, python3, fetchFromGitHub, ... }:

{
  bibulous = python3.pkgs.buildPythonApplication rec {
    pname = "bibulous";
    version = "2.0";
    src = fetchFromGitHub {
      owner = "nzhagen";
      repo = "bibulous";
      rev = "ebf1e6ce45991897d86466d60dfc0b49bc32cf8d";
      sha256 = "19ibs4ll31kw8b8mg8g9g77wgzrhchw97kw79flnf5ysbna1ailx";
    };
    postInstall = ''
      mkdir -p $out/bin
      cp bibulous.py $out/bin/
    '';
  };

}
