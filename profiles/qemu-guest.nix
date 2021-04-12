{ pkgs, ... }:
{
  services.udev.extraRules = ''
    SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0", TAG+="systemd" ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"
  '';
  systemd.services.qemu-guest-agent = {
    description = "Run the QEMU Guest Agent";
    serviceConfig = {
      RuntimeDirectory = "qemu-ga";
      ExecStart = "${pkgs.qemu.ga}/bin/qemu-ga -t /var/run/qemu-ga";
      Restart = "always";
      RestartSec = 0;
    };
  };
}
