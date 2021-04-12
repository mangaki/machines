{ ... }:
{
  imports = [
    ./proxmox-profile.nix
    ./proxmox-uefi.nix
    (import ./proxmox-disk.nix {})
    ./qemu-guest.nix
  ];

  deployment.targetEnv = "proxmox";
}
