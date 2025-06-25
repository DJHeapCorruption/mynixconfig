{ config, pkgs, ... }:

{
  imports = [
    ../hardware-configuration.nix
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

  # X11 + GNOME
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "collier";

  # Enable Gnome Tiling extension via gnome-extension override
  environment.gnome.excludePackages = with pkgs.gnome; [ gnome-tour ];
  services.gnome.core-utilities.enable = true;

  environment.systemPackages = with pkgs; [
    # Terminal & system utilities
    alacritty
    fish
    xclip
    neovim
    wget
    curl
    file
    unzip
    gnutar
    ripgrep
    fd
    xorg.xrandr
    arandr

    # Development
    git
    gnumake
    pkg-config
    rustc
    cargo
    go
    gcc
    gdb
    clang
    cmake

    # GNOME Tweaks and Extensions
    gnome.gnome-tweaks
    gnomeExtensions.pop-shell

    # Browsers and GUI apps
    firefox
    librewolf

    # Network
    networkmanagerapplet
    blueman
    blueberry

    # Audio
    pavucontrol
  ];

  # Pipewire audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # D-Bus and Polkit (GNOME needs these)
  services.dbus.enable = true;
  security.polkit.enable = true;

  # User setup
  users.users.collier = {
    isNormalUser = true;
    description = "John Collier Cobb III";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Enable fish shell
  programs.fish.enable = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
    ];
  };

  # Set system version
  system.stateVersion = "25.05";
}
