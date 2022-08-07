{ config, pkgs, inputs, profilesPath, modulesPath, lib, ... }: {
  imports = [
    inputs.mangaki.nixosModules.mangaki
    ({ ... }: { nixpkgs.overlays = [ inputs.mangaki.overlays.default ]; })
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

  age.secrets.beta-mangaki-secret-file.file = ../secrets/beta-mangaki-secret-file.age;

  services.mangaki = {
    enable = true;
    useTLS = true;
    useACME = true;
    devMode = false;
    domainName = "beta.mangaki.fr";
    staticRoot = pkgs.mangaki.static;
    envPackage = pkgs.mangaki.env;

    # Index is broken for now.
    lifecycle.runTimersForIndex = false;

    settings.secrets.SECRET_KEY = "bullshit";  # FIXME: fix it in master
    settings.secrets.SECRET_FILE = config.age.secrets.beta-mangaki-secret-file.path;
  };
  # We do not have a lot of disk space here.
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
  };
  services.journald.extraConfig = ''
    SystemMaxUse=100M
  '';
  networking.firewall.logRefusedConnections = false;
  deployment.targetHost = "beta.mangaki.fr";
  environment.systemPackages = with pkgs; [ kitty.terminfo ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "blas" "mkl" "lapack" ];

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  system.stateVersion = "21.05";
}
