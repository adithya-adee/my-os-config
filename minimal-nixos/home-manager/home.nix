# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [ ];

  nixpkgs = {
    # You can add overlays here
    overlays = [ ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "adithya";
    homeDirectory = "/home/adithya";
    
    # Add your packages here
    packages = with pkgs; [
      # Development
      git
      gh # GitHub CLI
      
      # Terminal utilities
      btop
      htop
      bat
      exa
      ripgrep
      fd
      
      # Archives
      zip
      unzip
      p7zip
    ];
  };

  # Enable programs you want to use
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "adithya";
      userEmail = "adithya25905@gmail.com";  # Uncomment and set your email
    };
    
    bash = {
      enable = true;
      enableCompletion = true;
    };
    
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };
  
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}
