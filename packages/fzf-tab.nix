{stdenv, fetchFromGitHub}:

stdenv.mkDerivation {
    name = "fzf-tab";
    src = fetchFromGitHub {
        owner = "Aloxaf";
        repo = "fzf-tab";
        rev = "426271fb1bbe8aa88ff4010ca4d865b4b0438d90";
        sha256 = "RXqEW+jwdul2mKX86Co6HLsb26UrYtLjT3FzmHnwfAA=";
    };
    installPhase = ''
        cp -r . $out/
    '';

}