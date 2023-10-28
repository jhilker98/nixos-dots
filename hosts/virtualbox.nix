{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ ];

  networking.hostName = "nixos";

  # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
    boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
    boot.loader.grub.theme = pkgs.fetchFromGitHub {
        owner = "x4121";
        repo = "grub-gruvbox";
        rev = "e3e8c3325e63ec214bf214891f50388df10649c1";
        sha256 = "SR7xxmHji2sRTjXOtnOdSk2VQn6zkwcdif6dcrQ/uoI=";
    };

   fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };



  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
