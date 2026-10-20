# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  xdg.portal.config.common.default = "*";

  hardware.graphics = {
    enable = true;
    enable32Bit = true; 
  };
  
  ##BOOT
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  ##NETWORKING

  networking.hostName = "vakh";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";
  
  ##SERVICES

  # services.printing.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Necessary for 32-bit Steam games!
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.displayManager.sddm = {
    enable = true;
    theme = "pixie";            
    wayland.enable = true;      
    package = pkgs.kdePackages.sddm; 
    extraPackages = [
      pkgs.kdePackages.qtsvg
      pkgs.kdePackages.qtdeclarative
      pkgs.kdePackages.qt5compat
    ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.udisks2.enable = true;

  services.gvfs.enable = true;

  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk  
    ];
  };

  services.upower.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  security.pam.services.swaylock = { }; 
  services.udev.packages = [ pkgs.brightnessctl ]; 
  
  ##USERS & PACKAGES
  services.libinput.enable = true;
  nixpkgs.config.allowUnfree = true;
  users.users.vakh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
  environment.systemPackages = with pkgs; [
    micro
    wget
    git
    (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      background = "/home/vakh/Pictures/wallpaper.jpg"; 
      autoColor = false;    
      backgroundColor = "#1a231e";
      accentColor = "#a9b665";    
      textColor = "#e1e8e2";      
      fontFamily = "JetBrains Mono";
    })
    xwayland
    xwayland-satellite
    protonup-qt
	mangohud 
    protontricks
    ncdu
    brightnessctl
    ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.gamemode.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  networking.firewall.enable = false;

  xdg.menus.enable = true;
  xdg.mime.enable = true;
  services.dbus.enable = true;
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };


  ##FS  (ADD THE PATHS, FS TYPES AND LABELS/UUIDS OF YOUR DISKS 
  #SSD
  ##fileSystems."" = {
  ##  device = "/dev/disk/";
  ##  fsType = ""; 
  ##  options = [ "nofail" "exec" "rw" ];
  ##};
  
  #HDD
  ##fileSystems."" = {
  ##  device = "/dev/disk/";
  ##  fsType = ""; 
  ##  options = [ "nofail" "exec" "rw" ];
  ##};

########################
  nix.settings.auto-optimise-store = true;

  nix.settings.experimental-features = [ "nix-command " "flakes" ];
###############################################
  # system.copySystemConfiguration = true;

  system.stateVersion = "26.05"; 

}

