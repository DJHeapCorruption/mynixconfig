{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # GNOME Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable Gnome Tiling Extension
  environment.gnome.excludePackages = with pkgs.gnome; [ gnome-terminal ];
  services.gnome.core-utilities.enable = true;
  environment.systemPackages = with pkgs; [
    gnomeExtensions.pop-shell
    gnome.gnome-tweaks
  ];

  # Sound and media
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # User
  users.users.collier = {
    isNormalUser = true;
    description = "John Collier Cobb III";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    fish
    git
    neovim
    xclip
    gnome.gnome-tweaks
    gnomeExtensions.pop-shell
    librewolf
    unzip
    ripgrep
    fd
    wget
    rustc cargo
    go
    gcc gdb
    clang cmake
    pkg-config
  ];

  # Flakes support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # State version
  system.stateVersion = "25.05";
}
