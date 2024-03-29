{ volume ? "sata-vmdata" }:
let
  mkSubvolume = mp: name: "btrfs subvolume create ${mp}/${name}";
in
{
  deployment.proxmox.disks = [
    ({
      inherit volume;
      size = "20G";
    })
  ];
  fileSystems = {
    "/" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [  "compress=zstd" "discard" "space_cache" "noatime" ];
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };
  };
  swapDevices = [
    { device = "/dev/sda3"; }
  ];
  deployment.proxmox.partitions = ''
    set -x
    set -e
    wipefs -f /dev/sda

    parted --script /dev/sda -- mklabel gpt
    parted --script /dev/sda -- mkpart primary fat32 1MiB 1024MiB
    parted --script /dev/sda -- mkpart primary btrfs 1024MiB -2GiB 
    parted --script /dev/sda -- mkpart primary linux-swap -2GiB 100% 
    parted --script /dev/sda -- set 1 boot on

    sleep 0.5

    mkfs.vfat /dev/sda1 -n NIXBOOT
    mkfs.btrfs /dev/sda2 -f -L nixroot
    mkswap /dev/sda3 -L nixswap
    swapon /dev/sda3

    mount -t btrfs -o defaults,compress=zstd /dev/sda2 /mnt

    mkdir -p /mnt/boot
    mount /dev/sda1 /mnt/boot

    ${mkSubvolume "/mnt" "nix"}
    ${mkSubvolume "/mnt" "home"}
    ${mkSubvolume "/mnt" "var"}
    ${mkSubvolume "/mnt" "etc"}
  '';
}

