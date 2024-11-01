
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
    boot = {
    plymouth = {
      enable = true;
      theme = "optimus";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "optimus" ];
        })
      ];
    };
    
    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  
  loader.timeout = 0;
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  kernelPackages = pkgs.linuxPackages_latest;
};

  networking.hostName = "codi";
 
  #Networking 
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";
  
  #Bluetooth
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = true;
  

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  #FlatHub
  services.flatpak.enable = true;

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true; 
  };
 

  #Nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics ={
 	enable = true;
    	enable32Bit = true;
    };
    nvidia = {
    	modesetting.enable = true;
    	powerManagement.enable = true; 
   	powerManagement.finegrained = true;
    	open = false;
    	nvidiaSettings = true;
    	prime = {
		offload = {
			enable = true;
			enableOffloadCmd = true;
		};
		nvidiaBusId = "PCI:1:0:0";
        	amdgpuBusId = "PCI:5:0:0";
   	};
         forceFullCompositionPipeline = true;
  	 package = config.boot.kernelPackages.nvidiaPackages.production;
   	};
   };
   
   #Open Tablet driver
   hardware.opentabletdriver.enable = true;
   
   #TLP
     services.power-profiles-daemon.enable = false;
     services.tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";
        CPU_BOOST_ON_AC=1;
        CPU_BOOST_ON_BAT=0;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;
        STOP_CHARGE_THRESH_BAT0 = 1;
        START_CHARGE_THRESH_BAT1 = 40;
        STOP_CHARGE_THRESH_BAT1 = 80;
        USB_AUTOSUSPEND= 0;
        PLATFORM_PROFILE_ON_AC="performance";
        PLATFORM_PROFILE_ON_BAT="low-power";
        DISK_APM_LEVEL_ON_AC="255 255";
        DISK_APM_LEVEL_ON_BAT="128 128";
      };
  };
    
  # Define a user account.
  users.users.codingewer = {
    isNormalUser = true;
    description = "codingewer";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  #Programs
  programs = {
        #Steam
	steam = {
  		enable = true;
  		remotePlay.openFirewall = true; 
  		dedicatedServer.openFirewall = true; 
  		gamescopeSession.enable = true; 
  		localNetworkGameTransfers.openFirewall = true;
  		 };
       gamemode.enable = true;
       
       #Hyprland
       hyprland.enable = true;
   };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs.appimage = {
  enable = true;
  binfmt = true;
  };
  
  #ollama
  services.ollama = {
  enable = true;
  acceleration = "cuda";
  }; 
  #services.open-webui.enable = true;  
  #docker
  virtualisation.docker ={
    enable = true;
  };


  

   services.playerctld.enable = true;
   programs.firefox.enable = true;
  #Packages
  environment.systemPackages = with pkgs; [
  starship
  oterm
  superfile
  kitty
  waybar
  blueman
  hypridle
  hyprpaper
  hyprpicker
  hyprshot
  hyprlang
  hyprlock
  nwg-drawer
  nwg-bar
  swaynotificationcenter
  networkmanagerapplet
  vscode
  heroic
  wineWowPackages.stable
  protonup
  mangohud
  gedit
  fish
  fastfetch
  ascii-image-converter
  git
  swayosd
  xfce.thunar
  nwg-look
  cava
  peaclock
  cmatrix
  wofi
  colorls
  clipman
  wl-clipboard
  lxqt.lxqt-policykit
  papirus-icon-theme
  font-manager
  sassc
  busybox
  pavucontrol
  xournalpp
  nerdfonts
  rofi
  bat
  playerctl
  mpv
  nvitop
  btop
  nodejs
  libreoffice-qt
  hunspell
  hunspellDicts.uk_UA
  hunspellDicts.th_TH
  ];

  system.stateVersion = "24.05";

}
