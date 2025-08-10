{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  networking.hostName = "store-k-x240";


  
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.store = {
    isNormalUser = true;
    description = "store";
    extraGroups = [ "networkmanager" "wheel" "lp"];
    initialPassword = "changeme";
    packages = with pkgs; [
      kate
      thunderbird
      libreoffice-fresh
      keepassxc
      vorta
      nextcloud-client
      vlc
      #inkscape
      filelight
      isoimagewriter
      chromium
      
      # remote access
      #rustdesk-flutter # not working 25-01, flatpak works
      #anydesk # not working 25-01
      #kdePackages.krfb # not working 25-01
      
    ];
  };

  # Enable automatic login for the user.
  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "store";

  # general
  services.tailscale.enable = true;
  programs.fish.enable = true;
  
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1; # use native KDE file picker
    };
  };
  
  # chromium
  ## check nixos wiki for additional details, hardware accelerated graphics, etc.
  programs.chromium = {
    enable = true; # YOU MUST INSTALL CHROMIUM!! This doesn't actually install Chromium, just enables configuration. Add under user packages aswell. https://discourse.nixos.org/t/programs-chromium-enable-true-does-not-install-chromium/5537/5
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    ];
  };
  
  # KDE apps
  programs.partition-manager.enable = true;

  # flatpak
  services.flatpak.enable = true;


  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

# Printers and Scanners
  services.printing.enable = true; # Enable CUPS to print documents.
  services.printing.drivers = [ 
    pkgs.brlaser
    pkgs.gutenprint
    pkgs.brlaser
    
    ];
  # services.printing.drivers = [ pkgs.carps-cups ]; # driver library for Canon Pixma (Canon MX922) - need to find correct driver package
  hardware.sane.enable = true; # Enable scanner support via SANE
  services.avahi = { ## enable printer and scanner auto discovery
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };  
  
  # Enable sound with pipewire.
#  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

#   boot.loader.grub = {
#     # no need to set devices, disko will add all devices that have a EF02 partition to the list already
#     # devices = [ ];
#     efiSupport = true;
#     efiInstallAsRemovable = true;
#   };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  zramSwap.enable=true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # system packages
  environment.systemPackages = with pkgs; [
    wget
    htop
    btop
    nmap
    tmux
    git
    ntfs3g
    libsForQt5.bluez-qt # bluetooth
    dmidecode
    pciutils
    btrfs-progs
    cryptsetup
    curl

  ];
  
  # Enable Nix flakes and the unified Nix CLI
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  # ssh
  services.openssh.enable = true;
  
  users.users.store.openssh.authorizedKeys.keys = [
	"***"
  ];
  

  ];
  
  
  # Enable Auto Optimising the nix store
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
   system.stateVersion = "24.11"; # Did you read the comment?
}
