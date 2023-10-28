{stdenv, fetchFromGitHub}:

stdenv.mkDerivation {
    name = "fzf-marks";
    src = fetchFromGitHub {
        owner = "urbainvaes";
        repo = "fzf-marks";
        rev = "ff3307287bba5a41bf077ac94ce636a34ed56d32";
        sha256 = "12bln3pqznj4x906cxv9n9qb0m3wry8lrspqqc8b6jklydwg9b3v";
    };
    installPhase = ''
        cp -r . $out/
    '';

}