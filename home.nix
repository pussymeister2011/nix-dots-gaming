{ config, pkgs, ... }: {
	home.username = "vakh";
	home.homeDirectory = "/home/vakh";
	home.stateVersion = "26.05";

	home.sessionVariables = {
	  GST_PLUGIN_SYSTEM_PATH_1_0 = "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0";
	};

	home.packages = with pkgs; [
		kdePackages.dolphin                  
		kdePackages.kdegraphics-thumbnailers 
		kdePackages.ffmpegthumbs             
		kdePackages.kio-extras
		dconf
		telegram-desktop
		swaybg
		pulseaudio 
		vesktop
		bottles
		nerd-fonts.jetbrains-mono 
	];
	
	programs.kitty = {
	  enable = true;
	  settings = {
	    confirm_os_window_close = 0;
		shell = "${pkgs.zsh}/bin/zsh";			    
		background_opacity = "0.4"; 
	  };
	};
	
	xdg.portal = {
	  enable = true;
	  extraPortals = [
	    pkgs.xdg-desktop-portal-gnome
	    pkgs.xdg-desktop-portal-gtk
	  ];
	  config.niri = {
	    default = [ "gtk" ];
	    "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
	    "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
	  };
	};



	xdg.mimeApps = {
  		enable = true;
  		defaultApplications = {
    		"inode/directory" = [ "org.kde.dolphin.desktop" ];
  		};
	};
	dconf.settings = {
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
		};
	};

	
	
	imports = [
    	    ./modules 
	];					
	programs.home-manager.enable = true;
}

