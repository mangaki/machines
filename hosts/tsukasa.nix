{ pkgs, inputs, profilesPath, modulesPath, lib, ... }: {
  imports = [
    inputs.mangaki.nixosModules.mangaki
    ({ ... }: { nixpkgs.overlays = [ inputs.mangaki.overlay ]; })
    "${profilesPath}/scaleway.nix"
    "${profilesPath}/staff.nix"
    # "${modulesPath}/profiles/qemu-guest.nix"
    # "${profilesPath}/dns.nix"
    # "${profilesPath}/nginx.nix"
    # "${profilesPath}/mailserver.nix"
    # "${profilesPath}/mangaki.nix"
  ];

  networking.hostName = "tsukasa";

  services.sshd.enable = true;

  services.mangaki = {
    enable = true;
    useTLS = true;
    useACME = true;
    devMode = false;
    domainName = "beta.mangaki.fr";
    staticRoot = pkgs.mangaki.static;
    envPackage = pkgs.mangaki.env;
  };

  deployment.targetHost = "beta.mangaki.fr";

  environment.systemPackages = with pkgs; [ kitty.terminfo ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "blas" "mkl" "lapack" ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  system.stateVersion = "21.05";
}
