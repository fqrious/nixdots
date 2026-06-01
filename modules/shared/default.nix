{ config, pkgs, lib, ... }:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      # Apply each overlay found in the /overlays directory
      let path = ../../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
          (filter (n: match ".*\\.nix" n != null ||
                      pathExists (path + ("/" + n + "/default.nix")))
                  (attrNames (readDir path)));
  };
  # nix.settings.auto-optimise-store = true;
  nix.enable = false; # Disable Nix on Darwin, as we will use nix-homebrew instead
  nix.gc.automatic = lib.mkForce false; # Disable automatic garbage collection, as we will manage it manually
}
