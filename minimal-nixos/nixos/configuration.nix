{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "";
      nix-path = config.nix.nixPath;
      
      # Enable automatic garbage collection
      auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };
    
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Desktop Environment Configuration
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  
  services.gnome = {
    games.enable = false;
    core-developer-tools.enable = true;
  };

  # System Configuration
  networking.hostName = "glitchy_moon";
  services.libinput.enable = true;

  # User Configuration
  users.users.adithya = {
    isNormalUser = true;
    home = "/home/adithya";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    packages = with pkgs; [
      # Browsers
      brave
      google-chrome
      
      # Productivity
      obsidian
      youtube-music
      libreoffice-qt6
      
      # Development
      vscode
      code-cursor
      
      # Communication
      discord
      
      # System tools
      tree
    ];
  };

  # Default shell configuration
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    sway.enable = true;
  };
  users.defaultUserShell = pkgs.zsh;

  # System packages
  environment.systemPackages = with pkgs; [
    # System utilities
    wget
    fastfetch
    git
    unzip
    
    # Terminal
    kitty
    
    # System management
    asusctl
    neovim
    home-manager
  ];

  # Font configuration
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts
  ];

  system.stateVersion = "24.11";
}
