self: super: {
  qtile = super.qtile.unwrapped.override (old: rec {
    src = super.fetchFromGitHub {
      owner = "qtile";
      repo = "qtile";
      rev = "5e54027e1cf80f7d909d40d9c6be46a9cf7d9979";  # qtile
      sha256 = '''';  # qtile
    };
    qtile-extras = pkgs.python3Packages.buildPythonPackage {
      pname = "qtile-extras";
      version = "0.1.0";
      src = super.fetchgit {
        url = "https://github.com/elparaguayo/qtile-extras";
        rev = "caee19b0a96480b7de375d83c9e75f0999aa78d2";  # extras
        sha256 = ""          # extras
        leaveDotGit = true;
      };
      doCheck = false;  # do not run tests because it can't find libqtile anyway
      nativeBuildInputs = with pkgs; [ git ];
      buildInputs = with pkgs.python3Packages; [ setuptools_scm ];
      meta = with super.lib; {
        homepage = "https://github.com/elParaguayo/qtile-extras";
        license = licenses.mit;
        description = "Extras for Qtile";
        platforms = platforms.linux;
      };
    };
    propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ (with pkgs; [
      libinput
      libxkbcommon
      pulseaudio
      wayland
      wlroots
      qtile-extras
    ]) ++ (with pkgs.python3Packages; [
      dbus-next
    ]);
  });
}
