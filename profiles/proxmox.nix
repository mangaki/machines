{ ... }:
{
  imports = [
    ./proxmox-profile.nix
    ./proxmox-uefi.nix
    (import ./proxmox-disk.nix {})
  ];

  deployment.targetEnv = "proxmox";
}
