{ config, pkgs, ... }:

{
  imports = [ ../hardware-configuration.nix ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Timezone & locale
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

  # X11 + GNOME setup
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "collier";

  # PipeWire audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # D-Bus & Polkit
  services.dbus.enable = true;
  security.polkit.enable = true;

  # User setup
  users.users.collier = {
    isNormalUser = true;
    description = "John Collier Cobb III";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Enable Fish
  programs.fish.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Terminals and tools
    alacritty fish xclip neovim wget curl file unzip gnutar ripgrep fd xorg.xrandr arandr

    # Development
    git gnumake pkg-config rustc cargo go gcc gdb clang cmake

    # GNOME Tiling + Tweaks
    gnome-tweaks
    gnomeExtensions.pop-shell

    # Browsers
    firefox librewolf

    # Networking + Bluetooth
    networkmanagerapplet blueman blueberry

    # Audio control
    pavucontrol
  ];

  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
    ];
  };

  # Experimental features and unfree packages
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
