{ agenix, config, pkgs, lib, ... }:

let user = "lullah"; home = "/Users/${user}"; in

{

  imports = lib.unique [
    ../../modules/darwin/secrets.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/shared
    agenix.darwinModules.default
  ];

  
  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Turn off NIX_PATH warnings now that we're using flakes

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });


  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 40;
      };

      dock.persistent-apps = [
        {
          app = "/System/Applications/Messages.app/";
        }
        {
          app = "/System/Applications/Notes.app/";
        }
        {
          app = "${pkgs.alacritty}/Applications/Alacritty.app/";
        }
        {
          app = "/System/Applications/Music.app/";
        }
        {
          app = "/System/Applications/System Settings.app/";
        }
        {
          app = "/Applications/Visual Studio Code.app/";
        }
        {
          app = "/System/Applications/Utilities/Terminal.app/"; 
        }
        {
          app = "/Applications/Google Chrome.app/";
        }
      ];

      finder = {
        _FXShowPosixPathInTitle = false;
        ShowPathbar = true;
        FXRemoveOldTrashItems = true;
      };

      screencapture = {
        location = "${home}/Pictures/Screenshot/";
        type = "png";
        target = "clipboard";
        disable-shadow = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
