{ config, lib, pkgs, ... }: {
  system.stateVersion = "22.05";

  imports = [ ../utils/stylix ];

  environment.systemPackages =
    let sddm-themes = pkgs.callPackage ../packages/sddmThemes { };

    in with pkgs; [
      sddm-themes.sugar-dark
      libsForQt5.qt5.qtgraphicaleffects
      wget
      firefox
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-dropbox-plugin
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      gvfs
      polkit_gnome
      ranger
      alacritty
      nano
      git
      git-crypt
      rofi
      wofi
      emacs
      libnotify
      xfce.xfce4-terminal
      # audio
      pulseaudio

      # Openbox
      obconf
      openbox-menu
      libadwaita
      gtk2
      gtk3

      ## Wayland
      wayland
      wayland-utils
      wdisplays
      wlr-randr

      libcanberra-gtk3
      brightnessctl
      nitrogen
      feh
      autorandr
      arandr
      ## wifi
      iwgtk
      keychain
      libsForQt5.kwallet

      gparted
      ## libby requirements
      jq
      pup
      recode
      fzf

      rofi-rbw
      nix-prefetch-git
      discord

      neofetch
    ];
  services.xserver = {
    enable = true;
    layout = "us"; # # configure keymap
    xkbOptions =
      "terminate:ctrl_alt_bksp, eurosign:e,caps:escape"; # map caps to escape
    libinput.enable =
      true; # Enable touchpad support (enabled default in most desktopManager).
    displayManager = {
      defaultSession = "none+qtile";
      sddm = {
        enable = true;
        # theme = "clairvoyance";
        theme = "sugar-dark";
      };
    };
    windowManager = {
      awesome = { enable = true; };
      qtile = {
        enable = true;
        extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
      };
      openbox.enable = true;
    };
  };

  services.printing.enable = true;
  programs.sway.enable = true;
  programs.dconf.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.neovim = {
    #enable = true;
    vimAlias = true;
    viAlias = true;
    #  defaultEditor = true;
  };

  environment.shells = with pkgs; [ zsh bashInteractive fish ];
  programs.fish.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };
  nix = {
    settings = { auto-optimise-store = true; };
    gc = {
      automatic = true;
      dates = "daily";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  networking.useDHCP = false;
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; # use xkbOptions in tty.
  };
  programs.nm-applet.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "jhilker" ];
      keepEnv = true;
      persist = true;
    }];
  };
  #environment.shellAliases.sudo = "doas $argv";

  security.pam.services = { sddm.enableKwallet = true; };

  security.polkit = { enable = true; };

  services.accounts-daemon.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.fish;
  users.users.jhilker = {
    isNormalUser = true;
    isSystemUser = false;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    initialPassword = "jhilker";
    shell = pkgs.fish;
    home = "/home/jhilker";
    #uid = 999; ## was used for lightdm issue
  };
  fonts = {
    fontconfig = {
      #ultimate.enable = true; # This enables fontconfig-ultimate settings for better font rendering
      defaultFonts = {
        monospace = [ "Roboto Mono" "Josevka Mono" ];
        sansSerif = [ "Roboto" "Josevka Book Sans" ];
        emoji = [ "Twemoji" ];
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
          rev =
            "a07648b1eef52c87670fcd5b567c55493c0b3205"; # # nerd_font_symbols
          sha256 =
            "1g60wi07awxliq9gfypsvp2wjgpg7qz6k1k7iph7iqmjydan3b9k"; # # nerd_font_symbols
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

