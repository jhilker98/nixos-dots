{ config, pkgs, lib, nixvim, stylix, nix-colors, base16-schemes, inputs, ...
}: {
  home.username = "jhilker";
  home.homeDirectory = "/home/jhilker";
  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;
  imports = [
    nix-colors.homeManagerModule
    ../utils/stylix
    ./modules/services/drink-water.nix
  ];
  colorScheme = nix-colors.colorSchemes.gruvbox-dark-hard;

  programs.home-manager.enable = true;
  home.packages = let
    extraNodePkgs = pkgs.callPackage ../packages/node { };
    # Fix any corruptions in the local copy.
    myGitFix = pkgs.writeShellScriptBin "git-fix" ''
      if [ -d .git/objects/ ]; then
      find .git/objects/ -type f -empty | xargs rm -f
      git fetch -p
      git fsck --full
      fi
      exit 1
    '';
  in with pkgs; [
    extraNodePkgs.tailwindcss-document-cli
    extraNodePkgs."@astrojs/language-server"
    texlive.combined.scheme-full
    auctex
    zlib
    (python3.withPackages (p:
      with p; [
        fontforge
        numpy
        pandas
        flask
        virtualenvwrapper
        pip
        # httpx
        pygobject3
      ]))
      act
    wakatime
    ttfautohint
    nodePackages.pyright
    nodejs
    nodePackages.npm
    nodePackages.tailwindcss
    nodePackages.postcss-cli
    nodePackages.typescript
    nodePackages.degit
    nodePackages.postcss
    rustc
    cargo
    go
    thefuck
    jq
    pup
    #libby
    gcc
    binutils
    (ripgrep.override { withPCRE2 = true; })
    gnutls
    gnumake
    fd
    imagemagick
    zstd
    nodePackages.javascript-typescript-langserver
    sqlite
    editorconfig-core-c
    emacs-all-the-icons-fonts
    hugo
    nix-prefetch-git
    ranger
    nodePackages.pnpm
    graphite-cli
    myGitFix
    bitwarden-cli
    nixfmt
    plantuml
    mermaid-cli
    units
  ];
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    # pinentryFlavor = "tty";
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableSshSupport = true;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;
  };
  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ];
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = { XDG_PROJECT_DIR = "${config.home.homeDirectory}/Devel"; };
    };
  };

  xdg.configFile."ranger/plugins/ranger_devicons".source =
    pkgs.fetchFromGitHub {
      owner = "alexanderjeurissen";
      repo = "ranger_devicons";
      rev = "5bb1c32f649055c2d9143c8371c2bf06d5e574f7";
      sha256 = "sha256-97u8yNyfN9vbv4JAvqgFekno3dUyYu265TvpU3ZZqg4=";
    };

  xdg.dataFile."fzf/plugins/fzf-marks" = {
    source = pkgs.fetchFromGitHub {
      owner = "urbainvaes";
      repo = "fzf-marks";
      rev = "ff3307287bba5a41bf077ac94ce636a34ed56d32";
      sha256 = "12bln3pqznj4x906cxv9n9qb0m3wry8lrspqqc8b6jklydwg9b3v";
    };
    recursive = true;
  };

  home.sessionVariables = { "GRAPHITE_IGNORE_GIT_VERSION" = "1"; };

  programs.bash = {
    enable = true;
    shellAliases = {
      ref = "source ~/.bashrc";
      ls = "${pkgs.eza}/bin/eza -alh --group-directories-first";
      cat = "${pkgs.bat}/bin/bat -p";
    };
    initExtra = ''
      source ${config.xdg.dataHome}/fzf/plugins/fzf-marks/fzf-marks.plugin.bash
      function gi {
        toIgnore="$(curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/list | sed 's/,/\n/g' | fzf -m | xargs | sed 's/\s/,/g')"
        curl -sL "https://www.toptal.com/developers/gitignore/api/$toIgnore" >> .gitignore
      }
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };
  services.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };
  xdg.configFile."doom" = {
    source = ./config/doom;
    recursive = true;
  };

  home.sessionVariables."DOOMDIR" = "$HOME/.dotfiles/home/config/doom";

  programs.git = {
    enable = true;
    userName = "Jacob Hilker";
    userEmail = "jacob.hilker2@gmail.com";
    signing = {
      key = "jacob.hilker2@gmail.com";
      signByDefault = true;
    };
    aliases = {
      "cleanup" =
        "grep  -v '\\*\\|master\\|develop\\|dev\\|main' | xargs -n 1 -r git branch -d";
    };
    delta.enable = true;
    extraConfig = {
      init = { defaultBranch = "main"; };
      core = { editor = "nvim"; };
      push = { autoSetupRemote = true; };
      color = { ui = true; };
      format = {
        pretty =
          "%C(italic)(%h)%Creset %C(bold 12)%an%Creset: %C(3)%s %Creset(%ad)";
      };
    };
    ignores = [ "result" "result-*" "node_modules/" ];
  };

  programs.neovim = {
    vimAlias = true;
    viAlias = true;
  };

  programs.nixvim = {
    enable = true;
    options = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2; # Tab width should be 2
      termguicolors = true;
    };
    # command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
    userCommands = {
      FindInFile = {
        bang = true;
        nargs = "*";
        command = ''
          call fzf#vim#grep("rg --column --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)'';
      };
    };
    extraPlugins = with pkgs.vimPlugins; [ nvim-fzf nvim-fzf-commands fzf-vim ];
    colorschemes.base16 = let colors = config.lib.stylix.colors;
    in {
      enable = true;
      colorscheme = colors.scheme-slug;
      customColorScheme = {
        base00 = "#${colors.base00}";
        base01 = "#${colors.base01}";
        base02 = "#${colors.base02}";
        base03 = "#${colors.base03}";
        base04 = "#${colors.base04}";
        base05 = "#${colors.base05}";
        base06 = "#${colors.base06}";
        base07 = "#${colors.base07}";
        base08 = "#${colors.base08}";
        base09 = "#${colors.base09}";
        base0A = "#${colors.base0A}";
        base0B = "#${colors.base0B}";
        base0C = "#${colors.base0C}";
        base0D = "#${colors.base0D}";
        base0E = "#${colors.base0E}";
        base0F = "#${colors.base0F}";
      };
    };
    globals = { mapleader = " "; };
    keymaps = [
      {
        key = "<C-s>";
        action = ":Lines<CR>";
        options.silent = true;
      }
      {
        key = "<C-f>";
        action = ":FindInFile<CR>";
        options.silent = true;
      }
      {
        key = "<leader>hrr";
        action = ":luafile ~/.config/nvim/init.lua<CR>";
        options = {
          silent = true;
          desc = "Source the neovim config";
        };
      }

      {
        key = "<leader>gg";
        action = ":Git<CR>";
        options = {
          silent = true;
          desc = "Git status";
        };
      }

    ];

    plugins = {
      fugitive.enable = true;
      emmet.enable = true;
      lightline = { enable = true; };
      nvim-cmp.enable = true;
      which-key = {
        enable = true;
        keyLabels = {
          " " = "<space>";
          " g" = "Git...";
          " gg" = "Git status";
          " h" = "Help...";
          " hr" = "Reload...";
        };

      };
      treesitter = { enable = true; };
      nvim-autopairs.enable = true;
      nix.enable = true;
      surround.enable = true;
      rainbow-delimiters.enable = true;
      #cmp-nvim-ultisnips.enable = true;
      lsp.enable = true;
      floaterm.enable = true;
    };
  };

  programs.pandoc = {
    enable = true;
    templates =
      let templates = pkgs.callPackage ../packages/pandoc/templates.nix { };
      in { "eisvogel.latex" = "${templates.eisvogelTemplate}/eisvogel.tex"; };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jdinhlife.gruvbox
      vspacecode.vspacecode
    ];
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
    autocd = true;
    dotDir = ".config/zsh";

    shellAliases = {
      ref = "source ~/.config/zsh/.zshrc";
      vim = "nvim $@";
      ls = "${pkgs.eza}/bin/eza -alh --group-directories-first";
      cat = "${pkgs.bat}/bin/bat -p";
    };
    initExtra = let fzf-tab = pkgs.callPackage ../packages/fzf-tab.nix { };
    in ''
      eval $(${pkgs.thefuck}/bin/thefuck --alias)
      source ${pkgs.python3Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh
      source ${fzf-tab}/fzf-tab.plugin.zsh
      source ${config.xdg.dataHome}/fzf/plugins/fzf-marks/fzf-marks.plugin.zsh
      function gi {
        toIgnore="$(curl -sLw "\n" https://www.toptal.com/developers/gitignore/api/list | sed 's/,/\n/g' | fzf -m | xargs | sed 's/\s/,/g')"
        curl -sL "https://www.toptal.com/developers/gitignore/api/$toIgnore" >> .gitignore
      }
      function toWorkOn(){
        workon $(lsvirtualenv -b | fzf)
      }
    '';

    dirHashes = {
      dotfiles = "$HOME/.dotfiles/";
      org = "$HOME/Dropbox/org/";
      roam = "$HOME/Dropbox/roam/";
      cetragore = "$HOME/Devel/sites/cetragore";
    };
  };

  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = { line_break.disabled = true; };
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = { opacity = 0.8; };
  };

  programs.foot = {
    enable = true;
    settings = {

    };
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zathura = { enable = true; };

  programs.ncspot = { enable = true; };

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions
      (exts: [ exts.pass-otp exts.pass-checkup exts.pass-import ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/.password-store";
    };
  };

  services.waterNotifier = { enable = true; };

}
