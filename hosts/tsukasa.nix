{ pkgs, inputs, modulesPath, profilesPath, ... }: {
  imports = [
    inputs.mangaki.nixosModules.mangaki
    ({ ... }: {
      nixpkgs.overlays = [ inputs.mangaki.overlay ];
    })
    "${profilesPath}/proxmox.nix"
    "${profilesPath}/staff.nix"
    # "${modulesPath}/profiles/qemu-guest.nix"
    # "${profilesPath}/proxmox.nix"
    # "${profilesPath}/dns.nix"
    # "${profilesPath}/nginx.nix"
    # "${profilesPath}/mailserver.nix"
    # "${profilesPath}/mangaki.nix"
  ];

  deployment.proxmox.memory = 2048;

  services.mangaki = {
    enable = true;
    useTLS = true;
    devMode = false;
    domainName = "mangaki.v6.lahfa.xyz";
    staticRoot = pkgs.mangaki.static;
    envPackage = pkgs.mangaki.env;
  };

  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];

  system.stateVersion = "21.03";
}
