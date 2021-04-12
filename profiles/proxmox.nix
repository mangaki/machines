{ ... }:
{
  imports = [
    ./proxmox-profile.nix
    (import ./proxmox-disk.nix {})
  ];

  deployment.targetEnv = "proxmox";
}
