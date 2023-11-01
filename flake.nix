{
  description = "Jacob's NixOS and home-manager flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-wsl.url = "github:viperML/home-manager-wsl";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    base16-schemes = {
      url = "github:tinted-theming/base16-schemes";
      flake = false;
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    systems.url = "github:nix-systems/x86_64-linux";
    utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };
  outputs = { self, nixpkgs, home-manager, home-manager-wsl, stylix, nix-colors
    , base16-schemes, nix-wallpaper, utils, ... }@inputs:
    {

      nixosConfigurations = let
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
        baseConfig = {
          inherit system;
          specialArgs = { inherit self inputs nix-colors; };
          modules = [
            ./system
            stylix.nixosModules.stylix
            ./system
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit nix-colors; };
                users.jhilker = {
                  imports = [ ./home inputs.nixvim.homeManagerModules.nixvim ];
                };
              };
            }
          ];
        };
      in {
        virtualbox = lib.nixosSystem {
          inherit (baseConfig) system specialArgs;
          modules = baseConfig.modules ++ [
            ./hosts/virtualbox.nix
            home-manager.nixosModules.home-manager
            { home-manager.users.jhilker.imports = [ ./home/desktop ]; }

          ];
        };
        vmware = lib.nixosSystem {
          inherit (baseConfig) system specialArgs;
          modules = baseConfig.modules ++ [
            ./hosts/vmware.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.jhilker.imports =
                [ ./home/desktop ./home/desktop/picom.nix ];
            }
          ];
        };
        netbook = lib.nixosSystem {
          inherit (baseConfig) system specialArgs;
          modules = baseConfig.modules ++ [
            ./hosts/netbook.nix
            ./system/audio
            home-manager.nixosModules.home-manager
            {
              home-manager.users.jhilker.imports =
                [ ./home/desktop ./home/desktop/picom.nix ];
            }
          ];
        };
      };

      homeConfigurations = {
        wsl = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home
            ./home/utils/wsl.nix
            home-manager-wsl.homeModules.default
            { wsl.baseDistro = "ubuntu"; }

            inputs.nixvim.homeManagerModules.nixvim
            stylix.homeManagerModules.stylix
            ./home
          ];
          extraSpecialArgs = { inherit nix-colors; };
        };
      };
    } // utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = rec {
          josevka = pkgs.iosevka.override {
            privateBuildPlan = builtins.readFile ./utils/stylix/plans/josevka.toml;
            set = "josevka";
          };
          josevka-mono = pkgs.iosevka.override {
            privateBuildPlan = builtins.readFile ./utils/stylix/plans/josevka.toml;
            set = "josevka-mono";
          };
          josevka-code = pkgs.iosevka.override {
            privateBuildPlan = builtins.readFile ./utils/stylix/plans/josevka-code.toml;
            set = "josevka-code";
          };

          josevka-book-sans = pkgs.iosevka.override {
            privateBuildPlan = builtins.readFile ./utils/stylix/plans/josevka-book.toml;
            set = "josevka-book-sans";
          };
          josevka-book-slab = pkgs.iosevka.override {
            privateBuildPlan = builtins.readFile ./utils/stylix/plans/josevka-book.toml;
            set = "josevka-book-slab";
          };

        };
      });
}
